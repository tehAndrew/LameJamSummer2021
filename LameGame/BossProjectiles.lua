local Bullet = require("Bullet")

local Test = require("Test")
local debug, precondition, preconditionTypeCheck, assertExpr = Test.debug, Test.precondition, Test.preconditionTypeCheck, Test.assertExpr

local BossProjectiles = {}
BossProjectiles.__index = BossProjectiles

function BossProjectiles.init()
    local obj = {}

    obj.projectiles = {}

    return setmetatable(obj, BossProjectiles)
end

function BossProjectiles:update(dt)
    for i = 1, #self.projectiles do
        self.projectiles[i]:update(dt)
    end

    -- Discard dead bullets. Efficient? I don't know.
    for i = #self.projectiles, 1, -1 do
        if not self.projectiles[i].active then
            table.remove(self.projectiles, i)
        end
    end
end

function BossProjectiles:draw()
    for i = 1, #self.projectiles do
        self.projectiles[i]:draw()
    end
end

-- Bullet patterns
function BossProjectiles:spawnBullet(spawnX, spawnY, speed, dir, radius)
    table.insert(self.projectiles, Bullet.init(spawnX, spawnY, speed, dir, radius))
end

function BossProjectiles:spawnBulletPatternSpreadEvenSpaced(spawnX, spawnY, spawnOffset, speed, spread, dir, bulletAmount, radius)
    --debug(preconditionTypeCheck, {spawnX, spawnY, spawnOffset, spread, dir, bulletAmount}, {"number", "number", "number", "number", "number", "number"})
    --debug(precondition, bulletAmount >= 2, "bulletAmount needs to be at least 2.")
    
    local bulletOffset = spread / (bulletAmount - 1)
    local startDir = dir - (spread / 2)

    for currDir = startDir, startDir + spread, bulletOffset do
        self:spawnBullet(spawnX + spawnOffset * math.cos(currDir), spawnY + spawnOffset * -math.sin(currDir), speed, currDir, radius)
    end
end

return BossProjectiles