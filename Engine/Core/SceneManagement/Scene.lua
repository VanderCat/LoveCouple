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

    local moreSteps = true
    while moreSteps do
        moreSteps = false
        local nextStep = self:_loadGameObjectStage(gameObject)
        if nextStep then
            moreSteps = true
        end
    end
end

function Scene:moveGameObject(gameObject)
    --FIXME: Type Safety
    gameObject.scene:removeGameObject(gameObject)
    self:addGameObject(gameObject)
end

function Scene:removeGameObject(gameObject)
    --FIXME: Type Safety
    self.gameObjects[gameObject._sceneId] = nil
    gameObject._sceneId = -1
    gameObject.scene = nil
end

function Scene:isValid()
    --TODO: Stub
    return self._isValid
end

function Scene:load()
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

function Scene:finishLoading()
    Log:debug("Initializing GameObject in scene \"{1}\"", self.name)
    if self.isLoaded then
        Log:warn("Attempt to load already loaded scene")
    end
    self.isLoaded = true
    local moreSteps = true
    local iteration = 1
    while moreSteps do
        moreSteps = false
        Log:trace("--------- Iteration {1} ---------", iteration)
        for _, gameObject in ipairs(self.gameObjects) do
            local nextStep = self:_loadGameObjectStage(gameObject)
            if nextStep then
                moreSteps = true
            end
        end
        iteration=iteration+1
    end
end

function Scene:_loadGameObjectStage(gameObject)
    local shouldContinue = false
    for _, component in ipairs(gameObject:getComponents()) do
        local nextStep = component:_nextInitializationStep()
        if nextStep then
            shouldContinue = true
            Log:trace("{2}<{1}>\t{3}", component.class.name, gameObject.name, tostring(nextStep))
        end
    end
    return shouldContinue
end

return Scene