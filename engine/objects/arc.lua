local colors = require("colors")

local arc = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
	radius = function(time) return 100 end,
	startAngle = function(time) return 0 end,
	endAngle = function(time) return math.pi * 2 end,

	arcType = "open",

	background = function(time) return colors.yin_dark end,

	strokeColor = function(time) return colors.red end,
	strokeWidth = function(time) return 1 end,

	__type = "arc",
}
arc.__index = arc

function arc:draw(time)
	local x = self.x(time)
	local y = self.y(time)
	local radius = self.radius(time)
	local startAngle = self.startAngle(time)
	local endAngle = self.endAngle(time)

	love.graphics.setColor(self.background(time))
	love.graphics.arc(
		"fill",
		self.arcType,
		x,
		y,
		radius,
		startAngle,
		endAngle
	)

	local strokeWidth = self.strokeWidth(time)
	if strokeWidth > 0 then
		love.graphics.setColor(self.strokeColor(time))
		love.graphics.setLineWidth(strokeWidth)
		love.graphics.arc(
			"line",
			self.arcType,
			x,
			y,
			radius,
			startAngle,
			endAngle
		)
	end
end

return function(opts)
	local o = opts or {}
	setmetatable(o, arc)
	return o
end
