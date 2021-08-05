local byteToCharLookupTable = {
    [string.byte(" ")] = " ",
    [string.byte("$")] = "$",
    [string.byte("+")] = "+",
    [string.byte("-")] = "-",
    [string.byte("*")] = "*",
    [string.byte("/")] = "/",
    [string.byte("(")] = "(",
    [string.byte(")")] = ")",
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
    [string.byte("Z")] = "Z"
}

local function createCharList(expr)
    local byteTable = {string.byte(expr, 1, #expr)}
    local charTable = {}

    for i = 1, #byteTable do
        local char = byteToCharLookupTable[byteTable[i]]
        if (char == nil) then error("Error: illegal char used in expression '" .. expr .. "' at index " .. i .. ".") end

        charTable[i] = char
    end

    return charTable
end

local function tokenizeExpr(expr)
    local charList = createCharList(expr)
    
    local tokenList = {"("}
    
    for i = 1, #charList do
        local char = charList[i]
        
        if char == "+" or char == "*" or char == "/" or char == "(" or char == ")" then
            tokenList[#tokenList + 1] = char
        elseif char == "-" then
            -- Identify if '-'-op is unary or binary. It is unary if
            -- it is the first char in the expression, if it is preceeded
            -- by a left parenthesis or if it is preceeded by another operator.
            local prevToken = tokenList[#tokenList]
            local startsExpr = #tokenList == 0
            local preceededByOp = prevToken == "+" or prevToken == "*" or prevToken == "/" or prevToken == "-" or prevToken == "~"
            local preceededByLeftPar = prevToken == "("
            if startsExpr or preceededByOp or preceededByLeftPar then
                tokenList[#tokenList + 1] = "~"
            else
                tokenList[#tokenList + 1] = char
            end
        elseif tonumber(char) ~= nil then
            local prevToken = tokenList[#tokenList]
            if tonumber(prevToken) ~= nil then
                tokenList[#tokenList] = prevToken .. char
            else
                tokenList[#tokenList + 1] = char
            end
        else -- If variable
            
        end
    end
    
    tokenList[#tokenList + 1] = ")"
    
    return tokenList
end

local function prec(op)
    local precedence
    
    if (op == "~") then
        precedence = 3
    elseif (op == "*" or op == "/") then
        precedence = 2
    elseif (op == "+" or op == "-") then
        precedence = 1
    else
        error("Op must be an operator")
    end
    
    return precedence
end

local function isOp(token)
   return token == "+" or token == "-" or token == "*" or token == "/" or token == "~"
end

local function isLeftAss(op)
   return op ~= "~" -- the only right-associative op used.
end

-- TODO implement support for variables
-- TODO try to save rehashes by implementing my own size var
-- Convert infix to postfix using the shunting-yard algorithm
local function infixToPostfix(infixTokens)
    local postfix = {}
    local opStack = {}
    
    for i = 0, #infixTokens do
        local token = infixTokens[i]
        
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
                if (opStack[#opStack] == nil) then error("Mismatched parenthesis.") end

                postfix[#postfix + 1] = opStack[#opStack]
                opStack[#opStack] = nil
            end

            opStack[#opStack] = nil -- Pop the "(" that inevitably now must be at the top
        else
            postfix[#postfix + 1] = tonumber(token) -- can only be a number
        end
    end
    
    return postfix
end

local Expression = {}
Expression.__index = Expression

function Expression.init(exprStr, varTable)
    local obj = {}

    obj.postfixTokens = infixToPostfix(tokenizeExpr(exprStr))
    obj.varTable = varTable or {}

    return setmetatable(obj, Expression)
end

function Expression:evaluate()
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
        elseif (token == "~") then
            operand1 = operandStack[#operandStack]
            operandStack[#operandStack] = nil
    
            operandStack[#operandStack + 1] = -operand1
        else
            operandStack[#operandStack + 1] = token
        end
    end

    return operandStack[1]
end

return Expression