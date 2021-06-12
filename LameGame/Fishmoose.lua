Fishmoose = {}
Fishmoose.__index = Fishmoose

function Fishmoose:init (xPos, yPos)
    local obj = {}
    obj.xPos = xPos
    obj.yPos = yPos
    obj.radius = 4
    obj.speed = 300

    obj.angle = 0

    obj.mesh = { {-4, -15, 0, -25, 4, -15}, {-4, -15, 4, -15, 13, 0, 0, 38, -13, 0, -4, -15}, {-13, 0, -34, 17, -9, 11}, {13, 0, 34, 17, 9, 11} }

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
    if (self.angle > -6) and (xDir > 0) then
        self.angle = self.angle - dt * 90
    elseif (self.angle < 6) and (xDir < 0) then
        self.angle = self.angle + dt * 90
    elseif self.angle + dt * 90 < 0 then
        self.angle = self.angle + dt * 90
    elseif self.angle - dt * 90 > 0 then
        self.angle = self.angle - dt * 90
    else
        self.angle = 0
    end
end

function Fishmoose:draw ()
    love.graphics.setColor(1, 0, 1)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 9)

    local angleRad = (self.angle * 2 * math.pi) / 360

    -- Transform and render mesh
    for submeshIndex = 1, #(self.mesh) do
        local transMesh = {}
        for vertexIndex = 1, #(self.mesh[submeshIndex]), 2 do
            transMesh[vertexIndex] = self.mesh[submeshIndex][vertexIndex] * math.cos(angleRad) + self.mesh[submeshIndex][vertexIndex + 1] * math.sin(angleRad) + self.xPos;
            transMesh[vertexIndex + 1] = self.mesh[submeshIndex][vertexIndex] * -math.sin(angleRad) + self.mesh[submeshIndex][vertexIndex + 1] * math.cos(angleRad) + self.yPos;
        end
        love.graphics.line(transMesh)
    end
end

function Fishmoose:checkCollision (bullet)
    local dist = (self.xPos - bullet.xPos)^2 + (self.yPos - bullet.yPos)^2

    return dist < self.radius^2 + bullet.radius^2
end

return Fishmoose