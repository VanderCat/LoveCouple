local uuid = require "tieske.uuid"
local timer = require "hdictus.hump.timer"
local vector = require "hdictus.hump.vector"

local Object = Class "Object"

function Object:initialize()
    self.id = uuid()
end

function Object:_destroy()
    
end

function Object:clone()
    local new = Object:new()
    new.name = self.name
    return new
end

function Object.static.destroy(object, after)
    timer.after(after or 0, function()
        object:_destroy()
    end)
end

function Object:__tostring()
    return self.name
end

return Object