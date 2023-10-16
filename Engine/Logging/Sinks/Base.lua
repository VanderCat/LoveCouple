local Logging = require "Engine.Logging"
local sink = Class "Logging.Sink"

function sink:initialize()
end

function sink:onLog()
    error("no sink available!")
end

function sink:connect()
    Logging._sinks[self.class.name] = self
end

function sink:disconnect()
    Logging._sinks[self.class.name] = nil
end

return sink