local Model = require("Model")
local Transform3D = require("Transform3D")
local Tween = require("External/tween/tween")

local xRotate, yRotate, zRotate, translate = Transform3D.xRotate, Transform3D.yRotate, Transform3D.zRotate, Transform3D.translate

local Fishmoose = {}
Fishmoose.__index = Fishmoose

function Fishmoose:init (xPos, yPos)
    local obj = {}
    obj.xPos = xPos
    obj.yPos = yPos

    obj.radius = 4
    obj.focusSpeed = 190
    obj.normalSpeed = 280

    obj.xDir = 0
    obj.yDir = 0
    obj.horAngleTween = nil
    obj.verAngleTween = nil

    obj.horAngle = 0
    obj.verAngle = 0

    obj.model = Model:init("ShipMesh")

    return setmetatable(obj, Fishmoose)
end

function Fishmoose:update (dt)
    local leftDown = love.keyboard.isDown("left")
    local rightDown = love.keyboard.isDown("right")
    local upDown = love.keyboard.isDown("up")
    local downDown = love.keyboard.isDown("down")
    local zDown = love.keyboard.isDown("z")

    local xDirPrev, yDirPrev = self.xDir, self.yDir
    self.xDir, self.yDir = 0, 0

    if not (leftDown and rightDown) then
        if leftDown then self.xDir = -1
        elseif rightDown then self.xDir = 1 end
    end

    if not (upDown and downDown) then
        if upDown then self.yDir = -1
        elseif downDown then self.yDir = 1 end
    end

    local speed = self.normalSpeed
    if zDown then speed = self.focusSpeed end

    local xVel, yVel = speed * self.xDir * dt, speed * self.yDir * dt

    -- Compensate for diagonal movement
    if not (self.xDir == 0 or self.yDir == 0) then
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

    -- dir changed, animate angle
    if xDirPrev ~= self.xDir then
        self.horAngleTween = Tween.new(1.2, self, {horAngle = self.xDir * 0.35}, Tween.easing.outExpo)
    end

    if self.horAngleTween then
        local finished = self.horAngleTween:update(dt)
        if finished then
            self.horAngleTween = nil
        end
    end

    -- dir changed, animate angle
    if yDirPrev ~= self.yDir then
        self.verAngleTween = Tween.new(1.2, self, {verAngle = self.yDir * -0.52}, Tween.easing.outExpo)
    end
 
    if self.verAngleTween then
        local finished = self.verAngleTween:update(dt)
        if finished then
            self.verAngleTween = nil
        end
    end
end

function Fishmoose:draw ()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 9)

    self.model:setTransform(translate(self.xPos, self.yPos) * xRotate(self.verAngle) * yRotate(self.horAngle) * zRotate(-self.horAngle * 0.5))
    self.model:draw()
end

function Fishmoose:checkCollision (bullet)
    local dist = (self.xPos - bullet.xPos)^2 + (self.yPos - bullet.yPos)^2

    return dist < bullet.radius^2
end

return Fishmoose