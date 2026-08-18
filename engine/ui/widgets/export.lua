local std = require("std")
local newEventBus = require("events")

local widget = {
	foreground = {1,1,1,1},

	x = 0,
	y = 0,

	width = 0,
	height = 0,

	events = nil,

	draw = function(self)
		love.graphics.setColor(self.foreground)

		local font       = love.graphics.getFont()
		local text = "Export" 
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

		self.events:dispatch("click")
		return true
	end
}
widget.__index = widget

return function(opts)
	local o = opts or {}

	if o.events == nil then
		o.events = newEventBus()
	end

	setmetatable(o, widget)
	return o
end
