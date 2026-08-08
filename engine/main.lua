local newEventBus = require("events")
local newPlayback = require("playback")
local newWindowRenderer = require("renderer.window")
local newLoader = require("loader")

local events = newEventBus()

function love.keypressed(key, scancode, isrepeat)
	events:dispatch("keypressed", {
		key= key,
		scancode = scancode,
		isrepeat = isrepeat
	})
end

function love.mousepressed( x, y, button, istouch, presses )
	events:dispatch("mousepressed", {
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	})
end

function love.mousereleased( x, y, button, istouch, presses )
	events:dispatch("mousereleased", {
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	})
end

function love.mousemoved( x, y, dx,dy, istouch )
	events:dispatch("mousemoved", {
		x = x,
		y = y,
		dx = dx,
		dy = dy,
		istouch = istouch,
	})
end

function love.mousefocus( f )
	events:dispatch("mousefocus", {
		f = f,
	})
end

function love.run()
	local file = love.arg.parseGameArguments(arg)[1]
	local loader, err = newLoader(file)
	if err ~= nil then
		print(err)
		return
	end

	local playback = newPlayback()
	events:on("keypressed", function(e)
		playback:keypressed(e.key,e.scancode,e.isrepeat)
	end)

	local renderer = newWindowRenderer(playback)
	events:on("keypressed", function(e)
		renderer:keypressed(e.key,e.scancode,e.isrepeat)
	end)
	events:on("mousepressed", function(e)
		renderer:mousepressed(e.x,e.y,e.button,e.istouch,e.presses)
	end)
	events:on("mousemoved", function(e)
		renderer:mousemoved(e.x,e.y,e.dx, e.dy,e.istouch)
	end)
	events:on("mousefocus", function(e)
		renderer:mousefocus(e.f)
	end)
	events:on("mousereleased", function(e)
		renderer:mousereleased(e.x,e.y,e.button,e.istouch,e.presses)
	end)

	events:on("keypressed", function(e)
		if e.key == "escape" or e.key == "q" then
			love.event.quit()
		end
	end)

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
			playback:seekBy(love.timer.step() * 1000)
			if playback.position == playback.duration then
				playback:pause()
			end
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
