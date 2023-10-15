local Hierarchy = require "Engine.Core.Behaviour" : subclass "HierarchyComponent"

function Hierarchy:awake()

end

function Hierarchy:start()

end

function Hierarchy:getObjectHierarchy(gameObject, level)
    local text = ""
    for index, transform in ipairs(gameObject.transform._children) do
        local componentList = ""
        for indexComp, comp in ipairs(transform.gameObject._componentList) do
            componentList =  componentList .. ("\t"):rep(level+1) .. index .. "." ..indexComp .. ". " .. comp.class.name .. "\n"
        end
        text = text .. ("\t"):rep(level).. index .. ". " .. transform.gameObject.name .. "\n" .. componentList .. Hierarchy:getObjectHierarchy(transform.gameObject, level+1)
    end
    return text
end

function Hierarchy:getSceneHierarchy()
    local text = ""
    for index, go in ipairs(self.gameObject.scene:getRootGameObjects()) do
        local componentList = ""
        for indexComp, comp in ipairs(go._componentList) do
            componentList =  componentList .. "\t" .. index .. "." ..indexComp .. ". " .. comp.class.name .. "\n"
        end
        text = text .. index .. ". " .. go.name .. "\n" .. componentList.. Hierarchy:getObjectHierarchy(go, 1)
    end
    return text
end


function Hierarchy:update(dt)
end

function Hierarchy:postObjectDraw()

end

function Hierarchy:onDrawGui()
    love.graphics.print(self:getSceneHierarchy(), 300, 100)
end

return Hierarchy
