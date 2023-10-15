local Scene = Class "Scene"

function Scene:initialize(name)
    self.name = name
    self.isLoaded = false
    self._isValid = true
    self.gameObjects = {}
end

function Scene:getRootGameObjects()
    local rootGameObjects = {}
    for _, gameObject in ipairs(self.gameObjects) do
        if not gameObject.transform.parent then
            rootGameObjects[#rootGameObjects+1] = gameObject
        end
    end
    return rootGameObjects
end

function Scene:addGameObject(gameObject)
    --FIXME: Type Safety
    gameObject._sceneId = #self.gameObjects+1
    self.gameObjects[#self.gameObjects+1] = gameObject
    gameObject.scene = self
end

function Scene:removeGameObject(gameObject)
    --FIXME: Type Safety
    self.gameObjects[gameObject._sceneId] = gameObject
    gameObject._sceneId = -1
    gameObject.scene = nil
end

function Scene:isValid()
    --TODO: Stub
    return self._isValid
end

function Scene:_update(dt)
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:sendMessage("update", {dt})
    end
end

function Scene:_draw()
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:sendMessage("draw")
        gameObject:sendMessage("onDrawGui")
    end
end

function Scene:emit(name, ...)
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:sendMessage(name, {...})
    end
end

return Scene