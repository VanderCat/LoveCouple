local dt = 0
local sceneManager = require "Engine.Core.SceneManagement.SceneManager"


local function mainLoop()
    local currentScene = sceneManager:getActiveScene()
    local sceneValid = currentScene:isValid()
    local sceneGameObjects = currentScene.gameObjects

    if love.event then
        love.event.pump()
        for name, a,b,c,d,e,f in love.event.poll() do
            if name == "quit" then
                if not love.quit or not love.quit() then
                    return a or 0
                end
            end
            love.handlers[name](a,b,c,d,e,f)
        end
    end

    -- Update dt, as we'll be passing it to update
    if love.timer then 
        dt = love.timer.step()
    end

    if love.update then 
        love.update(dt) -- will pass 0 if love.timer is disabled
    end 
    if sceneValid then
        currentScene:_update(dt)
    end

    if love.graphics and love.graphics.isActive() then
        love.graphics.origin()
        love.graphics.clear(love.graphics.getBackgroundColor())

        if sceneValid then
            currentScene:_draw()
        end
        if love.draw then 
            love.draw()
        end

        love.graphics.present()
    end

    if love.timer then 
        love.timer.sleep(MAX_FPS) 
    end
end

function love.run()
	if love.load then 
        love.load(love.arg.parseGameArguments(arg), arg) 
    end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then 
        love.timer.step() 
    end

	-- Main loop time.
	return mainLoop
end