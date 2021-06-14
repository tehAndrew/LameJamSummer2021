local Mesh = require("Mesh")

local Fishmoose = {}
Fishmoose.__index = Fishmoose

function Fishmoose:init (xPos, yPos)
    local obj = {}
    obj.xPos = xPos
    obj.yPos = yPos
    obj.radius = 4
    obj.speed = 270

    obj.angle = 0
    obj.angle2 = 0

    obj.beakMesh = Mesh:create({-4, -15, 0, -25, 4, -15})
    obj.bodyMesh = Mesh:create({-4, -15, 4, -15, 13, 0, 0, 38, -13, 0, -4, -15})
    obj.leftWingMesh = Mesh:create({-13, 0, -34, 17, -9, 11})
    obj.rightWingMesh = Mesh:create({13, 0, 34, 17, 9, 11})

    return setmetatable(obj, Fishmoose)
end

function Fishmoose:update (dt)
    local leftDown = love.keyboard.isDown("left")
    local rightDown = love.keyboard.isDown("right")
    local upDown = love.keyboard.isDown("up")
    local downDown = love.keyboard.isDown("down")

    local xDir, yDir = 0, 0

    if not (leftDown and rightDown) then
        if leftDown then xDir = -1
        elseif rightDown then xDir = 1 end
    end

    if not (upDown and downDown) then
        if upDown then yDir = -1
        elseif downDown then yDir = 1 end
    end
    
    local xVel, yVel = self.speed * xDir * dt, self.speed * yDir * dt

    -- Compensate for diagonal movement
    if not (xDir == 0 or yDir == 0) then
        xVel = xVel / math.sqrt(2)
        yVel = yVel / math.sqrt(2)
    end

    -- Collision against wall check
    if self.xPos + xVel < 0 then
        xVel = -self.xPos
    elseif self.xPos + xVel >= love.graphics.getPixelWidth() then
        xVel = love.graphics.getPixelWidth() - self.xPos
    end

    if self.yPos + yVel < 0 then
        yVel = -self.yPos
    elseif self.yPos + yVel >= love.graphics.getPixelHeight() then
        yVel = love.graphics.getPixelHeight() - self.yPos
    end

    self.xPos = self.xPos + xVel
    self.yPos = self.yPos + yVel

    -- Update rotation
    if (self.angle > -8) and (xDir > 0) then
        self.angle = self.angle - 0.8
    elseif (self.angle < 8) and (xDir < 0) then
        self.angle = self.angle + 0.8
    elseif self.angle + 0.8 < 0 then
        self.angle = self.angle + 0.8
    elseif self.angle - 0.8 > 0 then
        self.angle = self.angle - 0.8
    else
        self.angle = 0
    end

    if (self.angle2 > -32) and (yDir > 0) then
        self.angle2 = self.angle2 - 3.2
    elseif (self.angle2 < 32) and (yDir < 0) then
        self.angle2 = self.angle2 + 3.2
    elseif self.angle2 + 3.2 < 0 then
        self.angle2 = self.angle2 + 3.2
    elseif self.angle2 - 3.2 > 0 then
        self.angle2 = self.angle2 - 3.2
    else
        self.angle2 = 0
    end

end

function Fishmoose:draw ()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 9)

    love.graphics.setColor(1, 0, 1)
    self.beakMesh:xRotate(self.angle2):yRotate(self.angle * 4):zRotate(self.angle):translate(self.xPos + self.angle / 4, self.yPos + self.angle2 / 16):draw()
    self.bodyMesh:xRotate(self.angle2):yRotate(self.angle * 4):zRotate(self.angle):translate(self.xPos + self.angle / 4, self.yPos + self.angle2 / 16):draw()
    self.leftWingMesh:xRotate(self.angle2):yRotate(self.angle * 4):zRotate(self.angle):translate(self.xPos + self.angle / 4, self.yPos + self.angle2 / 16):draw()
    self.rightWingMesh:xRotate(self.angle2):yRotate(self.angle * 4):zRotate(self.angle):translate(self.xPos + self.angle / 4, self.yPos + self.angle2 / 16):draw()
end

function Fishmoose:checkCollision (bullet)
    local dist = (self.xPos - bullet.xPos)^2 + (self.yPos - bullet.yPos)^2

    return dist < self.radius^2 + bullet.radius^2
end

return Fishmoose