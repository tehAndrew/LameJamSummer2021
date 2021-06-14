local Mesh = {}
Mesh.__index = Mesh

function Mesh:create(mesh)
    local obj = {}

    assert(type(mesh) == "table", "Mesh is not a table.")
    assert(#mesh % 2 == 0, "Mesh is not a table with an even number of elements.")
    obj.mesh = mesh

    return setmetatable(obj, Mesh)
end

function Mesh:translate(xTrans, yTrans)
    local transMesh = {}
    
    for i = 1, #(self.mesh) - 1, 2 do
        local xVert, yVert = i, i + 1
        transMesh[xVert] = self.mesh[xVert] + xTrans
        transMesh[yVert] = self.mesh[yVert] + yTrans
    end

    return Mesh:create(transMesh)
end

function Mesh:xRotate(angle)
    local transMesh = {}
    
    for i = 1, #(self.mesh) - 1, 2 do
        local xVert, yVert = i, i + 1
        local angleRad = (angle * 2 * math.pi) / 360
        transMesh[xVert] = self.mesh[xVert]
        transMesh[yVert] = self.mesh[yVert] * math.cos(angleRad)
    end

    return Mesh:create(transMesh)
end

function Mesh:yRotate(angle)
    local transMesh = {}
    
    for i = 1, #(self.mesh) - 1, 2 do
        local xVert, yVert = i, i + 1
        local angleRad = (angle * 2 * math.pi) / 360
        transMesh[xVert] = self.mesh[xVert] * math.cos(angleRad)
        transMesh[yVert] = self.mesh[yVert]
    end

    return Mesh:create(transMesh)
end

function Mesh:zRotate(angle)
    local transMesh = {}
    
    for i = 1, #(self.mesh) - 1, 2 do
        local xVert, yVert = i, i + 1
        local angleRad = (angle * 2 * math.pi) / 360
        transMesh[xVert] = self.mesh[xVert] * math.cos(angleRad) + self.mesh[yVert] * math.sin(angleRad)
        transMesh[yVert] = self.mesh[xVert] * -math.sin(angleRad) + self.mesh[yVert] * math.cos(angleRad)
    end

    return Mesh:create(transMesh)
end

function Mesh:draw()
    love.graphics.line(self.mesh)
end

return Mesh