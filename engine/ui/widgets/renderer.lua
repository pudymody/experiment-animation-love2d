local widget = {
	x = 0,
	y = 0,

	width = 0,

	height = 0,
	height_fill = true,

	loader = nil,
	playback = nil,

	draw = function(self)
		love.graphics.setCanvas(self.canvas)
		love.graphics.origin()
		love.graphics.clear(self.loader.scene.background)
		self.loader.scene:draw(self.playback.position)

		local sceneWidth = self.canvas:getWidth() 
		local sceneHeight = self.canvas:getHeight()
		local scale = math.min( self.width / sceneWidth, self.height / sceneHeight)
		local offsetX = self.x + (self.width - (sceneWidth * scale)) / 2
		local offsetY = self.y + (self.height - (sceneHeight * scale)) / 2

		love.graphics.reset()
		love.graphics.draw(self.canvas, offsetX, offsetY, 0, scale, scale)
	end,

	mousepressed = function(self,x, y, button, istouch, presses )
		if y < self.y or y > self.y + self.height then
			return false
		end
		if x < self.x or x > self.x + self.width then
			return false
		end

		self.playback:toggle()
		return true
	end,
}
widget.__index = widget

return function(opts)
	local o = opts or {}

	o.canvas = love.graphics.newCanvas(o.loader.scene.width, o.loader.scene.height)
	o.loader.events:on("loader.update", function(scene)
		o.canvas:release()
		o.canvas = love.graphics.newCanvas(scene.width, scene.height)
	end)

	setmetatable(o, widget)
	return o
end
