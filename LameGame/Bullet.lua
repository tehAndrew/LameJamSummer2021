-- Test making Bullet local

Bullet = {}
Bullet.__index = Bullet

function Bullet:init (xPos, yPos, speed, dir, radius)
    local obj = {}
    obj.active = true
    obj.xPos = xPos
    obj.yPos = yPos
    obj.radius = radius

    local dirRad = (dir * 2 * math.pi) / 360
    obj.xVel = math.cos(dirRad) * speed
    obj.yVel = -math.sin(dirRad) * speed

    return setmetatable(obj, Bullet)
end

function Bullet:update (dt)
    self.xPos = self.xPos + self.xVel * dt
    self.yPos = self.yPos + self.yVel * dt

    if self.xPos < -self.radius or self.xPos >= love.graphics.getPixelWidth() + self.radius or self.yPos < -self.radius or self.yPos >= love.graphics.getPixelHeight() + self.radius then
        self.active = false;
    end
end

function Bullet:draw ()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 20)
end

return Bullet