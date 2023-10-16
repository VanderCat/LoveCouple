local Serpent = require "pkulchenko.serpent"
local ConsoleSink = require "Engine.Logging.Sinks.Base" : subclass "Logging.Sinks.Console"

function ConsoleSink:initialize(format, dateformat) 
    ConsoleSink.super.initialize(self, name)
    self.format = format
    self.dateformat = dateformat or "%H:%M:%S"
    
    self.colors = {
        clear = "\27[0m",
        fatal = "\27[35m",
        error = "\27[31m",
        warn = "\27[33m",
        info = "\27[32m",
        debug = "\27[36m",
        trace = "\27[34m"
    }
    self.names = {
        unknown = "UNK",
        fatal =   "FAT",
        error =   "ERR",
        warn  =   "WRN",
        info  =   "INF",
        debug =   "DBG",
        trace =   "TRC"
    }
end

function ConsoleSink:onLog(log)
    local rawMessage = {}
    local prettyLog = {
        name = log.name,
        date = os.date(self.dateformat),
        timestamp = log.timestamp,
        level = self.names[log.level] or self.names["unknown"],
        color = self.colors[log.level] or self.colors["clear"],
        reset = self.colors["clear"],
        file = log.callInfo.file,
        line = log.callInfo.line,
        message = ""
    }
    for _, messagePart in pairs(log.message) do
        if type(messagePart) == "table" then
            messagePart = Serpent.line(messagePart, {comment=false})
        end
        rawMessage[#rawMessage+1] = messagePart
    end
    prettyLog.message = table.concat(rawMessage, "\t")
    if type(rawMessage[1]) == "string" then
        local formatStr = table.remove(rawMessage, 1)
        local formattedStr = Lume.format(formatStr, rawMessage)
        prettyLog.message = formatStr == formattedStr and prettyLog.message or formattedStr
    end
    print(Lume.format(self.format, prettyLog))
end

return ConsoleSink