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
    self:sendMessage("OnDestroy")
    for _, component in ipairs(self._componentList) do
        component:_destroy()
    end
    GameObject.super._destroy(self)
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

function GameObject.static.createSerialized(gameObjectTable, parent)
    local gameObject = GameObject:new(gameObjectTable.name)
    gameObject.name = gameObject.name or gameObject.id
    if parent then
        gameObject.transform:setParent(parent.transform)
    end
    if (gameObjectTable.transform) then
        gameObject.transform:setFromSerialized(gameObjectTable.transform)
    end
    if gameObjectTable.components then 
        for _, componentTable in pairs(gameObjectTable.components) do
            local componentClass
            local result, err = pcall(function()
                componentClass = require(componentTable.classpath)
            end)
            if not result then
                Log:error("Failed loading component {1} in gameObject {2}:\n{3}", componentTable.classpath, gameObjectTable.name, err)
                goto anothercontinue
            end
            local component = gameObject:addComponent(componentClass)
            for key, value in pairs(componentTable) do
                if key == "classpath" then goto continue end
                -- TODO: add support for custom classes
                --       i think this should be in own function but simple one should work for now
                component[key] = value
                ::continue::
            end
            ::anothercontinue::
        end
    end
    if gameObjectTable.children then
        for _, childGameObjectTable in pairs(gameObjectTable.children) do
            GameObject.createSerialized(childGameObjectTable, gameObject)
        end
    end
    return gameObject
end

return GameObject