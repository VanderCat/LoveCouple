local SceneManager = require "Engine.Core.SceneManagement.SceneManager"
local GameObject = require "Engine.Core.Object" : subclass "GameObject"

function GameObject:initialize(name, components)
    GameObject.super.initialize(self)
    self.name = name or self.name
    self.active = true
    self.transform = require "Engine.Core.Components.Transform":new(self)
    self._componentList = {self.transform}
    self._sceneId = -1
    if components then
        for _, component in pairs(components) do
            self:addComponent(component)
        end
    end

    SceneManager:getActiveScene():addGameObject(self)
end

function GameObject:_destroy()
    GameObject:sendMessage("OnDestroy")
    for _, component in ipairs(self._componentList) do
        component:_destroy()
    end
    self.super:_destroy()
    self.scene:removeGameObject(self)
    self.scene = nil
end

function GameObject:activeOverall()
    local parent = self.transform.parent
    if (parent) then
        return parent.gameObject:activeOverall()
    end
    return self.active
end

function GameObject:addComponent(Component)
    local component = Component:new(self, self.transform)
    self._componentList[#self._componentList+1] = component
    return component
end

function GameObject:sendMessage(methodName, parameters, requireReciever)
    local noOneAnswered = true
    for k, component in ipairs(self._componentList) do
        if not component.enabled then goto continue end
        local method = component[methodName]
        if method then
            component[methodName](component, unpack(parameters or {}))
            noOneAnswered = false
        end
        ::continue::
    end
    if noOneAnswered and requireReciever then
        error("No one answered to "..methodName.."!")
    end
end

function GameObject:getComponents(type)
    local components = {}
    for _, component in ipairs(self._componentList) do
        if component.class == type then
            components[#components+1] = component
        end
    end
    return components
end

function GameObject:getComponent(type)
    for _, component in ipairs(self._componentList) do
        if component.class == type then
            return component
        end
    end
end

return GameObject