local Transform3D = {}
Transform3D.__index = Transform3D

local function matrixMultiply(m1, m2)
    local newTrans = Transform3D:init()
    
    for i = 1, 3 do
        newTrans.matrix[i] = {}
        for j = 1, 3 do
            newTrans.matrix[i][j] = 0
            for n = 1, 3 do
                newTrans.matrix[i][j] = newTrans.matrix[i][j] + m1[i][n] * m2[n][j]
            end
        end
    end

    return newTrans
end

function Transform3D:init()
    local obj = {}

    obj.matrix = {}
    obj.matrix[1] = {1, 0, 0}
    obj.matrix[2] = {0, 1, 0}
    obj.matrix[3] = {0, 0, 1}

    return setmetatable(obj, Transform3D)
end

function Transform3D:xRotate(angle)
    local rotMatrix = {}
    
    rotMatrix[1] = {1, 0, 0}
    rotMatrix[2] = {0, math.cos(angle), -math.sin(angle)}
    rotMatrix[3] = {0, math.sin(angle), math.cos(angle)}

    return matrixMultiply(self.matrix, rotMatrix)
end

function Transform3D:yRotate(angle)
    local rotMatrix = {}

    rotMatrix[1] = {math.cos(angle), 0, math.sin(angle)}
    rotMatrix[2] = {0, 1, 0}
    rotMatrix[3] = {-math.sin(angle), 0, math.cos(angle)}

    return matrixMultiply(self.matrix, rotMatrix)
end

function Transform3D:zRotate(angle)
    local rotMatrix = {}

    rotMatrix[1] = {math.cos(angle), math.sin(angle), 0}
    rotMatrix[2] = {-math.sin(angle), math.cos(angle), 0}
    rotMatrix[3] = {0, 0, 1}

    return matrixMultiply(self.matrix, rotMatrix)
end

return Transform3D