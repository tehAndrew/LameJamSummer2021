--[[ Expression.lua

    TODO: Go through all functions and clean up.
    TODO: clean the evaluate function.
--]]

--[[
    Helpers ---------------------------------------------------------------------
--]]

-- Returns the precedence of an operator. Use to compare operators.
local function prec(op)
    local precedence
    
    if (op == "~" or op == "$") then
        precedence = 4
    elseif (op == "^") then
        precedence = 3
    elseif (op == "*" or op == "/" or op == "%") then
        precedence = 2
    elseif (op == "+" or op == "-") then
        precedence = 1
    else
        error("Op must be an operator")
    end
    
    return precedence
end

-- Returns whether a token is an unary operator or not.
local function isBinaryOp(token)
    return token == "+" or token == "-" or token == "*" or token == "/" or token == "%" or token == "^"
 end

-- Returns whether a token is an operator or not.
local function isOp(token)
   return isBinaryOp(token) or token == "~" or token == "$"
end

-- Returns whether an operator is left-associative or not.
local function isLeftAss(op)
   return op ~= "~" and op ~= "$" and op ~= "^"
end

--[[
    Tokenization of expression strings ---------------------------------------------------------------------
--]]

-- Converting bytes to single character strings this way is faster than using string.char(...).
local byteToCharLookupTable = {
    [string.byte(" ")] = " ",
    [string.byte("$")] = "$",
    [string.byte("+")] = "+",
    [string.byte("-")] = "-",
    [string.byte("*")] = "*",
    [string.byte("/")] = "/",
    [string.byte("%")] = "%",
    [string.byte("^")] = "^",
    [string.byte("(")] = "(",
    [string.byte(")")] = ")",
    [string.byte(".")] = ".",
    [string.byte("0")] = "0",
    [string.byte("1")] = "1",
    [string.byte("2")] = "2",
    [string.byte("3")] = "3",
    [string.byte("4")] = "4",
    [string.byte("5")] = "5",
    [string.byte("6")] = "6",
    [string.byte("7")] = "7",
    [string.byte("8")] = "8",
    [string.byte("9")] = "9",
    [string.byte("a")] = "a",
    [string.byte("b")] = "b",
    [string.byte("c")] = "c",
    [string.byte("d")] = "d",
    [string.byte("e")] = "e",
    [string.byte("f")] = "f",
    [string.byte("g")] = "g",
    [string.byte("h")] = "h",
    [string.byte("i")] = "i",
    [string.byte("j")] = "j",
    [string.byte("k")] = "k",
    [string.byte("l")] = "l",
    [string.byte("m")] = "m",
    [string.byte("n")] = "n",
    [string.byte("o")] = "o",
    [string.byte("p")] = "p",
    [string.byte("q")] = "q",
    [string.byte("r")] = "r",
    [string.byte("s")] = "s",
    [string.byte("t")] = "t",
    [string.byte("u")] = "u",
    [string.byte("v")] = "v",
    [string.byte("w")] = "w",
    [string.byte("x")] = "x",
    [string.byte("y")] = "y",
    [string.byte("z")] = "z",
    [string.byte("A")] = "A",
    [string.byte("B")] = "B",
    [string.byte("C")] = "C",
    [string.byte("D")] = "D",
    [string.byte("E")] = "E",
    [string.byte("F")] = "F",
    [string.byte("G")] = "G",
    [string.byte("H")] = "H",
    [string.byte("I")] = "I",
    [string.byte("J")] = "J",
    [string.byte("K")] = "K",
    [string.byte("L")] = "L",
    [string.byte("M")] = "M",
    [string.byte("N")] = "N",
    [string.byte("O")] = "O",
    [string.byte("P")] = "P",
    [string.byte("Q")] = "Q",
    [string.byte("R")] = "R",
    [string.byte("S")] = "S",
    [string.byte("T")] = "T",
    [string.byte("U")] = "U",
    [string.byte("V")] = "V",
    [string.byte("W")] = "W",
    [string.byte("X")] = "X",
    [string.byte("Y")] = "Y",
    [string.byte("Z")] = "Z",
    [string.byte("_")] = "_"
}

