-- Globals
require("G_ResourceLoader")

G_Debug = true

-- Imports
local Bullet = require("Bullet")
local Fishmoose = require("Fishmoose")
local Boss = require("Boss")

local fishmoose = {}
local boss = {}

-- Love callbacks
function love.load()
    love.window.setTitle("Bullet Hell")
    love.window.setMode(800, 600, {})
    math.randomseed(os.time());

    G_ResourceLoader.loadMeshResource("ShipMesh")
    G_ResourceLoader.loadShaderResource("MeshShader")

    fishmoose = Fishmoose:init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() - 100);
    boss = Boss:init(love.graphics.getPixelWidth() / 2, 100);

    --shipProjectiles = shipProjectiles:init()
    --bossProjectiles = bossProjectiles:init()
    --ship = ship:init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() - 100, shipProjectiles);
    --boss = Boss:init(love.graphics.getPixelWidth() / 2, 100, bossProjectiles);
end

function love.update(dt)
    -- Check for potential collisions
    --fishmoose:checkCollision(boss, bossBullets)
    --boss:checkCollision(shipBullets)

    fishmoose:update(dt)
    boss:update(dt)
    --shipProjectiles:update(dt) -- also remove inactive bullets
    --bossProjectiles:update(dt) -- also remove inactive bullets
end

function love.draw()
    fishmoose:draw()
    boss:draw()
    --shipProjectiles:draw()
    --bossProjectiles:draw()

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 5);
end