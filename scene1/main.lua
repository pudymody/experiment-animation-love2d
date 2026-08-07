local positionSeekStep = 2
local position = 0
local isPlaying = true
local isFullscreen = false 

local windowFlags = {
	fullscreen = false,
	resizable = true,
}

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" or key == "q" then
		love.event.quit()
	end

	if key == "right" then
		position = position + positionSeekStep
	end

	if key == "left" then
		position = position - positionSeekStep
		position = math.max(position, 0)
	end

	if key == "r" then
		position = 0 
	end

	if key == "space" then
		love.timer.step()
		isPlaying = not isPlaying
	end

	if key == "f" then
		fullscreen = not fullscreen
		love.window.setFullscreen(fullscreen)
	end
end

function love.run()
	local file = love.arg.parseGameArguments(arg)[1]
	if file == nil then
		print("You have to provide a valid scene file to run")
		return
	end

	local fileLastModified = love.filesystem.getInfo(file).modtime

	local scene = love.filesystem.load(file)()
	scene:setup()
	love.window.setMode(scene.width, scene.height, windowFlags)

	local sceneCanvas = love.graphics.newCanvas(scene.width, scene.height)

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	-- Main loop time.
	return function()
		-- Process events.
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

		-- hotreload file based on https://github.com/kjarvi/monocle/blob/master/monocle.lua
		local fileInfo = love.filesystem.getInfo(file)
		if fileInfo ~= nil and fileLastModified ~= fileInfo.modtime then
			fileLastModified = fileInfo.modtime
			sceneCanvas.release()
			scene = love.filesystem.load(file)()
			scene:setup()
			love.window.setMode(scene.width, scene.height, windowFlags)
			sceneCanvas = love.graphics.newCanvas(scene.width, scene.height)
		end

		-- Update dt, as we'll be passing it to update
		if love.timer and isPlaying then
			position = position + love.timer.step()
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.setCanvas(sceneCanvas)
			love.graphics.origin()
			love.graphics.clear(scene.background)
			scene:draw(position)

			local windowWidth, windowHeight = love.window.getMode()
			local scale = math.min( windowWidth / scene.width, windowHeight / scene.height)
			local offsetX = (windowWidth - (scene.width * scale)) / 2
			local offsetY = (windowHeight - (scene.height * scale)) / 2

			love.graphics.reset()
			love.graphics.clear(0,0,0,1)
			love.graphics.draw(sceneCanvas, offsetX, offsetY, 0, scale, scale)

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
