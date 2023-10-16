local SceneManager = require "Engine.Core.SceneManagement.SceneManager"

local debugInfo = require "Engine.Core.Behaviour" : subclass "MetaComponent"

function debugInfo:awake()
    self.debugText = 
[[fps:%i
current_scene: %s
]]
end

function debugInfo:start()
end


function debugInfo:update(dt)
end

function debugInfo:postObjectDraw()
end

function debugInfo:onDrawGui()
    love.graphics.print(self.debugText:format(
        love.timer.getFPS(), 
        SceneManager:getActiveScene().name
    ))
end

return debugInfo
