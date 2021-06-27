-- Globals
require("G_ResourceLoader")

G_Debug = true

-- Imports
local Bullet = require("Bullet")
local Fishmoose = require("Fishmoose")

local enemyBulletAmount = 0
local enemyBullets = {}

local fishmoose = {}

local spawnTimer = 0

-- Love callbacks
function love.load()
    love.window.setTitle("Bullet Hell")
    love.window.setMode(800, 600, {})
    math.randomseed(os.time());

    G_ResourceLoader.loadMeshResource("ShipMesh")
    G_ResourceLoader.loadShaderResource("MeshShader")

    fishmoose = Fishmoose:init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() / 2);
end

function love.update(dt)
    -- spawn
    spawnTimer = spawnTimer + 1;
    if spawnTimer >= 3 then
        enemyBulletAmount = enemyBulletAmount + 1
        enemyBullets[enemyBulletAmount] = Bullet:init(math.random(love.graphics.getPixelWidth()), 0, 80 + math.random() * 50, math.random(50) - 115, math.random(5, 6))
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

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 5);
    love.graphics.print("Bullet #: " .. #enemyBullets, 10, 20);
end