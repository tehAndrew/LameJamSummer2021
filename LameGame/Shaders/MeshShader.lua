return [[
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