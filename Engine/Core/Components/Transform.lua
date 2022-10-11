local Vector = require "hdictus.hump.vector"
local Transform = require "Engine.Core.Component" : subclass "Transform"

function Transform:initialize(gameObject)
    Transform.super.initialize(self, gameObject)

    self.localPosition = Vector(0,0)
    self.localRotation = 0
    self.localScale = Vector(1,1)
    
    self._transform = love.math.newTransform()

    self.hasChanged = false
end

function Transform:transformPoint(vec)
    return Vector(self._transform:transformPoint(vec.x, vec.y))
end

function Transform:inverseTransformPoint(vec)
    return Vector(self._transform:inverseTransformPoint(vec.x, vec.y))
end

function Transform:setLocalPosition(vec)
    local delta = vec-self.localPosition
    self._transform:translate(delta.x, delta.y)
    self.localPosition = vec
end

function Transform:setScale(vec)
    self._transform:setTransformation(self.localPosition.x, self.localPosition.y, self.localRotation, vec.x, vec.y)
    self.localScale = vec
end

function Transform:getScale(vec)
    return self.localScale*(self.parent and self.parent:getScale() or 1)
end

--global
function Transform:getPosition()
    local pos = self.localPosition:clone()
    local parent = self.parent
    while parent do
        pos = parent:transformPoint(pos)
        parent=parent.parent
    end
    return pos
end

function Transform:setPosition(vec)
    local delta
    local pos = self:getPosition()
    delta = vec-pos
    self._transform:translate(delta.x, delta.y)
    self.localPosition = self.localPosition+delta
end

function Transform:rotate(rot)
    self._transform:rotate(rot)
    self.localRotation = self.localRotation+rot
end

function Transform:setRotation(rot)
    self:rotate(rot-self.localPosition)
end

function Transform:getRotation()
    return self.localRotation+(self.parent and self.parent:getRotation() or 0)
end

function Transform:angle()
    return math.deg(self:getRotation())
end

function Transform:down(globalSpace)
    return Vector(0,1):rotateInplace(globalSpace and self:getRotation() or self.localRotation)
end

function Transform:right(globalSpace)
    return Vector(1,0):rotateInplace(globalSpace and self:getRotation() or self.localRotation)
end

return Transform