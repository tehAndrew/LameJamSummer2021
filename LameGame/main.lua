-- Globals
require("G_ResourceLoader")

G_Debug = true

-- Imports
local BossProjectiles = require("BossProjectiles")
local Fishmoose = require("Fishmoose")
local Boss = require("Boss")
local DanmakuGenerator = require("DanmakuGenerator")

local bossProjectiles = {}
local fishmoose = {}
local boss = {}
local attackScript = {
    actionList = {
        {
            action = "repeat",
            args = {
                times = 3,
                actionList = {
                    {
                        action = "repeat",
                        args = {
                            times = 3,
                            actionList = {
                                {
                                    action = "fire",
                                    args = {
                                        x = 400, y = 0, speed = 200, dir = -math.pi / 2 + 0.4, radius = 10
                                    }
                                },
                                {
                                    action = "delay",
                                    args = {waitTime = 0.05}
                                },
                                {
                                    action = "fire",
                                    args = {
                                        x = 400, y = 0, speed = 200, dir = -math.pi / 2 - 0.4, radius = 10
                                    }
                                }
                            }
                        }
                    },
                    {
                        action = "delay",
                        args = {waitTime = 0.2}
                    }
                }
            }
        },
        {
            action = "fire",
            args = {
                x = 400, y = 0, speed = 350, dir = -math.pi / 2, radius = 60
            }
        },
        {
            action = "delay",
            args = {waitTime = 1}
        }
    }
}
local attackFun
local attackCo
local msg = ""

-- Love callbacks
function love.load()
    love.window.setTitle("Bullet Hell")
    love.window.setMode(800, 600, {})
    math.randomseed(os.time());

    G_ResourceLoader.loadMeshResource("ShipMesh")
    G_ResourceLoader.loadShaderResource("MeshShader")

    bossProjectiles = BossProjectiles.init()

    fishmoose = Fishmoose.init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() - 100)
    local dg = DanmakuGenerator.init(bossProjectiles)
    --boss = Boss.init(love.graphics.getPixelWidth() / 2, 150, bossProjectiles)

    attackFun = dg:buildAttack(attackScript)

    --shipProjectiles = shipProjectiles:init()
    --ship = ship:init(love.graphics.getPixelWidth() / 2, love.graphics.getPixelHeight() - 100, shipProjectiles)
end

function love.update(dt)
    -- Check for potential collisions
    --fishmoose:checkCollision(boss, bossBullets)
    --boss:checkCollision(shipBullets)
    if msg == "" then
        attackCo = coroutine.create(attackFun)
        _, msg = coroutine.resume(attackCo) -- start attackCo
    elseif msg == "delay" then
        _, msg = coroutine.resume(attackCo, dt) -- send dt to delay
    elseif msg == "end" then
        msg = ""
    end
    
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