local colors = require("colors")

local vertical_layout = {
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
		local accumulatedHeight = 0
		for i,v in ipairs(self.widgets) do
			if seenGrow and v.height_fill then
				error("Vertical layout allows only one fill width item")
				return
			end

			if v.height_fill then
				seenGrow =  true
			else
				accumulatedHeight = accumulatedHeight + v.height + self.padding
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

		self.currentOffset = self.y
		for i,v in ipairs(self.widgets) do
			v.y = self.currentOffset + self.padding
			v.x = self.x + self.padding
			v.width = self.width - self.padding * 2

			if v.height_fill then
				v.height = self.height - self.padding * 2 - accumulatedHeight
			end

			v:draw()
			self.currentOffset = self.currentOffset + v.height + self.padding
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

		return true
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

vertical_layout.__index = vertical_layout

return function(opts)
	local o = opts or {}
	setmetatable(o, vertical_layout)
	return o
end
