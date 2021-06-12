Fishmoose = {}
Fishmoose.__index = Fishmoose

function Fishmoose:init (xPos, yPos)
    local obj = {}
    obj.xPos = xPos
    obj.yPos = yPos
    obj.speed = 20

    return setmetatable(obj, Fishmoose)
end

function Fishmoose:move (xDir, yDir)
    local yVel, xVel = self.speed * xDir, self.speed * yDir

    -- Compensate for diagonal movement
    if not (xDir == 0 and yDir == 0) then
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
end

function Fishmoose:draw ()
    love.graphics.setColor(1, 0, 1)
    love.graphics.circle("fill", self.xPos, self.yPos, 20, 20)
end

return Fishmoose