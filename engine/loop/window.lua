local statePlay = require("states.play")
local stateExport = require("states.export")

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

function love.filedropped( f )
	events:dispatch("love.filedropped", {
		f = f,
	})
end

local states = {}
local currentState = "play"

return function(loader)
	states.play = statePlay(loader, events)
	states.export = stateExport(loader, events)

	love.keyboard.setKeyRepeat(true)

	events:on("love.filedropped", function(e)
		loader.filePath = e.f:getFilename()
		loader.fileLastCheck = 0
	end)
	-- TODO: Abstract a little more the state change and events interaction
	events:on("export", function(e)
		states.export:enter()
		currentState = "export"
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

		local state = states[currentState]
		state:update()
		state:draw()

		if love.timer then love.timer.sleep(0.001) end
	end
end
