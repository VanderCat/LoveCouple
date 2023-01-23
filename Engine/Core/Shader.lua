local Shader = require "Engine.Core.Object" : subclass "Shader"

local _shadercache = {}
local function shaderExists(minpath)
    return love.filesystem.getInfo("Shaders/"..minpath..".glsl") and true or false
end

-- pls use find it will create automaticly the shader
-- if u want2change the name just do shader.name = "new name"
function Shader:initialize(path, name)
    Shader.super.initialize(self)
    if shaderExists(path) then
        self._shader = love.graphics.newShader("Shaders/"..path..".glsl")
        self.name = name or path
    else
        error "Used wrong path!!"
    end
    _shadercache[self.id] = _shadercache[self.id] or self
end

function Shader.static:find(name)
    local found = _shadercache[name]
    if not found then
        for _, shader in pairs(_shadercache) do
            if shader.name == name then
                return shader
            end
        end
        if shaderExists(name) then
            return self:new(name)
        end
    end
    return found
end

function Shader:send(...)
    self._shader:send(...)
end
function Shader:sendColor(...)
    self._shader:sendColor(...)
end

return Shader