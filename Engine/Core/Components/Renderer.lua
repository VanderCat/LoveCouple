local Vector = require "hdictus.hump.vector"
local Renderer = require "Engine.Core.Component" : subClass "Renderer"

function Renderer:initialize(gameObject)
    Renderer.super.initialize(self, gameObject)

    self.bounds = {}
    self.localBounds = {}

    self.forceRenderingOff = false
    self.isVisible = true

end

return Renderer