local timer = require "hdictus.hump.timer"

local Behaviour = require "Engine.Core.Component" : subclass "Behaviour"

function Behaviour:initialize(gameObject, transform)
    Behaviour.super.initialize(self, gameObject, transform)
    self._invokeList = {}
    self:executeIfAny("awake")
    if self.enabled then
        self:executeIfAny("onEnable")
        self:executeIfAny("start")
    end
end

function Behaviour:executeIfAny(methodName, ...)
    local method = self[methodName]
    if method then
        method(self, ...)
    end
end
function Behaviour:invoke(methodName, time, ...)
    local method = self[methodName]
    if method then
        local params = {...}
        self._invokeList[methodName] = timer.after(time or 0, function ()
            method(self, table.unpack(params))
            self._invokeList[methodName] = nil
        end)
    end
end

function Behaviour:invokeRepeating(methodName, time, rate, ...)
    local method = self[methodName]
    if method then
        rate = rate or time
        local params = {...}
        self._invokeList[methodName] = timer.after(time or 0, function ()
            method(self, table.unpack(params))
            timer.every(rate, function ()
                method(self, table.unpack(params))
            end)
        end)
    end
end

function Behaviour:cancelInvoke(name)
    timer.cancel(self._invokeList[name])
end

function Behaviour:cancelInvokes()
    for invoke, _ in ipairs(self._invokeList) do
        self:cancelInvoke(invoke)
    end
end

function Behaviour:isInvoking(name)
    return self._invokeList[name] and true or false
end

return Behaviour