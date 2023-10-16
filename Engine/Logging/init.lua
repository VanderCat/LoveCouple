local Logging = Class "Logger"

Logging.static._sinks = {}
Logging.static.level = "trace"
local levels = {
    fatal = 5, error = 4, warn = 3, info = 2, debug = 1, trace = 0
}

function Logging:initialize(name) 
    self.name = name
end

function Logging.static._addSink(sink)
    Logging[sink.class.name] = sink
end

function Logging.static._removeSink(sink)
    Logging[sink.class.name] = nil
end

function Logging.static._removeSinkByClassName(sink)
    Logging[sink] = nil
end

function Logging:log(level, ...)
    if (levels[level] or -1) < (levels[Logging.level] or -1) then
        return 
    end
    local log = {
        name = self.name,
        timestamp = 0,
        level = level,
        message = {...},
        callInfo = {
            line = 0,
            file = 0
        }
    }
    log.timestamp = os.time()
    local callInfo = debug.getinfo(3)
    log.callInfo.line = callInfo.currentline
    log.callInfo.file = callInfo.short_src
    Logging._sendMessage(log)
end

for name, _ in pairs(levels) do
    Logging[name] = function(self, ...)
        Logging.log(self, name, ...)
    end 
end

function Logging.static._sendMessage(message)
    for name, sink in pairs(Logging._sinks) do
        sink:onLog(message)
    end
end

Logging.static.Logger = Logging:new("Global")

return Logging