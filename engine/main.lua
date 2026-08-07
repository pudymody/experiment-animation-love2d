local newPlayback = require("playback")
local playback = newPlayback()

local newWindowRenderer = require("renderer.window")
local renderer = newWindowRenderer()

local newLoader = require("loader")

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" or key == "q" then
		love.event.quit()
	end

	playback:keypressed(key,scancode,isrepeat)
	renderer:keypressed(key,scancode,isrepeat)
end

function love.run()
	local file = love.arg.parseGameArguments(arg)[1]
	local loader, err = newLoader(file)
	if err ~= nil then
		print(err)
		return
	end

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

		if loader:update() then
			playback:setDuration(loader.scene:duration())
		end

		-- Update dt, as we'll be passing it to update
		if love.timer and playback.isPlaying then
			playback:seekBy(love.timer.step())
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.setCanvas(loader.canvas)
			love.graphics.origin()
			love.graphics.clear(loader.scene.background)
			loader.scene:draw(playback.position)

			renderer:draw(loader.canvas)
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
