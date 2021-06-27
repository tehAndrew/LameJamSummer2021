local Tween = require("External/tween/tween")

local Boss = {}
Boss.__index = Boss

function Boss:init(_xPos, _yPos)
    local obj = {}
    obj.xPos = _xPos
    obj.yPos = _yPos
    obj.posTween = Tween.new(10, obj, {xPos = 5})
    obj.tempTime = 0
    obj.radius = 10

    return setmetatable(obj, Boss)
end

function Boss:update(dt)
    self.tempTime = self.tempTime + dt
    if self.tempTime >= 2 * math.pi then
        self.tempTime = 0;
    end

    assert(type(dt) == 'number', "kuksug")

    self.posTween:update(dt)
end

function Boss:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 9)
end

return Boss