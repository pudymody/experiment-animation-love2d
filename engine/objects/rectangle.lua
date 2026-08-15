local rectangle = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
	width = function(time) return 100 end,
	height = function(time) return 100 end,

	background = {0,0,0,1},

	strokeColor = {1,0,0,1},
	strokeWidth = function(time) return 1 end,

	rotation = function(time) return 0 end,
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

	love.graphics.setColor(self.background)
	love.graphics.rectangle(
		"fill",
		-width/2,
		-height/2,
		width,
		height
	)

	love.graphics.setColor(self.strokeColor)
	love.graphics.setLineWidth(self.strokeWidth(time))
	love.graphics.rectangle(
		"line",
		-width/2,
		-height/2,
		width,
		height
	)
end

return function(opts)
	local o = opts or {}
	setmetatable(o, rectangle)
	return o
end
