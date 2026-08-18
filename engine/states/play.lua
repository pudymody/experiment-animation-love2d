local std = require("std")
local colors = require("colors")
local newPlayback = require("playback")

local newWidgetPlayPause = require("ui.widgets.play_pause")
local newWidgetFullscreen = require("ui.widgets.fullscreen")
local newWidgetPosition = require("ui.widgets.position")
local newWidgetFile = require("ui.widgets.file")
local newWidgetExport = require("ui.widgets.export")
local newWidgetSeekbar = require("ui.widgets.seekbar")
local newWidgetRenderer = require("ui.widgets.renderer")
local newWidgetLayoutHorizontal = require("ui.layout.horizontal")
local newWidgetLayoutVertical = require("ui.layout.vertical")

local state = {
	loader = nil,
	playback = nil,
	root = nil,

	update = function(self)
		self.loader:update()

		-- Update dt, as we'll be passing it to update
		if love.timer and self.playback.isPlaying then
			self.playback:seekBy(love.timer.step() * 1000)
		end
	end,

	draw = function(self)
		if love.graphics and love.graphics.isActive() then
			local windowWidth, windowHeight = love.window.getMode()

			self.root.width = windowWidth
			self.root.height = windowHeight
			love.graphics.clear(colors.black)

			self.root:draw()

			love.graphics.present()
		end
	end,
}
state.__index = state

return function(opts)
	local BAR_HEIGHT = 30
	local BAR_PADDING = 5

	local o = opts or {}
	o.playback = newPlayback()

	local play_pause = newWidgetPlayPause {
		playback = o.playback,
		width = BAR_HEIGHT - BAR_PADDING * 2,
	}
	play_pause.events:on("click", function(e)
		o.playback:toggle()
	end)

	local fullscreen = newWidgetFullscreen {
		width = BAR_HEIGHT - BAR_PADDING * 2,
	}
	fullscreen.events:on("click", function(e)
		std.toggleFullscreen()
	end)

	local position = newWidgetPosition {
		playback = o.playback
	}

	local file = newWidgetFile {
		loader = o.loader
	}

	local export = newWidgetExport {}
	export.events:on("click", function(e)
		events:dispatch("state.change", "export")
	end)

	local seekbar = newWidgetSeekbar {
		playback = o.playback,
	}
	seekbar.events:on("seek", function(percentage)
		o.playback.position = o.playback.duration * percentage
	end)
	local osc = newWidgetLayoutHorizontal {
		padding = BAR_PADDING,
		height = BAR_HEIGHT,
		widgets = {
			play_pause,
			position,
			seekbar,
			fullscreen
		},
	}

	local menu = newWidgetLayoutHorizontal {
		padding = BAR_PADDING,
		height = BAR_HEIGHT,
		widgets = {
			file,
			export,
		},
	}

	local renderer = newWidgetRenderer {
		loader = o.loader,
		playback = o.playback,
	}

	o.root = newWidgetLayoutVertical {
		background = colors.transparent,
		padding = 0,
		widgets = {
			menu,
			renderer,
			osc,
		},
	}

	o.playback:setDuration(o.loader.scene:duration())
	o.playback:setFrameStep(o.loader.scene:frameStep())
	o.loader.events:on("loader.update", function(scene)
		o.playback:setDuration(scene:duration())
		o.playback:setFrameStep(scene:frameStep())
	end)

	events:on("love.keypressed", function(e)
		if e.key == "escape" or e.key == "q" then
			love.event.quit()
		end

		if e.key == "f" then
			std.toggleFullscreen()
		end

		if e.key == "right" then
			o.playback:forward()
		end

		if e.key == "left" then
			o.playback:backward()
		end

		if e.key == "r" then
			o.playback:stop()
		end

		if e.key == "space" then
			o.playback:toggle()
		end

		if e.key == "," then
			o.playback:prevFrame()
		end

		if e.key == "." then
			o.playback:nextFrame()
		end
	end)

	events:on("love.mousepressed", function(e)
		o.root:mousepressed(e.x,e.y,e.button,e.istouch,e.presses)
	end)
	events:on("love.mousemoved", function(e)
		o.root:mousemoved(e.x,e.y,e.dx,e.dy,e.istouch)
	end)
	events:on("love.mousefocus", function(e)
		o.root:mousefocus(e.f)
	end)
	events:on("love.mousereleased", function(e)
		o.root:mousereleased(e.x,e.y,e.button,e.istouch,e.presses)
	end)

	setmetatable(o, state)
	return o 
end
