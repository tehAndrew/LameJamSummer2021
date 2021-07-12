local Test = {}

-- Private
local function genericAssert(expr, errorMsg)
    if type(expr) == 'boolean' then
        if not expr then
            error(errorMsg, 4) -- Error occurs in the function that calls one of the public functions
        end
    else
        error("Arg 1 must be of type 'boolean'.", 2) -- Error occurs in one of the public functions
    end
end

--Public

-- Executes function 'f' if with args '...' if G_Debug is set.
function Test.debug(f, ...)
    if not G_Debug then
        do return end
    end

    genericAssert(type(f) == "function", "Arg 1 must be of type 'function'.")

    local args = {...}
    f(table.unpack(args)) -- TODO find alternative to unpack as it is deprecated
end

-- Throw error with message 'errorMsg' if boolean 'expr' is false.
-- Use at beginning of functions to check preconditions.
function Test.precondition(expr, errorMsg)
    errorMsg = errorMsg or "Unspecified."
    
    genericAssert(expr, "Precondition broken: " .. errorMsg)
end

-- Throw error if an argument in table 'argList' does not match its corresponding type in table 'expectedTypeList'.
function Test.preconditionTypeCheck(argList, expectedTypeList)
    genericAssert(type(argList) == "table" and type(expectedTypeList) == "table", "Args 1 and 2 must be of type 'table'")
    genericAssert(#argList == #expectedTypeList, "The number of args must match the number of types.")

    for i = 1, #argList do
        Test.precondition(type(argList[i]) == expectedTypeList[i], "arg " .. i .. " must be of type " .. expectedTypeList[i] .. ".")
    end
end

-- Throw error with message 'errorMsg' if boolean 'expr' is false.
-- Use whenever errors should not be able to occur.
function Test.assertExpr(expr, errorMsg)
    errorMsg = errorMsg or "Unspecified."

    genericAssert(expr, "Assertion failed: " .. errorMsg)
end

return Test