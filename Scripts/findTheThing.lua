local Find = require "Engine.Core.Behaviour" : subclass "FindTheThing"

Find.isFound = false

function Find:awake()
end

function Find:start()

end

function Find:update(dt)
    self.isFound = self.transform:find("im/here/uwu") and true or false
end

function Find:onDrawGui()
    love.graphics.print(self.isFound and "found it!" or "ehhh... can't find \"im/here/uwu\" in me..", 300, 80)
end

return Find
