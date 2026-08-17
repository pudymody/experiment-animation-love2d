local newPlayback = require("playback")
-- TODO: Maybe this isnt needed anymore and could be done here
local newWindowRenderer = require("renderer.window")

local state = {
	loader = nil,
	playback = nil,
	canvas = nil,
	renderer = nil,

	update = function(self)
		self.loader:update()

		-- Update dt, as we'll be passing it to update
		if love.timer and self.playback.isPlaying then
			self.playback:seekBy(love.timer.step() * 1000)
		end
	end,
	draw = function(self)
		if love.graphics and love.graphics.isActive() then
			love.graphics.setCanvas(self.canvas)
			love.graphics.origin()
			love.graphics.clear(self.loader.scene.background)
			self.loader.scene:draw(self.playback.position)

			self.renderer:draw(self.canvas)
		end
	end,
}

return function(loader, events)
	state.loader = loader
	state.canvas = love.graphics.newCanvas(loader.scene.width, loader.scene.height)

	events:on("loader.update", function(scene)
		state.canvas:release()
		state.canvas = love.graphics.newCanvas(scene.width, scene.height)
	end)

	state.playback = newPlayback()
	state.playback:setDuration(loader.scene:duration())
	state.playback:setFrameStep(loader.scene:frameStep())
	events:on("loader.update", function(scene)
		state.playback:setDuration(scene:duration())
		state.playback:setFrameStep(scene:frameStep())
	end)

	state.renderer = newWindowRenderer(state.playback, loader, events)
	events:on("love.keypressed", function(e)
		state.renderer:keypressed(e.key,e.scancode,e.isrepeat)
	end)
	events:on("love.mousepressed", function(e)
		state.renderer:mousepressed(e.x,e.y,e.button,e.istouch,e.presses)
	end)
	events:on("love.mousemoved", function(e)
		state.renderer:mousemoved(e.x,e.y,e.dx, e.dy,e.istouch)
	end)
	events:on("love.mousefocus", function(e)
		state.renderer:mousefocus(e.f)
	end)
	events:on("love.mousereleased", function(e)
		state.renderer:mousereleased(e.x,e.y,e.button,e.istouch,e.presses)
	end)

	return state
end
