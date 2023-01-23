local Cam11 = require "pgimeno.cam11"
local Bounds = require "Engine.Core.Bounds"
local Vector = require "hdictus.hump.vector"

local Camera = require "Engine.Core.Behaviour" : subclass "Camera"

function Camera:initialize(gameObject, transform)
    Camera.super.initialize(self, gameObject, transform)
    self._cam = Cam11()
    self.zoom = 1
    self.bounds = Bounds:new()
    self.fracture = Vector(0.5, 0.5)
    self:OnScreenChange()
end

function Camera:update(...)
    local pos = self.transform:getPosition()
    self._cam:setPos(pos.x, pos.y)
    self._cam:setZoom(self.zoom)
    self._cam:setAngle(self.transform:getRotation())
    local x, y, w, h, fy, fx = self._cam:getViewport()
    self.bounds.center = Vector(x+w*fx, y+h*fy)
    self.bounds.size = Vector(w, h)
end

function Camera:OnScreenChange(w, h)
    w, h = w or love.graphics.getWidth(), h or love.graphics.getHeight()
    self._cam:setViewport(0, 0, w, h, self.fracture.x, self.fracture.x)
end

function Camera:draw(scene)
    self._cam:attach()
        for _, gameObject in pairs(scene.gameObjects) do
            gameObject:sendMessage("onCameraDraw", {self.bounds})
        end 
    self._cam:detach()
end

return Camera