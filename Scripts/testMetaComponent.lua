local Test = require "Engine.Core.Behaviour" : subclass "MetaComponent"

function Test:awake()
    self.text = "harou everynyan! this is a test of a global gameobject! Current Scene this gameobject in is "
    Log:info("You should see this regardless of function are enabled or not")
    self.enabled = true
    self.renderCount = 0
end

function Test:start()
    Log:info("You should see this once function is enabled")
end

function Test:getAllObjectsInSceneAsString()
    local text = ""
    for index, go in ipairs(self.gameObject.scene.gameObjects) do
        local componentList = ""
        for indexComp, comp in ipairs(go._componentList) do
            componentList =  componentList .. "\t" .. index .. "." ..indexComp .. ". " .. comp.class.name .. "\n"
        end
        text = text .. index .. ". " .. go.name .. "\n" .. componentList
    end
    return text
end

function Test:update(dt)
end

function Test:postObjectDraw()

end

function Test:onDrawGui()
    self.renderCount = self.renderCount + 1
    love.graphics.print(self.text..self.gameObject.scene.name, 50, 50)
    love.graphics.print("i've rendered "..self.renderCount.." times", 50, 100)
    love.graphics.print(self:getAllObjectsInSceneAsString(), 50, 150)
end

return Test
