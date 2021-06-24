local Transform3D = {}
Transform3D.__index = Transform3D

local function matrixMultiply(m1, m2)
    local newTrans = Transform3D:init()
    
    for i = 1, 4 do
        newTrans.matrix[i] = {}
        for j = 1, 4 do
            newTrans.matrix[i][j] = 0
            for n = 1, 4 do
                newTrans.matrix[i][j] = newTrans.matrix[i][j] + m1[i][n] * m2[n][j]
            end
        end
    end

    return newTrans
end

function Transform3D.init()
    local obj = {}

    obj.matrix = {}
    obj.matrix[1] = {1, 0, 0, 0}
    obj.matrix[2] = {0, 1, 0, 0}
    obj.matrix[3] = {0, 0, 1, 0}
    obj.matrix[4] = {0, 0, 0, 1}

    return setmetatable(obj, Transform3D)
end

function Transform3D.isValid(t)
    return type(t) == 'table' and getmetatable(t) == Transform3D
end

function Transform3D:xRotate(angle)
    local rotMatrix = {}

    angle = angle or 0
    
    rotMatrix[1] = {1, 0, 0, 0}
    rotMatrix[2] = {0, math.cos(angle), -math.sin(angle), 0}
    rotMatrix[3] = {0, math.sin(angle), math.cos(angle), 0}
    rotMatrix[4] = {0, 0, 0, 1}

    return matrixMultiply(self.matrix, rotMatrix)
end

function Transform3D:yRotate(angle)
    local rotMatrix = {}

    angle = angle or 0

    rotMatrix[1] = {math.cos(angle), 0, math.sin(angle), 0}
    rotMatrix[2] = {0, 1, 0, 0}
    rotMatrix[3] = {-math.sin(angle), 0, math.cos(angle), 0}
    rotMatrix[4] = {0, 0, 0, 1}

    return matrixMultiply(self.matrix, rotMatrix)
end

function Transform3D:zRotate(angle)
    local rotMatrix = {}

    angle = angle or 0

    rotMatrix[1] = {math.cos(angle), math.sin(angle), 0, 0}
    rotMatrix[2] = {-math.sin(angle), math.cos(angle), 0, 0}
    rotMatrix[3] = {0, 0, 1, 0}
    rotMatrix[4] = {0, 0, 0, 1}

    return matrixMultiply(self.matrix, rotMatrix)
end

function Transform3D:translate(x, y, z)
    local rotMatrix = {}

    x = x or 0
    y = y or 0
    z = z or 0

    rotMatrix[1] = {1, 0, 0, x}
    rotMatrix[2] = {0, 1, 0, y}
    rotMatrix[3] = {0, 0, 1, z}
    rotMatrix[4] = {0, 0, 0, 1}

    return matrixMultiply(self.matrix, rotMatrix)
end

return Transform3D