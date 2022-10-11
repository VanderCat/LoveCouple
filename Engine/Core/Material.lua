local Vector = require "hdictus.hump.vector"
local Color = require "Engine.Core.Color"
local Shader = require "Engine.Core.Shader"
local Texture = require "Engine.Core.Texture"
local Material = require "Engine.Core.Object" : subclass "Material"

function Material:initialize()
    Material.super.initialize(self)
    self.color = Color:white()
    self.mainTexture = Texture:new(love.graphics.newCanvas(32,32))
    self.mainTextureScale = Vector(1,1)
    self.mainTextureOffset = Vector(0.5,0.5)
    self.shader = Shader:find("default")
end

return Material