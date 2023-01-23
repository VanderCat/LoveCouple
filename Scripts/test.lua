local Vector = require "hdictus.hump.vector"

local Test = require "Engine.Core.Behaviour" : subclass "Test"

function Test:awake()
    --Variables goes here...
    self.fromPoint = self.transform:getPosition()
    self.amplitude = 32
    self.speed = 0.25
    self._window = true
    self._text = ""
    --self.render = self.gameObject:getComponent("Renderer")
end

function Test:start()
end

function Test:update(dt)
    --self.transform:rotate(dt)
    --self.transform:setLocalPosition(Vector(self.fromPoint.x, self.fromPoint.y+math.sin(love.timer.getTime()*self.speed)*self.amplitude))
    
    local a = (1+math.sin(love.timer.getTime()*self.speed))/2
    self.transform:setScale(Vector(a,a))
    --print(self.transform:getRotation())
end
local lg = love.graphics
function Test:postObjectDraw()
    lg.points(0,0)
    self._text = ("%s\nPos:%s\nScale:%s\nRotation:%i"):format(self.name, self.transform.localPosition, self.transform.localScale, self.transform.localRotation)
    lg.print(self._text, 16, 16)
end

function Test:onDrawGui()
    if self._window then
        --love.graphics.print(self._text)
        --imgui.SetNextWindowPos(50, 50, "ImGuiCond_FirstUseEver")
        --self._window = imgui.Begin(self.gameObject.name.." debug!", true, { "ImGuiWindowFlags_AlwaysAutoResize"});
        --imgui.Text("Hello");
        --imgui.End()
    end
end

return Test