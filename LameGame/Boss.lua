local Tween = require("External/tween/tween")

local Boss = {}
Boss.__index = Boss

function Boss.init(xPos, yPos, bossProjectiles)
    local obj = {}
    obj.xPos = xPos
    obj.yPos = yPos
    obj.bossProjectiles = bossProjectiles
    obj.tempTime = 0
    obj.tempTime2 = 0
    obj.tempDir = -math.pi / 2
    obj.radius = 10

    return setmetatable(obj, Boss)
end

function Boss:update(dt)
    self.tempTime = self.tempTime + dt
    self.xPos = love.graphics.getPixelWidth() / 2 + math.sin(self.tempTime * 0.25) * 200

    self.tempTime2 = self.tempTime2 + dt
    if self.tempTime2 >= 0.7 then
        self.tempDir = self.tempDir + 0.1
        self.bossProjectiles:spawnBulletPatternSpreadEvenSpaced(self.xPos, self.yPos, 10, 200, math.pi / 2, self.tempDir, 5, 6)
        self.bossProjectiles:spawnBulletPatternSpreadEvenSpaced(self.xPos, self.yPos, -700, 200, 2 * math.pi, self.tempDir, 10, 10)
        self.tempTime2 = self.tempTime2 - 0.7;
    end
end

function Boss:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 9)
end

return Boss