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
G_ResourceLoader.shader = {}
G_ResourceLoader.mesh = {}

-- Load shader resource from the shader folder.
function G_ResourceLoader.loadShaderResource(shaderName)
    debug(precondition, type(shaderName) == "string", "Argument 1 must be of type 'string'.")

    debug(assertExpr, G_ResourceLoader.shader[shaderName] == nil, shaderName .. " shader resource has already been loaded.")

    G_ResourceLoader.shader[shaderName] = loadShader(shaderName)
end

-- Load mesh resource from the mesh folder.
function G_ResourceLoader.loadMeshResource(meshName)
    debug(precondition, type(meshName) == "string", "Argument 1 must be of type 'string'.")

    debug(assertExpr, G_ResourceLoader.shader[meshName] == nil, meshName .. " mesh resource has already been loaded.")

    G_ResourceLoader.mesh[meshName] = loadMesh(meshName)
end

-- Retrieve loaded resource.
function G_ResourceLoader.getResource(resType, resName)
    debug(precondition, type(resType) == "string", "Argument 1 must be of type 'string'.")
    debug(precondition, type(resName) == "string", "Argument 2 must be of type 'string'.")

    debug(assertExpr, G_ResourceLoader[resType] ~= nil, "'" .. resType .. "'" .. " is not a valid type of resource.")
    debug(assertExpr, G_ResourceLoader[resType][resName] ~= nil, resName .. " " .. resType .. " resource has not been loaded.")

    return G_ResourceLoader[resType][resName]
end