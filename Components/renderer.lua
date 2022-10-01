local Vector = require "hdictus.hump.vector"
local renderer = require "Abstract.component" : subClass "Renderer"

function renderer:initialize(gameObject)
    renderer.super.initialize(self, gameObject)

    self.bounds = {}
    self.localBounds = {}

    self.forceRenderingOff = false
    self.isVisible = true

end

return renderer