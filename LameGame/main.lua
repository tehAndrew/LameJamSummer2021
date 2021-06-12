-- Imports
local Bullet = require("Bullet")
local Fishmoose = require("Fishmoose")

local enemyBulletAmount = 0
local enemyBullets = {}

local fishmoose = {}

local tempTimer = 0

-- Main
function love.load()
    love.window.setTitle("Fishmoose VS Bossbird")
    love.window.setMode(480, 640, {})
    math.randomseed(os.time());

    fishmoose = Fishmoose:init(100, 100)
end

function love.update(dt)
    tempTimer = tempTimer + 1;
    if tempTimer >= 3 then
        enemyBulletAmount = enemyBulletAmount + 1;
        enemyBullets[enemyBulletAmount] = Bullet:init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() / 2, 40 + math.random() * 20, math.random() * 360, 3 + math.random() * 5)
        tempTimer = 0
    end

    for i = 1, enemyBulletAmount do
        enemyBullets[i]:update(dt)
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
    for i = 1, enemyBulletAmount do
        enemyBullets[i]:draw()
    end

    fishmoose:draw()

    love.graphics.print(love.timer.getFPS(), 10, 10);
end