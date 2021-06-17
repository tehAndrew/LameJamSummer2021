Model = {}
Model.__index = Model

local T = require("Transform3D")

function Model:init(vertices, indices)
    local obj = {}

    local attrLayout = {{"VertexPosition", "float", 3}} -- VertexPosition will be interpreted as vertex position automatically by glsl

    local vertexList = {}
    for i = 1, #vertices do
        vertexList[i] = {vertices[i][1], vertices[i][2], vertices[i][3]}
    end

    obj.mesh = love.graphics.newMesh(attrLayout, vertexList, "triangles", "dynamic") -- TODO Try change to static later
    obj.mesh:setVertexMap(indices)
    
    obj.transform = love.math.newTransform(0, 0) -- identity transform

    local shaderCode = [[
    varying float depth;

    mat4 orthoProj(float left, float right, float bottom, float top, float near, float far)
    {   
        vec3 scale = vec3(2.f / (right - left), 2.f / (top - bottom), -2.f / (far - near));
        vec3 trans = vec3(-(right + left) / (right - left), -(top + bottom) / (top - bottom), -(far + near) / (far - near));

        vec4 m1 = vec4(scale.x, 0.f,     0.f,      0.f);
        vec4 m2 = vec4(0.f,     scale.y, 0.f,      0.f);
        vec4 m3 = vec4(0.f,     0.f,     scale.z,  0.f);
        vec4 m4 = vec4(trans.x, trans.y, trans.z,  1.f);

        return mat4(m1, m2, m3, m4);
    }

    #ifdef VERTEX
    vec4 position(mat4 transform_projection, vec4 vertex_position)
    {   
        mat4 proj_matrix = orthoProj(0.f, love_ScreenSize.x, love_ScreenSize.y, 0.f, -50.f, 50.f);

        vec4 trans_vert_pos = proj_matrix * TransformMatrix * vertex_position;
        depth = trans_vert_pos.z;

        return trans_vert_pos;
    }
    #endif

    #ifdef PIXEL
    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
        return vec4(1.f, 1.f, 1.f, 1.f) * (1 - (1 + (depth)) / 2);
    }
    #endif
    ]]

    local noError, msg = love.graphics.validateShader(false, shaderCode)

    assert(noError, msg)

    obj.shader = love.graphics.newShader(shaderCode)

    return setmetatable(obj, Model)
end

function Model:setTransform(t, pos)
    self.transform:setMatrix(t.matrix[1][1], t.matrix[1][2], t.matrix[1][3], pos[1], t.matrix[2][1], t.matrix[2][2], t.matrix[2][3], pos[2], t.matrix[3][1], t.matrix[3][2], t.matrix[3][3], 0, 0, 0, 0, 1)
end

function Model:draw()
    love.graphics.push("all")

    love.graphics.setShader(self.shader)
    love.graphics.draw(self.mesh, self.transform)

    love.graphics.pop()

end

return Model