local timer = require "hdictus.hump.timer"

local Behaviour = require "Engine.Core.Component" : subclass "Behaviour"

function Behaviour:initialize(gameObject, transform, isEnabled)
    Behaviour.super.initialize(self, gameObject, transform, isEnabled)
    self._invokeList = {}
end

function Behaviour:_onInitialize()
    Behaviour.super._onInitialize(self)
    self:executeIfAny("awake")
    coroutine.yield("awake()")
    if self.enabled then
        self:onEnable()
    end
    coroutine.yield("start()")
end

function Behaviour:onEnable()
    Behaviour.super.onEnable(self)
    self:executeIfAny("start")
end

function Behaviour:_destroy()
    Behaviour.super._destroy(self)
    self:cancelInvokes()
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
            method(self, unpack(params))
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
    for invoke, _ in pairs(self._invokeList) do
        self:cancelInvoke(invoke)
    end
end

function Behaviour:isInvoking(name)
    return self._invokeList[name] and true or false
end

return Behaviour