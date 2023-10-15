local Scene = require "Engine.Core.SceneManagement.Scene"
local Enum = require "Engine.Enum"

local SceneManager = Class "SceneManager"

SceneManager.static._invalidScene = Scene:new("INVALID_SCENE")
SceneManager.static._invalidScene._isValid = false

function SceneManager:initialize()
    self._loadedScenes = {}
    self._activeScene = SceneManager._invalidScene
    self:createScene("DontDestroyOnLoad")
end

function SceneManager:count()
    return #self._loadedScenes
end

function SceneManager:createScene(name, loadSceneMode)
    local scene = Scene:new(name)
    self._loadedScenes[#self._loadedScenes+1] = scene
    return scene
end

function SceneManager:getSceneByName(name)
    for k, scene in ipairs(self._loadedScenes) do
        if scene.name == name then
            return scene, k
        end
    end
    return SceneManager._invalidScene, -1
end

function SceneManager:loadScene(name, loadSceneMode)
    --TODO: Stub
    if loadSceneMode == Enum.loadSceneMode.single then
        self:unloadEverythin()
    end
    
end

function SceneManager:mergeScenes(source, destination)
    for k, gameObject in ipairs(source.gameObjects) do
        source.gameObjects[k]=nil
        destination:addGameObject(gameObject)
    end
end

function SceneManager:getActiveScene()
    return self._activeScene
end

function SceneManager:getLoadedScenes()
    return table.shallow_copy(self._loadedScenes)
end

function SceneManager:setActiveScene(scene)
    --FIXME: Type safety
    self._activeScene = scene
end

function SceneManager:unloadScene(name)
    local scene, index = self:getSceneByName(name)
    if not scene:isValid() then
        return
    end
    for _, gameObject in ipairs(scene.gameObjects) do
        gameObject:_destroy()
    end
    table.remove(self._loadedScenes, index)
end

function SceneManager:update(dt)
    for _, scene in ipairs(self._loadedScenes) do
        scene:_update(dt)
    end
end

function SceneManager:draw()
    for _, scene in ipairs(self._loadedScenes) do
        scene:_draw()
    end
end

return SceneManager()