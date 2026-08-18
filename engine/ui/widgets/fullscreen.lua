local newEventBus = require("events")

local button = {
	foreground = {1,1,1,1},

	x = 0,
	y = 0,

	width = 0,
	height = 0,

	events = nil,

	draw = function(self)
		love.graphics.setColor(self.foreground)
		love.graphics.rectangle(
			"line",
			self.x,
			self.y,
			self.width,
			self.height
		)
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
	end,
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
