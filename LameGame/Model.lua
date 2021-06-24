local Test = require("Test")
local debug, precondition = Test.debug, Test.precondition

local Transform3D = require("Transform3D")

Model = {}
Model.__index = Model

-- Public
function Model:init(meshName)
    debug(precondition, type(meshName) == 'string', "Argument 1 is not of type 'string'.")

    local obj = {}
    
    obj.transform = love.math.newTransform(0, 0) -- identity transform
    obj.mesh = G_ResourceLoader.getResource("mesh", "ShipMesh")
    obj.shader = G_ResourceLoader.getResource("shader", "MeshShader")

    return setmetatable(obj, Model)
end

function Model:setTransform(t)
    if G_Debug then
        precondition(Transform3D.isValid(t), "Argument 1 is not of type 'Transform3D'.")
    end

    self.transform:setMatrix(t.matrix[1][1], t.matrix[1][2], t.matrix[1][3], t.matrix[1][4], t.matrix[2][1], t.matrix[2][2], t.matrix[2][3], t.matrix[2][4], t.matrix[3][1], t.matrix[3][2], t.matrix[3][3], t.matrix[3][4], 0, 0, 0, 1)
end

function Model:draw()
    love.graphics.push("all")

    love.graphics.setShader(self.shader)
    love.graphics.draw(self.mesh, self.transform)

    love.graphics.pop()

end

return Model