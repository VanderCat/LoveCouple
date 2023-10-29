local Scene = require "Engine.Core.SceneManagement.Scene"
local Enum = require "Engine.Enum"
local Serpent = require "pkulchenko.serpent"

local SceneManager = Class "SceneManager"

SceneManager.static._invalidScene = Scene:new("INVALID_SCENE")
SceneManager.static._invalidScene._isValid = false

function SceneManager:initialize()
    self._loadedScenes = {}
    self._activeScene = SceneManager._invalidScene

    local dontDestroy = self:createScene("DontDestroyOnLoad")
    dontDestroy:finishLoading()
    self:loadScene(dontDestroy)
end

function SceneManager:count()
    return #self._loadedScenes
end

function SceneManager:createScene(name)
    local scene = Scene:new(name)
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

function SceneManager:loadScene(scene, isExclusive)
    if isExclusive then
        self:unloadAllScenes()
    end
    
    self._loadedScenes[#self._loadedScenes+1] = scene
    self:setActiveScene(scene)
end

function SceneManager:loadSceneFromDisk(path, isExclusive)
    local fullPath = "Data/Scenes/"..path..".scene.lua" 
    local string = love.filesystem.read("string", fullPath)
    local res, load = Serpent.load(string)
    if not res then
        Log:error("Can't load scene {1} due to error {2}!", path, load)
        return
    end

    self:loadSceneSerialized(load, isExclusive)
end

function SceneManager:loadSceneSerialized(sceneTable, isExclusive)
    local scene = self:createScene(sceneTable.name)
    local GameObject = require "Engine.Core.GameObject"
    self:loadScene(scene, isExclusive)
    for _, gameObjectTable in pairs(sceneTable.gameObjects) do
        GameObject.createSerialized(gameObjectTable)
    end
end

function SceneManager:mergeScenes(source, destination)
    for k, gameObject in ipairs(source.gameObjects) do
        destination:moveGameObject(gameObject)
    end
end

function SceneManager:getActiveScene()
    return self._activeScene
end

function SceneManager:getLoadedScenes()
    return Lume.clone(self._loadedScenes)
end

function SceneManager:setActiveScene(scene)
    --FIXME: Type safety
    self._activeScene = scene
end

function SceneManager:unloadAllScenes()
    for k, scene in ipairs(self._loadedScenes) do
        if scene.name == "DontDestroyOnLoad" then goto continue end
        self:unloadScene(scene, k)
        ::continue::
    end
end

function SceneManager:unloadSceneByName(name)
    local scene, index = self:getSceneByName(name)
    self:unloadScene(scene, index)
end

function SceneManager:unloadScene(scene, index)
    if not scene:isValid() then
        return
    end
    for _, gameObject in ipairs(scene.gameObjects) do
        gameObject:_destroy()
    end

    if not index or self._loadedScenes[index] ~= scene then
        for k, scene2Find in ipairs(self._loadedScenes) do
            if scene2Find ~= scene then goto continue end
            index = k
            ::continue::
        end
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

return SceneManager:new()