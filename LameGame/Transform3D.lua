local Transform3D = {}
Transform3D.__index = Transform3D

function Transform3D.__mul(lhs, rhs)
    local newTrans = Transform3D.identity()
    
    for i = 1, 4 do
        newTrans[i] = {}
        for j = 1, 4 do
            newTrans[i][j] = 0
            for n = 1, 4 do
                newTrans[i][j] = newTrans[i][j] + lhs[i][n] * rhs[n][j]
            end
        end
    end

    return newTrans
end

function Transform3D.instanceOf(t)
    return getmetatable(t) == Transform3D
end

-- Generates an identity transform.
function Transform3D.identity()
    local obj = {}

    obj[1] = {1, 0, 0, 0}
    obj[2] = {0, 1, 0, 0}
    obj[3] = {0, 0, 1, 0}
    obj[4] = {0, 0, 0, 1}

    return setmetatable(obj, Transform3D)
end

-- Generates a rotation transformation that rotates 'angle' rads around the x-axis.
function Transform3D.xRotate(angle)
    local obj = {}

    angle = angle or 0
    
    obj[1] = {1, 0, 0, 0}
    obj[2] = {0, math.cos(angle), -math.sin(angle), 0}
    obj[3] = {0, math.sin(angle), math.cos(angle), 0}
    obj[4] = {0, 0, 0, 1}

    return setmetatable(obj, Transform3D)
end

-- Generates a rotation transformation that rotates 'angle' rads around the y-axis.
function Transform3D.yRotate(angle)
    local obj = {}

    angle = angle or 0

    obj[1] = {math.cos(angle), 0, math.sin(angle), 0}
    obj[2] = {0, 1, 0, 0}
    obj[3] = {-math.sin(angle), 0, math.cos(angle), 0}
    obj[4] = {0, 0, 0, 1}

    return setmetatable(obj, Transform3D)
end

-- Generates a rotation transformation that rotates 'angle' rads around the z-axis.
function Transform3D.zRotate(angle)
    local obj = {}

    angle = angle or 0

    obj[1] = {math.cos(angle), math.sin(angle), 0, 0}
    obj[2] = {-math.sin(angle), math.cos(angle), 0, 0}
    obj[3] = {0, 0, 1, 0}
    obj[4] = {0, 0, 0, 1}

    return setmetatable(obj, Transform3D)
end

-- Generates a translation matrix that sets the origin to {x, y, z}.
function Transform3D.translate(x, y, z)
    local obj = {}

    x = x or 0
    y = y or 0
    z = z or 0

    obj[1] = {1, 0, 0, x}
    obj[2] = {0, 1, 0, y}
    obj[3] = {0, 0, 1, z}
    obj[4] = {0, 0, 0, 1}

    return setmetatable(obj, Transform3D)
end

return Transform3D