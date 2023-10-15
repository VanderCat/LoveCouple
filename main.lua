local timer = require "hdictus.hump.timer"

local gameObjects = {}
local SceneManager = require "Engine.Core.SceneManagement.SceneManager"
function love.load()
    local scene = SceneManager:createScene("test")
    SceneManager:loadScene(scene)

    local GameObject = require "Engine.Core.GameObject"
    local Texture = require "Engine.Core.Texture"
    local vec = require "hdictus.hump.vector"
    
    local camera = GameObject:new("Camera")
    camera:addComponent(require "Engine.Core.Components.Camera").zoom = 2

    local player = GameObject:new("player")
    player.transform:setPosition(vec(0,0))
    player:addComponent(require "Scripts.test").speed = -0.5
    local r = player:addComponent(require "Engine.Core.Components.Renderer")
    local t = Texture:new(love.graphics.newImage("Assets/Images/spaceship.png"))
    t:setFilter("nearest")
    r.material.mainTexture = t

    local some = GameObject:new("some")
    local other = GameObject:new("other")
    local go = GameObject:new("gameobjects")
    local r1 = some:addComponent(require "Engine.Core.Components.Renderer")
    local r2 = other:addComponent(require "Engine.Core.Components.Renderer")
    --local r3 = go:addComponent(require "Engine.Core.Components.Renderer")
    --r1.material.mainTexture = t
    r2.material.mainTexture = t
    --r3.material.mainTexture = t

    some.transform:setParent(player.transform)
    some.transform:setPosition(vec(50,50))

    other.transform:setParent(player.transform)
    other.transform:setLocalPosition(vec(0,100))
    local a = other:addComponent(require "Scripts.test")
    a.speed = 0.5

    go.transform:setParent(other.transform)
    go.transform:setLocalPosition(vec(-50,0))

    local meta = GameObject:new("meta")
    meta:addComponent(require "Scripts.testMetaComponent")
    SceneManager:getSceneByName("DontDestroyOnLoad"):moveGameObject(meta)

    GameObject:new("drawfunnyscene"):addComponent(require "Scripts.drawSceneHierarchy")

    local searcher = GameObject:new("Searcher")
    searcher:addComponent(require "Scripts.findTheThing")
    searcher:addComponent(require "Scripts.findSpawner")

    timer.after(1, function ()
        SceneManager:unloadScene(scene)
        local scene = SceneManager:createScene("new scene")
        SceneManager:loadScene(scene)
        GameObject:new("drawfunnyscene"):addComponent(require "Scripts.drawSceneHierarchy")
    end)

    timer.after(4, function ()
        local scene = SceneManager:createScene("jokes on you im now a new scene")
        SceneManager:loadScene(scene, true)
        GameObject:new("drawfunnyscene"):addComponent(require "Scripts.drawSceneHierarchy")
    end)
end

function love.update(dt)
    SceneManager:update(dt)
    timer.update(dt)
end

function love.draw()
    SceneManager:draw()
    --imgui.Render()
    love.graphics.print(("fps:%i\ncurrent_scene: %s"):format(love.timer.getFPS(), SceneManager:getActiveScene().name))
end

function love.quit()
    --imgui.ShutDown()
end