local Color = require "Abstract.color"
local Vector = require "hdictus.hump.vector"
local Material = require "Abstract.object" : subclass "Material"

function Material:initialize()
    Material.super.initialize(self)
    self.color = Color:white()
    self.mainTexture = love.graphics.newCanvas()
    self.mainTextureScale = Vector(1,1)
    self.shader = love.graphics.newShader("Shaders/default.glsl")
end

return Material