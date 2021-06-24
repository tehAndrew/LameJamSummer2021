local Test = require("Test")

local debug, precondition, assertExpr = Test.debug, Test.precondition, Test.assertExpr

-- Private
local function loadAndExecuteLuaChunk(filepath)
    local chunk, errorMsg = love.filesystem.load(filepath)
    debug(assertExpr, errorMsg == nil, errorMsg)

    local ok, sourceCode = pcall(chunk)
    debug(assertExpr, ok, "Chunk could not be executed.")

    return sourceCode
end

local function loadShader(shaderName)
    debug(precondition, type(shaderName) == "string", "Argument 1 must be of type 'string'.")

    -- Load .lua file
    local sourceCode = loadAndExecuteLuaChunk("Shaders/" .. shaderName .. ".lua")

    -- Validate shader code
    local ok, errorMsg = love.graphics.validateShader(false, sourceCode)
    debug(assertExpr, ok, errorMsg)

    -- Compile shader and return shader object
    return love.graphics.newShader(sourceCode)
end

-- Todo verify input
local function loadMesh(meshName)
    debug(precondition, type(meshName) == "string", "Argument 1 must be of type 'string'.")

    local meshData = loadAndExecuteLuaChunk("Meshes/" .. meshName .. ".lua")
    

    local attrLayout = {{"VertexPosition", "float", 3}} -- VertexPosition will be interpreted as vertex position automatically by glsl
    local vertices = meshData.vertices
    local indices = meshData.indices

    local mesh = love.graphics.newMesh(attrLayout, vertices, "triangles", "dynamic") -- TODO Try change to static later
    mesh:setVertexMap(indices)

    return mesh
end

-- Public
G_ResourceLoader = {}
G_ResourceLoader.shaders = {}
G_ResourceLoader.meshes = {}

function G_ResourceLoader.loadShaderResource(shaderName)
    debug(precondition, type(shaderName) == "string", "Argument 1 must be of type 'string'.")

    if G_ResourceLoader.shaders[shaderName] == nil then
        G_ResourceLoader.shaders[shaderName] = loadShader(shaderName)
    end

    return G_ResourceLoader.shaders[shaderName]
end

function G_ResourceLoader.loadMeshResource(meshName)
    debug(precondition, type(meshName) == "string", "Argument 1 must be of type 'string'.")

    if G_ResourceLoader.meshes[meshName] == nil then
        G_ResourceLoader.meshes[meshName] = loadMesh(meshName)
    end

    return G_ResourceLoader.meshes[meshName]
end

