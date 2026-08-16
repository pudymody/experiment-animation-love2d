local colors = require("colors")

local rectangle = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
	width = function(time) return 100 end,
	height = function(time) return 100 end,

	background = function(time) return colors.yin_dark end,

	strokeColor = function(time) return colors.red end,
	strokeWidth = function(time) return 1 end,

	origin = "",
	rotation = function(time) return 0 end,

	__type = "rectangle",
}
rectangle.__index = rectangle

function rectangle:draw(time)
	local x = self.x(time)
	local xOffset = 0
	local y = self.y(time)
	local yOffset = 0
	local width = self.width(time)
	local height = self.height(time)
	local rotation = self.rotation(time)

	love.graphics.translate(x,y)
	love.graphics.rotate(rotation)

	if self.origin == "center" then
		xOffset = -width/2
		yOffset = -height/2
	end

	love.graphics.setColor(self.background(time))
	love.graphics.rectangle(
		"fill",
		xOffset,
		yOffset,
		width,
		height
	)

	local strokeWidth = self.strokeWidth(time)
	if strokeWidth > 0 then
		love.graphics.setColor(self.strokeColor(time))
		love.graphics.setLineWidth(strokeWidth)
		love.graphics.rectangle(
			"line",
			xOffset,
			yOffset,
			width,
			height
		)
	end
end

return function(opts)
	local o = opts or {}
	setmetatable(o, rectangle)
	return o
end
