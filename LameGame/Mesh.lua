local Mesh = {}
Mesh.__index = Mesh

function Mesh:init (...)
    local obj = {}

    for i = 1, arg.n do
        assert(type(arg[i]) == "table", "Arg " .. i .. " is not a table.")
        assert(#arg[i] % 2 == 0, "Arg " .. i .. " is not a table with an even number of elements.")
        obj.submesh[i] = arg[i]
    end

    return setmetatable(obj, Mesh)
end

function Mesh:translateSubmesh (submeshIndex, xTrans, yTrans)
    local transMesh = {}
    
    for i = 1, #(self.submesh) - 1, 2 do
        local xVert, yVert = i, i + 1
        transMesh[xVert] = self.submesh[submeshIndex][xVert] + xTrans
        transMesh[yVert] = self.submesh[submeshIndex][yVert] + yTrans
    end

    return transMesh
end
-- Transform and render mesh 2D
    --
    --  Z rotation matrix 2D
    --  | cos(angleRad)  sin(angleRad) |
    --  | -sin(angleRad) cos(angleRad) |
    --
    --  X rotation matrix 2D
    --  | 1 0              |
    --  | 0 cos(angleRad2) |
function Mesh:zRotateSubmesh (submeshIndex, angle)
    local transMesh = {}
    
    for i = 1, #(self.submesh) - 1, 2 do
        local xVert, yVert = i, i + 1
        local angleRad = (angle * 2 * math.pi) / 360
        transMesh[xVert] = self.mesh[submeshIndex][xVert] * math.cos(angleRad) - self.mesh[submeshIndex][yVert] * math.sin(angleRad)
        transMesh[yVert] = self.mesh[submeshIndex][xVert] * math.sin(angleRad) + self.mesh[submeshIndex][yVert] * math.cos(angleRad)
    end

    return transMesh
end

function Mesh:xRotateSubmesh (submeshIndex, angle)
    local transMesh = {}
    
    for i = 1, #(self.submesh) - 1, 2 do
        local xVert, yVert = i, i + 1
        local angleRad = (angle * 2 * math.pi) / 360
        transMesh[xVert] = self.mesh[submeshIndex][xVert]
        transMesh[yVert] = self.mesh[submeshIndex][yVert] * math.cos(angleRad);
    end

    return transMesh
end