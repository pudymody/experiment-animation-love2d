scene = {}

function scene:setup()
	self.width = 1920
	self.height = 1080
	self.fps = 60
	self.background = {1,1,1,1}
end

local squareSize = 20
local canvasWidth = 1920
local canvasHeight = 1080

function scene:draw(time)
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("fill", 0,0, squareSize,squareSize)
	love.graphics.rectangle("fill", canvasWidth - squareSize,0, squareSize,squareSize)
	love.graphics.rectangle("fill", canvasWidth - squareSize,canvasHeight - squareSize, squareSize,squareSize)
	love.graphics.rectangle("fill", 0,canvasHeight - squareSize, squareSize,squareSize)

	love.graphics.print(time, 400, 100)
end

return scene
