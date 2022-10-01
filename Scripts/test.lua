local Vector = require "hdictus.hump.vector"

local Test = require "Engine.Core.Behaviour" : subclass "Test"

function Test:awake()
    --Variables goes here...
    --self.fromPoint = self.transform:position()
    --self.amplitude = 32
    self.speed = 0.25
end

function Test:start()
    self.transform:rotate(math.pi/4)
end

function Test:update(dt)
    --self.transform:setPosition(Vector(self.fromPoint.x, self.fromPoint.y+math.sin(love.timer.getTime()*self.speed)*self.amplitude))
    
    local a = (1+math.sin(love.timer.getTime()*self.speed))/2
    self.transform:setScale(Vector(a,a))
    --print(self.transform:rotation())
end

return Test