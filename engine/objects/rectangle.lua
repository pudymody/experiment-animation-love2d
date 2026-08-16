local colors = require("colors")

local rectangle = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
	width = function(time) return 100 end,
	height = function(time) return 100 end,

	background = function(time) return colors.yin_dark end,

	strokeColor = function(time) return colors.red end,
	strokeWidth = function(time) return 1 end,

	rotation = function(time) return 0 end,

	__type = "rectangle",
}
rectangle.__index = rectangle

function rectangle:draw(time)
	local x = self.x(time)
	local y = self.y(time)
	local width = self.width(time)
	local height = self.height(time)
	local rotation = self.rotation(time)

	love.graphics.translate(x,y)
	love.graphics.rotate(rotation)

	love.graphics.setColor(self.background(time))
	love.graphics.rectangle(
		"fill",
		-width/2,
		-height/2,
		width,
		height
	)

	local strokeWidth = self.strokeWidth(time)
	if strokeWidth > 0 then
		love.graphics.setColor(self.strokeColor(time))
		love.graphics.setLineWidth(strokeWidth)
		love.graphics.rectangle(
			"line",
			-width/2,
			-height/2,
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
