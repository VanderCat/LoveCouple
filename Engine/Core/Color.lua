local Color = Class "Color"

function Color:initialize(r,g,b,a)
    self:setColor(r,g,b,a)
end

function Color:setColor(r,g,b,a)
    self.r = r or 1
    self.g = g or 1
    self.b = b or 1
    self.a = a or 1
    self[1] = self.r
    self[2] = self.g
    self[3] = self.b
    self[4] = self.a
    local cr, cg, cb = love.math.linearToGamma(self.r, self.g, self.b)
    self.gamma = self.gamma or {}
    self.gamma.r = cr
    self.gamma.g = cg
    self.gamma.b = cb
    self.grayscale = (self.r + self.g +self.b)/3
    self.maxColorComponent = math.max(self.r, self.g, self.b)
end

function Color:__unm()
    return Color:new(1-self.r, 1-self.g, 1-self.b)
end
function Color:__add(other)
    local type = type(other)
    if type == "number" then
        return Color:new(self.r+other, self.g+other, self.b+other)
    elseif type == "table" then
        return Color:new(self.r+other.r, self.g+other.g, self.b+other.b)
    end
end
function Color:__sub(other)
    local type = type(other)
    if type == "number" then
        return Color:new(self.r-other, self.g-other, self.b-other)
    elseif type == "table" then
        return Color:new(self.r-other.r, self.g-other.g, self.b-other.b)
    end
end
function Color:__mul(other)
    local type = type(other)
    if type == "number" then
        return Color:new(self.r*other, self.g*other, self.b*other)
    elseif type == "table" then
        return Color:new(self.r*other.r, self.g-other.g, self.b*other.b)
    end
end
function Color:__div(other)
    local type = type(other)
    if type == "number" then
        return Color:new(self.r/other, self.g/other, self.b/other)
    elseif type == "table" then
        return Color:new(self.r/other.r, self.g/other.g, self.b/other.b)
    end
end

function Color:__tostring()
    return ("Color (%i,%i,%i,%i)"):format(self.r, self.g, self.b, self.a)
end

function Color.static.black()
    return Color:new(0,0,0,1)
end

function Color.static.white()
    return Color:new(1,1,1,1)
end

function Color.static.clear()
    return Color:new(1,1,1,1)
end

function Color.static.lerp(a, b, t)
    return Color:new(
        math.lerp(a.r, b.r, t),
        math.lerp(a.g, b.g, t),
        math.lerp(a.b, b.b, t)
    )
end

return Color