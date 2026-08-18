local nativefs = require("nativefs")
local colors = require("colors")

local state = {
	loader = nil,

	currentFrame = 0,
	totalFrames = 0,

	fileFormat = "",
	canvas = nil,

	enter = function(self)
		self.totalFrames = math.ceil(self.loader.scene:duration() / self.loader.scene:frameStep())

		local fileFolder = self.loader.filePath..".frames/"
		local success = nativefs.createDirectory(fileFolder)
		if !success then
			print(err)
			return 0
		end

		self.fileFormat = fileFolder.."%0"..#tostring(self.totalFrames).."d.png"
		self.canvas = love.graphics.newCanvas(self.loader.scene.width, self.loader.scene.height)
	end,

	update = function(self)
		if self.currentFrame >= self.totalFrames then
			return
		end

		love.graphics.setCanvas(self.canvas)
		love.graphics.origin()
		love.graphics.clear(self.loader.scene.background)
		self.loader.scene:draw(self.currentFrame*self.loader.scene:frameStep())
		love.graphics.setCanvas()

		local img = self.canvas:newImageData(nil, 1, 0, 0, self.loader.scene.width, self.loader.scene.height)
		local imgData = img:encode("png")
		local success, err = nativefs.write(string.format(self.fileFormat, self.currentFrame), imgData)
		if !success then
			print(err)
			return 0
		end
		self.currentFrame = self.currentFrame + 1
	end,

	draw = function(self)
		local windowWidth, windowHeight = love.window.getMode()

		local radius = math.min(windowWidth/2, windowHeight/2)
		local outerRadius = radius * 0.8
		local innerRadius = radius * 0.7

		love.graphics.reset()
		love.graphics.clear(1,1,1,1)

		love.graphics.setColor(colors.green)

		local percentage = self.currentFrame / self.totalFrames
		local percentageText = math.ceil(percentage*100).."%"

		love.graphics.arc( "fill", windowWidth / 2, windowHeight / 2, outerRadius, 0, math.pi * 2 * percentage, segments )

		love.graphics.setColor(colors.white)
		love.graphics.arc( "fill", windowWidth / 2, windowHeight / 2, innerRadius, 0, math.pi * 2 * percentage, segments )

		love.graphics.setColor(colors.green)
		local font       = love.graphics.getFont()
		local textWidth  = font:getWidth(percentageText)
		local textHeight = font:getHeight()
		love.graphics.print(percentageText, windowWidth / 2 - textWidth / 2, windowHeight / 2 - textHeight / 2)


		textWidth  = font:getWidth(self.fileFormat)
		love.graphics.print(self.fileFormat, windowWidth / 2 - textWidth / 2, windowHeight / 2 + textHeight * 2)

		love.graphics.present()
	end,
}

return function(loader)
	state.loader = loader

	return state
end
