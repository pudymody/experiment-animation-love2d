local newEventBus = require("events")

local button = {
	foreground = {1,1,1,1},

	x = 0,
	y = 0,

	width = 0,
	height = 0,

	events = nil,
	playback = nil,

	play = function(self)
		love.graphics.setColor(self.foreground)
		love.graphics.polygon(
			"fill",
			self.x, self.y,
			self.x + self.width, self.y + self.height / 2,
			self.x, self.y + self.height
		)
	end,

	pause = function(self)
		love.graphics.setColor(self.foreground)
		local barWidth = self.width / 3
		love.graphics.rectangle(
			"fill",
			self.x,
			self.y,
			barWidth,
			self.height
		)
		love.graphics.rectangle(
			"fill",
			self.x + barWidth * 2,
			self.y,
			barWidth,
			self.height
		)
	end,

	draw = function(self)
		if self.playback.isPlaying then
			self:pause()		
		else
			self:play()		
		end
	end,

	mousepressed = function(self,x, y, button, istouch, presses )
		if y < self.y or y > self.y + self.height then
			return false
		end
		if x < self.x or x > self.x + self.width then
			return false
		end

		self.events:dispatch("click")
		return true
	end
}
button.__index = button

return function(opts)
	local o = opts or {}

	if o.events == nil then
		o.events = newEventBus()
	end

	setmetatable(o, button)
	return o
end
