local Vector = require "hdictus.hump.vector"
local Bounds = require "Engine.Core.Bounds"
local Material = require "Engine.Core.Material"
local Renderer = require "Engine.Core.Component" : subclass "Renderer"

function Renderer:initialize(gameObject, transform)
    Renderer.super.initialize(self, gameObject, transform)

    self.bounds = {}
    self.localBounds = {}

    self.forceRenderingOff = false
    self.isVisible = true
    self.enableCull = true

    self.material = Material:new()
    self:resetBounds()
end

function Renderer:resetBounds()
    local size = Vector(self.material.mainTexture:getPixelDimensions())
    local offset = self.material.mainTextureOffset
    local scale = self.material.mainTextureOffset
    local pos = self.gameObject.transform:getPosition()
    local correctedSize = Vector(size.x*scale.x,size.y*scale.y)
    local offsetpos = pos+Vector(offset.x*correctedSize.x,offset.y*correctedSize.y)
    self.bounds = Bounds:new(offsetpos,correctedSize)
end

local lg = love.graphics
function Renderer:onCameraDraw(bounds)
    if not self.material then
        return
    end
    if not self.bounds:isColliding(bounds) then
        return
    end

    lg.push("all")

    self.gameObject:sendMessage("preObjectDraw")

    local parent = self.transform.parent
    while parent do
        lg.applyTransform(parent._transform)
        parent=parent.parent
    end
    lg.applyTransform(self.transform._transform)
    lg.scale(self.material.mainTextureScale.x, self.material.mainTextureScale.y)
    lg.setColor(self.material.color)
    
    local w, h = self.material.mainTexture:getPixelDimensions()
    local offset = self.material.mainTextureOffset
    local size = Vector(w*offset.x, h*offset.y)
    lg.draw(self.material.mainTexture:getDrawable(), 0, 0, 0, 1, 1, size.x, size.y)

    self.gameObject:sendMessage("postObjectDraw")

    lg.pop()
end

return Renderer