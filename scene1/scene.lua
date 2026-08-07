local squareSize = 20
local canvasWidth = 1920
local canvasHeight = 1080

return {
	width = 1920,
	height = 1080,
	fps = 60,
	background = {1,1,1,1},

	draw = function(self,time)
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("fill", 0,0, squareSize,squareSize)
		love.graphics.rectangle("fill", canvasWidth - squareSize,0, squareSize,squareSize)
		love.graphics.rectangle("fill", canvasWidth - squareSize,canvasHeight - squareSize, squareSize,squareSize)
		love.graphics.rectangle("fill", 0,canvasHeight - squareSize, squareSize,squareSize)

		love.graphics.print(time, 400, 100)
	end
}
