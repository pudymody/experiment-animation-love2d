local colors = require("colors")

local circle = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
	radius = function(time) return 100 end,

	background = function(time) return colors.yin_dark end,

	strokeColor = function(time) return colors.red end,
	strokeWidth = function(time) return 1 end,

	__type = "circle",
}
circle.__index = circle

function circle:draw(time)
	local x = self.x(time)
	local y = self.y(time)
	local radius = self.radius(time)

	love.graphics.setColor(self.background)
	love.graphics.circle(
		"fill",
		x,
		y,
		radius
	)

	love.graphics.setColor(self.strokeColor)
	love.graphics.setLineWidth(self.strokeWidth(time))
	love.graphics.circle(
		"line",
		x,
		y,
		radius	
	)
end

return function(opts)
	local o = opts or {}
	setmetatable(o, circle)
	return o
end
