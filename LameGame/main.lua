-- Globals
g_bulletAmount = 0
g_bulletArray = {}
g_timer = 0

-- Bullet class
Bullet = {objId = 0, xPos = 0, yPos = 0, xVel = 0, yVel = 0, radius = 5}

function Bullet:new (o, xPos, yPos, speed, dir, radius)
    o = o or {}
    setmetatable(o, self)

    g_bulletAmount = g_bulletAmount + 1

    o.__index = self  
    --self.objId = g_bulletAmount
    o.xPos = xPos or 0
    o.yPos = yPos or 0
    o.radius = radius or 10;

    local dirRad = (dir * 2 * math.pi) / 360
    o.xVel = math.cos(dirRad) * speed
    o.yVel = math.sin(dirRad) * speed

    --g_bulletArray[g_bulletAmount] = o

    return o
end

function Bullet:destroy ()
    for i = self.objId, g_bulletAmount - 1
    do
        g_bulletArray[i] = g_bulletArray[i + 1]
        g_bulletArray[i].objId = g_bulletArray[i].objId - 1
    end
end

function Bullet:update (dt)
    self.xPos = self.xPos + self.xVel * dt
    self.yPos = self.yPos + self.yVel * dt

    if self.xPos < 0 - self.radius or self.xPos > love.graphics.getPixelWidth() + self.radius then
        --self:destroy()
    elseif self.yPos < 0 - self.radius or self.yPos > love.graphics.getPixelHeight() + self.radius then
        --self:destroy()
    end
end

function Bullet:draw ()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.xPos, self.yPos, self.radius, 20)
end

-- Main
function love.load()
    love.window.setTitle("Fishmoose VS Bossbird")
    love.window.setMode(480, 640, {})

    math.randomseed(os.time())
end

b1 = Bullet:new(nil, 80, 40, 10, 0, 10)
b2 = Bullet:new(nil, 20, 80, 7, 90, 7)
b3 = Bullet:new(nil, 80, 10, 5, 180, 5)

function love.update(dt)
    g_timer = g_timer + 1
    if g_timer >= 30 then
        --Bullet:new(nil, love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() / 2, 10 + math.random() * 20, math.random() * 360, 5 + math.random() * 10)
        g_timer = 0
    end
    
    b1:update(dt)
    b2:update(dt)
    b3:update(dt)

    for i = 1, g_bulletAmount
    do
        --g_bulletArray[i]:update(dt)
    end
end

function love.draw()
    b1:draw()
    b2:draw()
    b3:draw()
    
    for i = 1, g_bulletAmount
    do
        --g_bulletArray[i]:draw()
    end

    love.graphics.print(g_bulletAmount, 10, 10)
end