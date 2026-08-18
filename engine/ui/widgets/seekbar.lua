local colors = require("colors")
local newEventBus = require("events")

local widget = {
	background = colors.yin,
	foreground = colors.white,

	x = 0,
	y = 0,

	width = 0,
	width_fill = true,

	height = 0,

	playback = nil,
	playback_wasPlaying = false,

	pressed = false,

	events = nil,

	mousereleased = function(self,x, y, button, istouch, presses )
		if self.pressed and self.playback_wasPlaying then
			self.playback:play()
		end
		self.pressed = false

		return false
	end,

	mousemoved = function(self,x, y, dx, dy, istouch )
		if self.pressed then
			self:seek(x)
		end

		return false
	end,

	mousefocus = function(self, f)
		if not f then
			self.pressed = false
		end

		return false
	end,

	mousepressed = function(self,x, y, button, istouch, presses )
		if y < self.y or y > self.y + self.height then
			return false
		end
		if x < self.x or x > self.x + self.width then
			return false
		end

		self.pressed = true
		self:seek(x)
		self.playback_wasPlaying = self.playback.isPlaying
		self.playback:pause()

		return false
	end,

	seek = function(self,x)
		local percentage = (x - self.x) / self.width
		percentage = math.min(percentage, 1)
		percentage = math.max(percentage, 0)
		self.events:dispatch("seek", percentage)
	end,

	draw = function(self)
		love.graphics.setColor(self.background)
		love.graphics.rectangle(
			"fill",
			self.x,
			self.y,
			self.width,
			self.height
		)

		love.graphics.setColor(self.foreground)
		local currentSeekbarWidth = self.width * (self.playback.position / self.playback.duration)
		love.graphics.rectangle(
			"fill",
			self.x,
			self.y,
			currentSeekbarWidth,
			self.height
		)
	end,
}
widget.__index = widget

return function(opts)
	local o = opts or {}
	o.playback_wasPlaying = false
	o.pressed = false

	if o.events == nil then
		o.events = newEventBus()
	end

	setmetatable(o, widget)
	return o
end
