-- VAD SOM HÄNDE IGÅR: z laddas ej in i scope och x och y hamnar på samma ställe.

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
local DanmakuPattern = require("DanmakuPattern")

G_DanmakuPatternGenerator = {}
G_DanmakuPatternGenerator.fireCallback = function() print("Fire is not implemented.") end

-- Structural building blocks ----------
local function codeBlock(...)
    local args = {...}
    for _, action in ipairs(args) do
        action()
    end
end

local function entry(...)
    codeBlock(...)
    coroutine.yield("end")
end

-- State building blocks ----------
local function setVariable(state, args)
    state[args.name] = tonumber(args.value)
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
    G_DanmakuPatternGenerator.fireCallback(tonumber(args.x), tonumber(args.y), tonumber(args.speed), tonumber(args.dir), tonumber(args.radius))
end

-- Recursive danmaku generation function ----------
local function buildAttackFromActionList(state, actionList)
    local functions = {}

    for _, actionEntry in ipairs(actionList) do
        if actionEntry.action == "delay" then
            table.insert(functions, function() delay(actionEntry.args) end)
        elseif actionEntry.action == "fire" then
            table.insert(functions, function() fire(actionEntry.args) end)
        elseif actionEntry.action == "repeat" then
            -- Build sub attack function
            local subAttackBuild = buildAttackFromActionList(state, actionEntry.args.actionList)
            local runnableCode = function() codeBlock(unpack(subAttackBuild)) end

            table.insert(functions, function() repeatBlock(runnableCode, actionEntry.args) end)
        elseif actionEntry.action == "setVar" then
            table.insert(functions, function() setVariable(state, actionEntry.args) end)
        end
    end

    return functions
end

-- Public
function G_DanmakuPatternGenerator.buildAttack(attack)
    -- build state
    local state = {}
    for k, v in pairs(attack.main.vars) do
        state[k] = tonumber(v)
    end

    -- build attack
    local attackBuild = buildAttackFromActionList(state, attack.main.actionList)

    return DanmakuPattern.init(state, function() entry(unpack(attackBuild)) end)
end