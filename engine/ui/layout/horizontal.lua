local colors = require("colors")

local horizontal_layout = {
	background = colors.yin_dark,
	padding = 0,
	currentOffset = 0,

	x = 0,
	y = 0,
	width = 0,
	height = 0,

	widgets = {},

	draw = function(self)
		local seenGrow = false
		local accumulatedWidth = 0
		for i,v in ipairs(self.widgets) do
			if seenGrow and v.width_fill then
				error("Horizonal layout allows only one fill width item")
				return
			end

			if v.width_fill then
				seenGrow =  true
			else
				accumulatedWidth = accumulatedWidth + v.width + self.padding
			end
		end

		-- osc background
		love.graphics.setColor(self.background)
		love.graphics.rectangle(
			"fill",
			self.x,
			self.y,
			self.width,
			self.height
		)

		self.currentOffset = self.x
		for i,v in ipairs(self.widgets) do
			v.x = self.currentOffset + self.padding
			v.y = self.y + self.padding
			v.height = self.height - self.padding * 2

			if v.width_fill then
				v.width = self.width - self.padding * 2 - accumulatedWidth
			end

			v:draw()
			self.currentOffset = self.currentOffset + v.width + self.padding
		end
	end,

	mousepressed = function(self,x, y, button, istouch, presses )
		if y < self.y or y > self.y + self.height then
			return false
		end
		if x < self.x or x > self.x + self.width then
			return false
		end

		for i,v in ipairs(self.widgets) do
			if v.mousepressed != nil and v:mousepressed(x,y,button,istouch,presses) then
				return true
			end
		end

		return true
	end,
	mousemoved = function(self,x, y, dx, dy, istouch )
		for i,v in ipairs(self.widgets) do
			if v.mousemoved != nil and v:mousemoved(x,y,dx,dy,istouch) then
				return true
			end
		end

		return false
	end,
	mousefocus = function(self, f)
		for i,v in ipairs(self.widgets) do
			if v.mousefocus != nil and v:mousefocus(f) then
				return true
			end
		end

		return false
	end,
	mousereleased = function(self,x, y, button, istouch, presses )
		for i,v in ipairs(self.widgets) do
			if v.mousereleased != nil and v:mousereleased(x,y,button,istouch,presses) then
				return true
			end
		end

		return false
	end,
}

horizontal_layout.__index = horizontal_layout

return function(opts)
	local o = opts or {}
	setmetatable(o, horizontal_layout)
	return o
end
