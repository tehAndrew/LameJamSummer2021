-- Imports
local Bullet = require("Bullet")
local Fishmoose = require("Fishmoose")
local Mesh2 = require("Mesh2")
local T = require("Transform3D")

local enemyBulletAmount = 0
local enemyBullets = {}

local fishmoose = {}

local spawnTimer = 0

local angle1, angle2, angle3 = 0, 0, 0
local x, y = 0, 0

-- Love calbacks
function love.load()
    love.window.setTitle("Fishmoose VS Bossbird")
    love.window.setMode(480, 640, {})
    math.randomseed(os.time());

    fishmoose = Fishmoose:init(0, 0);
end

function love.update(dt)
    -- spawn
    spawnTimer = spawnTimer + 1;
    if spawnTimer >= 10 then
        enemyBulletAmount = enemyBulletAmount + 1
        enemyBullets[enemyBulletAmount] = Bullet:init(math.random(love.graphics.getPixelWidth()), 0, 80 + math.random() * 50, math.random(50) - 115, math.random(5, 7))
        spawnTimer = 0
    end

    -- update
    fishmoose:update(dt)

    for i = 1, enemyBulletAmount do
        enemyBullets[i]:update(dt)
    end

    -- fishmoose/bullet collision
    for i = 1, enemyBulletAmount do
        if fishmoose:checkCollision(enemyBullets[i]) then
            enemyBullets[i].active = false;
        end
    end

    -- remove inactive bullets
    for i = enemyBulletAmount, 1, -1 do
        if not enemyBullets[i].active then
            table.remove(enemyBullets, i)
            enemyBulletAmount = enemyBulletAmount - 1
        end
    end

    
end

function love.draw()
    fishmoose:draw()

    for i = 1, enemyBulletAmount do
        enemyBullets[i]:draw()
    end

    love.graphics.print(love.timer.getFPS(), 10, 10);
end