-- Splits a string into a list of single character strings.
local function createCharList(exprStr)
    if (type(exprStr) ~= "string") then error("exprStr must be of type 'string'.") end
    
    local byteTable = {string.byte(exprStr, 1, #exprStr)}
    local charTable = {}

    for i = 1, #byteTable do
        local char = byteToCharLookupTable[byteTable[i]]
        if (char == nil) then error("illegal char used in expression '" .. exprStr .. "' at index " .. i .. ".") end

        charTable[i] = char
    end

    return charTable
end

-- Tokenises exprStr. Negation is identified by the function. This function does not care whether the expression is valid or not.
local function tokenizeExpr(exprStr)
    local charList = createCharList(exprStr)
    
    local tokenList = {"("}

    local scanningNumber, scanningString = false, false
    local char, prevToken
    
    for i = 1, #charList do
        char = charList[i]
        prevToken = tokenList[#tokenList]

        -- Stop scanning for numbers or strings if char is a special character or " "
        if isOp(char) or char == "(" or char == ")" or char == " " then
            scanningNumber, scanningString = false, false
        end
        
        if char == "+" or char == "*" or char == "/" or char == "%" or char == "^" or char == "(" or char == ")" or char == "$" then
            tokenList[#tokenList + 1] = char
        elseif char == "-" then
            local startsExpr = #tokenList == 0
            local preceededByOp = isOp(prevToken)
            local preceededByLeftPar = prevToken == "("

            if startsExpr or preceededByOp or preceededByLeftPar then
                tokenList[#tokenList + 1] = "~"
            else
                tokenList[#tokenList + 1] = char
            end
        elseif char == "." then
            if scanningNumber then
                tokenList[#tokenList] = prevToken .. char
            else
                tokenList[#tokenList + 1] = char
                scanningNumber, scanningString = true, false
            end
        elseif tonumber(char) ~= nil then
            if scanningNumber or scanningString then
                tokenList[#tokenList] = prevToken .. char
            else
                tokenList[#tokenList + 1] = char
                scanningNumber, scanningString = true, false
            end
        elseif char ~= " " then
            if scanningString then
                tokenList[#tokenList] = prevToken .. char
            else
                tokenList[#tokenList + 1] = char
                scanningNumber, scanningString = false, true
            end
        end
    end
    
    tokenList[#tokenList + 1] = ")"
    
    return tokenList
end

--[[
    Infix to postfix conversion ----------------------------------------------------------------------------
--]]

--[[
    Validates an infix expression.
  
    Requires a list of string tokens. Throws an error for infix expressions that are not
    well-formed.

    An infix expression is seen as well-formed by this function if:
        - The following criteria are true for all tokens:
            - if the token is the first token in the list, then it must be a constant operand,
              a unary operator or a '('.
            - if the token is preceeded by a binary operator, a '~' or a '(', then it must be
              a constant operand, unary operator or a '('.
            - if the token is preceeded by a constant operator, variable name or a ')', then
              it must be a binary operator or a ')'.
            - if the token is preceeded by a '$', then it must be a variable name.
        - For every '(' there is a matching ')'
        - Valid variable names can only contain alphanumerical characters and the character
          '_' and can not start with a numerical character. (This is a side effect of how
          expressions strings are tokenized in the tokenizeExpr function).
--]]
local function validateInfix(infixTokens)
    local parStack = {}
    local token, prevToken = nil, nil

    for i = 1, #infixTokens do
        prevToken = token
        token = infixTokens[i]

        if prevToken == nil or prevToken == '(' or isBinaryOp(prevToken) or prevToken == '~' then
            if tonumber(token) == nil and token ~= '~' and token ~= '$' and token ~= '(' then
                if prevToken == nil then error("'" .. token .. "' can not start an expression") end
                error("'" .. token .. "' can not be preceeded by '" .. prevToken .. "'")
            end
        elseif prevToken == '$' then
            if tonumber(token) ~= nil or isOp(token) or token == '(' or token == ')' then
                error("'" .. token .. "' is not a valid variable name.")
            end
        else -- token is operand, varname or ')'
            if not isBinaryOp(token) and token ~= ')' then 
                error("'" .. token .. "' can not be preceeded by '" .. prevToken .. "'") 
            end
        end

        if token == '(' then
            parStack[#parStack + 1] = token
        elseif token == ')' then
            if #parStack == 0 then error('mismatched parenthesis') end
            parStack[#parStack] = nil
        end
    end

    if #parStack ~= 0 then error('mismatched parenthesis') end
end

-- Convert infix to postfix using the shunting-yard algorithm. Assumes infix is well formed.
local function infixToPostfix(infixStr)
    local infixTokens = tokenizeExpr(infixStr)
    validateInfix(infixTokens)
    
    local postfix = {}
    local opStack = {}
    
    local token
    for i = 0, #infixTokens do
        token = infixTokens[i]
        
        if token == "(" then
            opStack[#opStack + 1] = token
        elseif isOp(token) then
            while isOp(opStack[#opStack]) and
                (
                    prec(opStack[#opStack]) > prec(token) or
                    (
                        prec(opStack[#opStack]) == prec(token) and
                        isLeftAss(token)
                    )
                )
            do
                postfix[#postfix + 1] = opStack[#opStack]
                opStack[#opStack] = nil
            end
            
            opStack[#opStack + 1] = token
        elseif token == ")" then
            while opStack[#opStack] ~= "(" do
                postfix[#postfix + 1] = opStack[#opStack]
                opStack[#opStack] = nil
            end

            opStack[#opStack] = nil -- Pop the "(" that inevitably now must be at the top
        else
            if tonumber(token) ~= nil then postfix[#postfix + 1] = tonumber(token)
            else postfix[#postfix + 1] = token end
        end
    end
    
    
    return postfix
end

--[[
    Expression metatable -----------------------------------------------------------------------------------
--]]

local Expression = {}
Expression.__index = Expression

function Expression.init(exprStr, varTable)
    local obj = {}

    obj.postfixTokens = infixToPostfix(exprStr)
    obj.varTable = varTable or {}

    return setmetatable(obj, Expression)
end

function Expression:eval()
    local operandStack = {}

    for i = 0, #self.postfixTokens do
        local token = self.postfixTokens[i]
        local operand1, operand2

        if (token == "+") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
            operand2 = operandStack[#operandStack]
            operandStack[#operandStack] = nil

            operandStack[#operandStack + 1] = operand2 + operand1
        elseif (token == "-") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
            operand2 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
    
            operandStack[#operandStack + 1] = operand2 - operand1
        elseif (token == "*") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
            operand2 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
    
            operandStack[#operandStack + 1] = operand2 * operand1
        elseif (token == "/") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
            operand2 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
    
            operandStack[#operandStack + 1] = operand2 / operand1
        elseif (token == "%") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
            operand2 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
    
            operandStack[#operandStack + 1] = operand2 % operand1
        elseif (token == "^") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
            operand2 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
    
            operandStack[#operandStack + 1] = operand2 ^ operand1
        elseif (token == "~") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
    
            operandStack[#operandStack + 1] = -operand1
        elseif (token == "$") then
            local variableName = operandStack[#operandStack]
            operandStack[#operandStack] = nil

            if self.varTable[variableName] == nil then
                error("variable '" .. variableName .. "' is not defined.")
            end
    
            operandStack[#operandStack + 1] = self.varTable[variableName]
        else
            operandStack[#operandStack + 1] = token
        end
    end

    return operandStack[1]
end

return Expression