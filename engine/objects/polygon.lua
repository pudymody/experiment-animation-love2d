local colors = require("colors")

local polygon = {
	points = {},	

	background = function(time) return colors.yin_dark end,

	strokeColor = function(time) return colors.red end,
	strokeWidth = function(time) return 1 end,

	closed = false,

	origin = "",
	rotation = function(time) return 0 end,

	__type = "polygon",
}
polygon.__index = polygon

function polygon:draw(time)
	local points = {}
	for k,v in ipairs(self.points) do
		table.insert(points, v.x(time))
		table.insert(points, v.y(time))
	end

	if self.closed then
		table.insert(points, self.points[1].x(time))
		table.insert(points, self.points[1].y(time))
	end

	-- local rotation = self.rotation(time)
	--
	-- love.graphics.translate(x,y)
	-- love.graphics.rotate(rotation)
	--
	-- if self.origin == "center" then
	-- 	xOffset = -width/2
	-- 	yOffset = -height/2
	-- end

	if self.closed then
		love.graphics.setColor(self.background(time))
		love.graphics.polygon(
			"fill",
			points
		)
	end

	local strokeWidth = self.strokeWidth(time)
	if strokeWidth > 0 then
		love.graphics.setColor(self.strokeColor(time))
		love.graphics.setLineWidth(strokeWidth)
		love.graphics.line(points)
	end
end

return function(opts)
	local o = opts or {}
	setmetatable(o, polygon)
	return o
end
