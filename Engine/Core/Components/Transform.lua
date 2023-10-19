local Vector = require "hdictus.hump.vector"
local Transform = require "Engine.Core.Component" : subclass "Transform"

function Transform:initialize(gameObject)
    Transform.super.initialize(self, gameObject)

    self.localPosition = Vector(0,0)
    self.localRotation = 0
    self.localScale = Vector(1,1)
    self._children = {}
    
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
    self:rotate(rot-self.localRotation)
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

function Transform:setParent(transform)
    self:removeParent()
    self.parent = transform
    self.parent._children[#self.parent._children+1] = self
end

function Transform:removeParent()
    if not self.parent then return end

    local siblingIndex = self:getSiblingIndex()

    table.remove(self.parent._children, siblingIndex)

    self.parent = nil
end

function Transform:getSiblingIndex()
    if not self.parent then return -1 end

    --NOTE: not sure if it is a correct way to do it
    for index, child in ipairs(self.parent._children) do
        if child == self then return index end
    end
    return -1
end

function Transform:setSiblingIndex(index)
    if not self.parent then return end -- TODO: Maybe throw up an error?

    local siblingIndex = self:getSiblingIndex()
    table.remove(self.parent._children, siblingIndex)
    table.insert(self.parent._children, index, self)
end

function Transform:getChildren()
    return Lume.clone(self._children)
end

function Transform:getChild(index)
    return self._children[index]
end

function Transform:find(name)
    if #self._children == 0 then return end

    local path = Lume.split(name, "/")
    if #path == 1 then
        for _, child in ipairs(self._children) do
            if child.gameObject.name == name then return child.gameObject end
        end
    end

    local foundGameObject = self.gameObject
    for _, pathElement in ipairs(path) do
        foundGameObject = foundGameObject.transform:find(pathElement) or -1
        if foundGameObject == -1 then return end
    end
    return foundGameObject
end

function Transform:setFromSerialized(transformTable)
    if transformTable.position then
        self:setLocalPosition(Vector(transformTable.position.x, transformTable.position.y))
    end
    if transformTable.rotation then
        self:setRotation(transformTable.rotation)
    end
    if transformTable.scale then
        self:setScale(transformTable.scale)
    end
end

return Transform