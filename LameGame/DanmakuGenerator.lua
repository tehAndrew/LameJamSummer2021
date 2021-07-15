--[[
    Danmaku script syntax:
    
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

local DanmakuGenerator = {}
DanmakuGenerator.__index = DanmakuGenerator

-- Function building blocks
local function codeBlock(...)
    local args = {...}
    for i, action in ipairs(args) do
        action()
    end
end

local function entry(...)
    codeBlock(...)
    coroutine.yield("end")
end

local function rep(obj, runnableCode, args)
    local timesLeft = args.times
    
    while timesLeft >= 0 do
        runnableCode()
        timesLeft = timesLeft - 1
    end
end

local function delay(args)
    local timeLeft = args.waitTime
    local elapsedTime = 0

    while timeLeft >= 0 do
        elapsedTime = coroutine.yield("delay")
        timeLeft = timeLeft - elapsedTime
    end
end

local function fire(obj, args)
    obj.bossProjectiles:spawnBullet(args.x, args.y, args.speed, args.dir, args.radius)
end

-- buildAttack recursive calls
local function buildAttackFromActionList(obj, actionList)
    local functions = {}

    for _, actionEntry in ipairs(actionList) do
        if actionEntry.action == "delay" then
            table.insert(functions, function() delay(actionEntry.args) end)
        elseif actionEntry.action == "fire" then
            table.insert(functions, function() fire(obj, actionEntry.args) end)
        elseif actionEntry.action == "repeat" then
            local subAttackBuild = buildAttackFromActionList(obj, actionEntry.args.actionList)
            local runnableCode = function() codeBlock(unpack(subAttackBuild)) end

            table.insert(functions, function() rep(obj, runnableCode, actionEntry.args) end)
        end
    end

    return functions
end

function DanmakuGenerator.init(bossProjectiles)
    local obj = {}

    obj.bossProjectiles = bossProjectiles

    return setmetatable(obj, DanmakuGenerator)
end

function DanmakuGenerator:buildAttack(attack)
    local attackBuild = buildAttackFromActionList(self, attack.actionList)

    return function() entry(unpack(attackBuild)) end
end

return DanmakuGenerator