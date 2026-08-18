local std = require("std")

local widget = {
	foreground = {1,1,1,1},

	x = 0,
	y = 0,

	width = 0,
	height = 0,

	playback = nil,

	positionFormat = function(self)
		local current = std.parseMilliseconds(self.playback.position)
		local total = std.parseMilliseconds(self.playback.duration)

		if total.minutes == 0 then
			return string.format(
				"%02d:%03d / %02d:%03d",

				current.seconds,
				current.milliseconds,

				total.seconds,
				total.milliseconds
			)
		end

		if total.hours == 0 then
			return string.format(
				"%02d:%02d:%03d / %02d:%02d:%03d",

				current.minutes,
				current.seconds,
				current.milliseconds,

				total.minutes,
				total.seconds,
				total.milliseconds
			)
		end
	end,

	draw = function(self)
		love.graphics.setColor(self.foreground)

		local font       = love.graphics.getFont()
		local text = self:positionFormat()
		local textWidth  = font:getWidth(text)
		local textHeight = font:getHeight()
		love.graphics.print(
			text,
			self.x,
			self.y - textHeight/2 + self.height / 2
		)

		self.width = textWidth
	end,

	mousepressed = function(self,x, y, button, istouch, presses )
		if y < self.y or y > self.y + self.height then
			return false
		end
		if x < self.x or x > self.x + self.width then
			return false
		end

		return true
	end
}
widget.__index = widget

return function(opts)
	local o = opts or {}

	setmetatable(o, widget)
	return o
end
