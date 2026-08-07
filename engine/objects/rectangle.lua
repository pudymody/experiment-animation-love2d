local rectangle = {}
rectangle.__index = rectangle

function rectangle:draw(time)
	love.graphics.setColor(self.background)
	love.graphics.rectangle(
		"fill",
		self.x(time),
		self.y(time),
		self.width(time),
		self.height(time)
	)
end

return function(opts)
	local o = opts or {}
	setmetatable(o, rectangle)
	return o
end
