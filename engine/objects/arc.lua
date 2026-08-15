local arc = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
	radius = function(time) return 100 end,
	startAngle = function(time) return 0 end,
	endAngle = function(time) return math.pi * 2 end,

	arcType = "open",

	background = {0,0,0,1},

	strokeColor = {1,0,0,1},
	strokeWidth = function(time) return 1 end,
}
arc.__index = arc

function arc:draw(time)
	local x = self.x(time)
	local y = self.y(time)
	local radius = self.radius(time)
	local startAngle = self.startAngle(time)
	local endAngle = self.endAngle(time)

	love.graphics.setColor(self.background)
	love.graphics.arc(
		"fill",
		self.arcType,
		x,
		y,
		radius,
		startAngle,
		endAngle
	)

	love.graphics.setColor(self.strokeColor)
	love.graphics.setLineWidth(self.strokeWidth(time))
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

return function(opts)
	local o = opts or {}
	setmetatable(o, arc)
	return o
end
