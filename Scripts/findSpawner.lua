local GameObject = require "Engine.Core.GameObject"
local SceneManager = require "Engine.Core.SceneManagement.SceneManager"
local timer = require "hdictus.hump.timer"

local Find = require "Engine.Core.Behaviour" : subclass "FindTheThingSpawner"

function Find:start()
    self:invoke("spawnAll", 5)
end

function Find:spawn(name)
    local go = GameObject:new(name)
    self.gameObject.scene:moveGameObject(go)
    return go
end

function Find:spawnAll()
    local im = self:spawn("im")
    local here = self:spawn("here")
    local uwu = self:spawn("uwu")

    local randomGuy = self:spawn("im just a silly random guy :)")

    im.transform:setParent(self.transform)
    here.transform:setParent(im.transform)
    uwu.transform:setParent(here.transform)

    --notice how we spawn him second, so his sibling index should be 2
    randomGuy.transform:setParent(im.transform)
    --let's move him instead
    randomGuy.transform:setSiblingIndex(1)
end

return Find
