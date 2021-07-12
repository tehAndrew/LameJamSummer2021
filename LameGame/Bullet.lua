local Bullet = {}
Bullet.__index = Bullet

function Bullet.init(xPos, yPos, speed, dir, radius)
    local obj = {}
    obj.active = true
    obj.xPos = xPos
    obj.yPos = yPos
    obj.radius = radius

    obj.xVel = math.cos(dir) * speed
    obj.yVel = -math.sin(dir) * speed

    return setmetatable(obj, Bullet)
end

function Bullet:update(dt)
    self.xPos = self.xPos + self.xVel * dt
    self.yPos = self.yPos + self.yVel * dt

    if (self.xPos < -self.radius and self.xVel < 0) or (self.xPos >= love.graphics.getPixelWidth() + self.radius and self.xVel >= 0) or (self.yPos < -self.radius and self.yVel < 0) or (self.yPos >= love.graphics.getPixelHeight() + self.radius and self.yVel >= 0) then
        self.active = false;
    end
end

function Bullet:draw()
    love.graphics.setColor(0.8, 0.2, 0)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 15)
end

return Bullet