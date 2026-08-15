local line = {
	startPoint = {
		x = function(time) return 0 end,
		y = function(time) return 0 end,
	},
	endPoint = {
		x = function(time) return 0 end,
		y = function(time) return 0 end,
	},

	strokeColor = {1,0,0,1},
	strokeWidth = function(time) return 1 end,
}
line.__index = line 

function line:draw(time)
	love.graphics.setColor(self.strokeColor)
	love.graphics.setLineWidth(self.strokeWidth(time))
	love.graphics.line(
		self.startPoint.x(time),
		self.startPoint.y(time),
		self.endPoint.x(time),
		self.endPoint.y(time)
	)
end

return function(opts)
	local o = opts or {}
	setmetatable(o, line)
	return o
end
