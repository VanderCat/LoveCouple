local GameObject = require "Engine.Core.GameObject"
local Component = require "Engine.Core.Object" : subclass "Component"

function Component:initialize(gameObject, transform)
    Component.super.initialize(self)
    if not gameObject:isInstanceOf(GameObject) then 
        error(GameObject.name.." ("..GameObject.id..") ".."is not a valid GameObject!") 
    end
    self.enabled = true
    self.gameObject = gameObject
    self.transform = transform
end

function Component:toggle(state)
    if self.enabled == state then
        return
    end
    if state == nil then
        self.enabled = not self.enabled
    end
    if self.enabled then
        self:sendMessage("OnEnable")
    else
        self:sendMessage("OnDisable")
    end
end

function Component:isActiveAndEnabled()
    return self.enabled and self.gameObject.enabled
end

function Component:sendMessage(methodName, parameters, requireReciever)
    return self.gameObject:sendMessage(methodName, parameters, requireReciever)
end

function Component:_destroy()
    self:sendMessage("OnDestroy")
end

function Component:getComponents(type)
    return self.gameObject:getComponents(type)
end

function Component:getComponent(type)
    return self.gameObject:getComponent(type)
end

return Component