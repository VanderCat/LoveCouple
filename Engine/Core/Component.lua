local GameObject = require "Engine.Core.GameObject"
local Component = require "Engine.Core.Object" : subclass "Component"

function Component:initialize(gameObject, transform, isEnabled)
    Component.super.initialize(self)
    if not gameObject:isInstanceOf(GameObject) then 
        error(GameObject.name.." ("..GameObject.id..") ".."is not a valid GameObject!") 
    end
    self._initialized = flase
    self.enabled = true
    if type(isEnabled) == "boolean" then
        self.enabled = isEnabled
    end
    self.gameObject = gameObject
    self.transform = transform
end


function Component:_onInitialize()
    self.initialized = true
    coroutine.yield("initializationBegan")
end

function Component:_createInitialzationCoroutune()
    self._intializationCoroutine = coroutine.create(function ()
        self:_onInitialize()
    end)
end

function Component:_nextInitializationStep()
    if not self._intializationCoroutine then
        return
    end
    if coroutine.status(self._intializationCoroutine) == "dead" then
        self._intializationCoroutine = nil
        return
    end
    local _, stage = coroutine.resume(self._intializationCoroutine)
    return stage
end

function Component:toggle(state)
    if self.enabled == state then
        return
    end
    if state == nil then
        self.enabled = not self.enabled
    end
    if self.enabled then
        self:onEnable()
    else
        self:onDisable()
    end
end

function Component:isActiveAndEnabled()
    return self.enabled and self.gameObject.enabled
end

function Component:sendMessage(methodName, parameters, requireReciever)
    return self.gameObject:sendMessage(methodName, parameters, requireReciever)
end

function Component:_destroy()
    self:onComponentDestroy()
end

function Component:getComponents(type)
    return self.gameObject:getComponents(type)
end

function Component:getComponent(type)
    return self.gameObject:getComponent(type)
end

--stubs
function Component:onEnable()
end
function Component:onDisable()
end
function Component:onComponentDestroy()
end
function Component:onDestroy()
end

return Component