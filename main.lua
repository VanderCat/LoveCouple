local timer = require "hdictus.hump.timer"

local gameObjects = {}
function love.load()
    local GameObject = require "Engine.Core.GameObject"
    local vec = require "hdictus.hump.vector"
    
    local player = GameObject:new("player")
    player.transform:setPosition(vec(100,100))
    player:addComponent(require "Scripts.test").speed = -0.5

    local some = GameObject:new("some")
    local other = GameObject:new("other")
    local go = GameObject:new("gameobjects")

    some.transform.parent = player.transform
    some.transform:setPosition(vec(200,100))

    other.transform.parent = player.transform
    other.transform:setLocalPosition(vec(0,100))
    local a = other:addComponent(require "Scripts.test")
    --a.speed = 0.5

    go.transform.parent = other.transform
    go.transform:setLocalPosition(vec(100,0))
    
    gameObjects[1] = player
    gameObjects[2] = some
    gameObjects[3] = other
    gameObjects[4] = go
end

function love.update(dt)
    timer.update(dt)
    for _, gameObject in ipairs(gameObjects) do
        gameObject:sendMessage("update", {dt})
    end
end

function love.draw()
    for _, gameObject in ipairs(gameObjects) do
        local pos = gameObject.transform:position()
        local dirdown = gameObject.transform:down(true)*16
        local dirright = gameObject.transform:right(true)*16
        love.graphics.points(pos.x, pos.y, pos.x+dirdown.x, pos.y+dirdown.y, pos.x+dirright.x, pos.y+dirright.y)
        love.graphics.print(("%s\n(%i,%i)\nLocal:(%i,%i)"):format(gameObject.name, pos.x, pos.y, gameObject.transform.localPosition.x,gameObject.transform.localPosition.y), pos.x, pos.y+16)
    end
    love.graphics.print(("fps:%i"):format(love.timer.getFPS()))
end