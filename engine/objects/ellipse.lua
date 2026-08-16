local colors = require("colors")

local ellipse = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
	radiusX = function(time) return 100 end,
	radiusY = function(time) return 100 end,

	background = function(time) return colors.yin_dark end,

	strokeColor = function(time) return colors.red end,
	strokeWidth = function(time) return 1 end,

	rotation = function(time) return 0 end,

	__type = "ellipse",
}
ellipse.__index = ellipse

function ellipse:draw(time)
	local x = self.x(time)
	local y = self.y(time)
	local radiusX = self.radiusX(time)
	local radiusY = self.radiusY(time)
	local rotation = self.rotation(time)

	love.graphics.translate(x,y)
	love.graphics.rotate(rotation)

	love.graphics.setColor(self.background(time))
	love.graphics.ellipse(
		"fill",
		0,
		0,
		radiusX,
		radiusY	
	)

	love.graphics.setColor(self.strokeColor(time))
	love.graphics.setLineWidth(self.strokeWidth(time))
	love.graphics.ellipse(
		"line",
		0,
		0,
		radiusX,
		radiusY
	)
end

return function(opts)
	local o = opts or {}
	setmetatable(o, ellipse)
	return o
end
