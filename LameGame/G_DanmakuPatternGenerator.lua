-- INTEGRATE Expression.lua TOMORROW!!!!!!!!!!!!!!!!!

--[[
    G_DanmakuPatternGenerator.lua

    Make sure to set the desired callback functions before generating a danmaku function.
    
    G_DanmakuPatternGenerator.fireCallback should point towards a function that generates a single bullet.

    Note: if unpack does not work, use table.unpack instead!

    ==== SCRIPT SYNTAX ====
    
    == ENTRY POINT ==
    {
        actionList = {
            {[action 1 here]},
            {[action 2 here]},
            ...,
            {[action n here]}
        }
    }
    
    == FIRE ACTION ==
    Fires a bullet with parameters "args"
    {
        action = "fire",
        args = {
            x: number, y: number, speed: number, dir: number, radius: number
        }
    }
    
    == DELAY ACTION ==
    Wait for "waitTime" seconds before next action
    {
        action = "delay",
        args = {
            waitTime: number
        }
    }
    
    == REPEAT ACTION ==
    Repeat the actions in "actionList", "times" times.
    {
        action = "repeat",
        args = {
            times: number, actionList: table of actions
        }
    }
--]]
local Expression = require("Expression")
local DanmakuPattern = require("DanmakuPattern")

G_DanmakuPatternGenerator = {}
G_DanmakuPatternGenerator.fireCallback = function() print("Fire is not implemented.") end

-- Helper ----------
local function parseArgs(args, state)
    local newArgs = {}
    for k, v in pairs(args) do newArgs[k] = Expression.init(v, state) end

    return newArgs
end

-- Structural building blocks ----------
local function codeBlock(...)
    local args = {...}
    for _, f in ipairs(args) do
        f()
    end
end

local function entry(...)
    codeBlock(...)
    coroutine.yield("end")
end

-- State building blocks ----------
local function setVariable(state, args)
    state[args.name] = Expression.init(args.value, state):eval()
end

-- Functional building blocks ----------
local function repeatBlock(runnableCode, args)
    local timesLeft = tonumber(args.times)
    
    while timesLeft > 0 do
        runnableCode()
        timesLeft = timesLeft - 1
    end
end

local function delay(args)
    local timeLeft = tonumber(args.waitTime)
    local elapsedTime = 0

    while timeLeft >= 0 do
        elapsedTime = coroutine.yield("delay")
        timeLeft = timeLeft - elapsedTime
    end
end

local function fire(args)
    G_DanmakuPatternGenerator.fireCallback(args.x:eval(), args.y:eval(), args.speed:eval(), args.dir:eval(), args.radius:eval())
end

-- Recursive danmaku generation function ----------
local function buildAttackFromActionList(state, actionList)
    local functions = {}

    for _, v in ipairs(actionList) do
        if v.action == "delay" then
            table.insert(functions, function() delay(v.args) end)
        elseif v.action == "fire" then
            table.insert(functions, function() fire(parseArgs(v.args, state)) end)
        elseif v.action == "repeat" then
            -- Build sub attack function
            local subAttackBuild = buildAttackFromActionList(state, v.args.actionList)
            local runnableCode = function() codeBlock(unpack(subAttackBuild)) end

            table.insert(functions, function() repeatBlock(runnableCode, v.args) end)
        elseif v.action == "setVar" then
            table.insert(functions, function() setVariable(state, v.args) end)
        end
    end

    return functions
end

-- Public
function G_DanmakuPatternGenerator.buildAttack(attack)
    -- build state
    local state = {}
    for k, v in pairs(attack.main.vars) do state[k] = Expression.init(v, state):eval() end

    -- build attack
    local attackBuild = buildAttackFromActionList(state, attack.main.actionList)

    return DanmakuPattern.init(function() entry(unpack(attackBuild)) end)
end