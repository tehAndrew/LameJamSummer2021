-- Globals
require("G_ResourceLoader")
require("G_DanmakuPatternGenerator")

G_Debug = true

-- Imports
local BossProjectiles = require("BossProjectiles")
local Fishmoose = require("Fishmoose")
local Boss = require("Boss")

local bossProjectiles = {}
local fishmoose = {}
local boss = {}
local danmaku = {}
local attackScript = {
    main = {
        vars = {
            theta = "0"
        },
        actionList = {
            {
                action = "fire",
                args = {x = "400", y = "150", speed = "100", dir = "$theta + 3.14 / 2", radius = "10"}
            },
            {
                action = "fire",
                args = {x = "400", y = "150", speed = "100", dir = "$theta + 2 * (3.14 / 2)", radius = "10"}
            },
            {
                action = "fire",
                args = {x = "400", y = "150", speed = "100", dir = "$theta + 3 * (3.14 / 2)", radius = "10"}
            },
            {
                action = "fire",
                args = {x = "400", y = "150", speed = "100", dir = "$theta + 4 * (3.14 / 2)", radius = "10"}
            },
            {
                action = "setVar",
                args = {name = "theta", value = "$theta + 0.2"}
            },
            {
                action = "delay",
                args = {waitTime = "0.05"}
            }
        }
    }
}

-- Love callbacks
function love.load()
    love.window.setTitle("Bullet Hell")
    love.window.setMode(800, 600, {})
    math.randomseed(os.time());

    G_ResourceLoader.loadMeshResource("ShipMesh")
    G_ResourceLoader.loadShaderResource("MeshShader")

    bossProjectiles = BossProjectiles.init()

    fishmoose = Fishmoose.init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() - 100)
    --boss = Boss.init(love.graphics.getPixelWidth() / 2, 150, bossProjectiles)

    G_DanmakuPatternGenerator.fireCallback = function(x, y, speed, dir, radius) bossProjectiles:spawnBullet(x, y, speed, dir, radius) end
    danmaku = G_DanmakuPatternGenerator.buildAttack(attackScript)

    --shipProjectiles = shipProjectiles:init()
    --ship = ship:init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() - 100, shipProjectiles)
end

function love.update(dt)
    -- Check for potential collisions
    --fishmoose:checkCollision(boss, bossBullets)
    --boss:checkCollision(shipBullets)
    danmaku:update(dt)
    
    fishmoose:update(dt)
    --boss:update(dt)
    --shipProjectiles:update(dt) -- also remove inactive bullets
    bossProjectiles:update(dt) -- also remove inactive bullets
end

function love.draw()
    fishmoose:draw()
    --boss:draw()
    --shipProjectiles:draw()
    bossProjectiles:draw()

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 5);
    love.graphics.print("Bos projectiles: " .. #bossProjectiles.projectiles, 10, 15);
end