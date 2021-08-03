-- Seems to be faster to precompute this than using string.byte on the fly.
local byteToCharLookupTable = {
    [string.byte(" ")] = " ",
    [string.byte("$")] = "$",
    [string.byte("+")] = "+",
    [string.byte("-")] = "-",
    [string.byte("*")] = "*",
    [string.byte("/")] = "/",
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

local function exprStrToCharTable(expr)
    local byteTable = {string.byte(expr, 1, #expr)}
    local charTable = {}

    for i = 1, #byteTable do
        local char = byteToCharLookupTable[byteTable[i]]
        if (char == nil) then error("Error: illegal char used in expression " .. expr .. " at index " .. i .. ".") end

        charTable[i] = char
    end

    return charTable
end

local function formString(charTable)
    local str = ""

    for i = 1, #charTable do
        str = str .. charTable[i]
    end

    return str
end

local function tokenizeExpr(expr)
    local charTable = exprStrToCharTable(expr)
    
    local tokens = {}

    for i = 1, #charTable do
        
    end
end