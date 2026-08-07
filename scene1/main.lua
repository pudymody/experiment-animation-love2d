local newPlayback = require("playback")
local playback = newPlayback()

local newWindowRenderer = require("renderer.window")
local renderer = newWindowRenderer()

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" or key == "q" then
		love.event.quit()
	end

	playback:keypressed(key,scancode,isrepeat)
	renderer:keypressed(key,scancode,isrepeat)
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
	renderer:load(scene)

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
			renderer:load(scene)
			sceneCanvas = love.graphics.newCanvas(scene.width, scene.height)
		end

		-- Update dt, as we'll be passing it to update
		if love.timer and playback.isPlaying then
			playback:seekBy(love.timer.step())
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.setCanvas(sceneCanvas)
			love.graphics.origin()
			love.graphics.clear(scene.background)
			scene:draw(playback.position)

			renderer:draw({ canvas = sceneCanvas, width = scene.width, height = scene.height })
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
