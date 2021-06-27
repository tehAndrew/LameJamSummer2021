local Boss = {}
Boss.__index = Boss

function Boss:init(xPos, yPos)
    local obj = {}
    obj.xPos = xPos
    obj.yPos = yPos
    obj.tempTime = 0
    obj.radius = 10

    return setmetatable(obj, Boss)
end

function Boss:update(dt)
    self.tempTime = self.tempTime + dt
    if self.tempTime >= 2 * math.pi then
        self.tempTime = 0;
    end

    self.xPos = math.sin(self.tempTime) * love.graphics.getPixelWidth() / 2 + love.graphics.getPixelWidth() / 2
end

function Boss:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 9)
end

return Boss