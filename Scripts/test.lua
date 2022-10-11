local Vector = require "hdictus.hump.vector"

local Test = require "Engine.Core.Behaviour" : subclass "Test"

function Test:awake()
    --Variables goes here...
    self.fromPoint = self.transform:getPosition()
    self.amplitude = 32
    self.speed = 0.25
    --self.render = self.gameObject:getComponent("Renderer")
end

function Test:start()
end

function Test:update(dt)
    self.transform:rotate(dt)
    --self.transform:setPosition(Vector(self.fromPoint.x, self.fromPoint.y+math.sin(love.timer.getTime()*self.speed)*self.amplitude))
    
    --local a = (1+math.sin(love.timer.getTime()*self.speed))/2
    --self.transform:setScale(Vector(a,a))
    --print(self.transform:getRotation())
end
local lg = love.graphics
function Test:postObjectDraw()
    lg.points(0,0)
    local text = ("%s\nPos:%s\nScale:%s\nRotation:%i"):format(self.name, self.transform:getPosition(), self.transform.localScale, self.transform.localRotation)
    lg.print(text, 16, 16)
end

return Test