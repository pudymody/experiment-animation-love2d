local newPlayback = require("playback")
local newWindowRenderer = require("renderer.window")

function love.keypressed(key, scancode, isrepeat)
	events:dispatch("love.keypressed", {
		key= key,
		scancode = scancode,
		isrepeat = isrepeat
	})
end

function love.mousepressed( x, y, button, istouch, presses )
	events:dispatch("love.mousepressed", {
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	})
end

function love.mousereleased( x, y, button, istouch, presses )
	events:dispatch("love.mousereleased", {
		x = x,
		y = y,
		button = button,
		istouch = istouch,
		presses = presses,
	})
end

function love.mousemoved( x, y, dx,dy, istouch )
	events:dispatch("love.mousemoved", {
		x = x,
		y = y,
		dx = dx,
		dy = dy,
		istouch = istouch,
	})
end

function love.mousefocus( f )
	events:dispatch("love.mousefocus", {
		f = f,
	})
end

return function(loader)
	local canvas = love.graphics.newCanvas(loader.scene.width, loader.scene.height)
	events:on("loader.update", function(scene)
		canvas:release()
		canvas = love.graphics.newCanvas(scene.width, scene.height)
	end)

	local playback = newPlayback()
	playback:setDuration(loader.scene:duration())
	playback:setFrameStep(loader.scene:frameStep())
	events:on("loader.update", function(scene)
		playback:setDuration(scene:duration())
		playback:setFrameStep(scene:frameStep())
	end)

	local renderer = newWindowRenderer(playback)
	events:on("love.keypressed", function(e)
		renderer:keypressed(e.key,e.scancode,e.isrepeat)
	end)
	events:on("love.mousepressed", function(e)
		renderer:mousepressed(e.x,e.y,e.button,e.istouch,e.presses)
	end)
	events:on("love.mousemoved", function(e)
		renderer:mousemoved(e.x,e.y,e.dx, e.dy,e.istouch)
	end)
	events:on("love.mousefocus", function(e)
		renderer:mousefocus(e.f)
	end)
	events:on("love.mousereleased", function(e)
		renderer:mousereleased(e.x,e.y,e.button,e.istouch,e.presses)
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

		loader:update()

		-- Update dt, as we'll be passing it to update
		if love.timer and playback.isPlaying then
			playback:seekBy(love.timer.step() * 1000)
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.setCanvas(canvas)
			love.graphics.origin()
			love.graphics.clear(loader.scene.background)
			loader.scene:draw(playback.position)

			renderer:draw(canvas)
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
