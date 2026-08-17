local nativefs = require("nativefs")

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
		if self.currentFrame > self.totalFrames then
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
		love.graphics.reset()
		love.graphics.clear(0,0,0,1)
		love.graphics.print("Duration: "..self.loader.scene:duration().."ms", 10, 10)
		love.graphics.print("FPS: "..self.loader.scene.fps, 10, 30)
		love.graphics.print("Step: "..self.loader.scene:frameStep(), 10, 50)
		love.graphics.print("File format: "..self.fileFormat, 10, 70)
		love.graphics.print("Total frames: "..self.totalFrames, 10, 90)
		love.graphics.print("Current frame: "..self.currentFrame, 10, 110)
		love.graphics.present()
	end,
}

return function(loader)
	state.loader = loader

	return state
end
