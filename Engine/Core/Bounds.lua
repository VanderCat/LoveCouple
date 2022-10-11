local Vector = require "hdictus.hump.vector"
local Bounds = Class "Bounds"

function Bounds:initialize(center, size)
    self.center = center
    self.size = size
end

function Bounds:getExtents()
    return self.size/2
end

function Bounds:getMin()
    return self.center-self:getExtents()
end

function Bounds:getMax()
    return self.center+self:getExtents()
end

function Bounds:setMin(min)
    local size = self:getMax()-min
    local center = self:getMax()-(min)/2
    self.size = size
    self.center = center
end

function Bounds:setMax(max)
    local size = max-self:getMin()
    local center = self:getMin()+(max)/2
    self.size = size
    self.center = center
end

function Bounds:closestPoint(point)
    local min = self:getMin()
    local max = self:getMax()
    return Vector(math.clamp(min.x, max.x, point.x),math.clamp(min.y, max.y, point.y))
end

function Bounds:contains(point)
    local min = self:getMin()
    local max = self:getMax()
    return (point < max) or (point > min)
end

function Bounds:isColliding(bounds)
    local aextents = self:getExtents()
    local bextents = bounds:getExtents()
    local x = math.abs(self.center.x-bounds.center.x) <= (aextents.x+bextents.x)
    local y = math.abs(self.center.y-bounds.center.y) <= (aextents.y+bextents.y)
    return x and y
end

function Bounds:__tostring()
    return ("Bounds %s+%s"):format(self.center, self.size)
end

return Bounds