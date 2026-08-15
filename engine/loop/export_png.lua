local nativefs = require("nativefs")

return function(loader)
	print( "duration:", loader.scene:duration().."ms" )
	print( "fps:     ", loader.scene.fps )

	local step = 1000 / loader.scene.fps
	print( "step:    ", step )

	local totalFrames = loader.scene:duration() / 1000 * loader.scene.fps
	local fileFolder = loader.filePath..".frames/"

	local success = nativefs.createDirectory(fileFolder)
	if !success then
		print(err)
		return 0
	end

	local fileFormat = fileFolder.."%0"..#tostring(totalFrames).."d.png"
	print( "frames:  ", totalFrames )
	print( "---------" )

	local canvas = love.graphics.newCanvas(loader.scene.width, loader.scene.height)

	local currentFrame = 0
	local exportedFrames = 0
	-- Main loop time.
	return function()
		if currentFrame > totalFrames then
			return 0
		end
		-- if love.graphics and love.graphics.isActive() then
		love.graphics.setCanvas(canvas)
		love.graphics.origin()
		love.graphics.clear(loader.scene.background)
		loader.scene:draw(currentFrame*step)
		love.graphics.setCanvas()

		local img = canvas:newImageData(nil, 1, 0, 0, loader.scene.width, loader.scene.height)
		local imgData = img:encode("png")
		local success, err = nativefs.write(string.format(fileFormat, currentFrame), imgData)
		if !success then
			print(err)
			return 0
		end

		print("draw frame "..currentFrame.." of "..totalFrames)
		currentFrame = currentFrame + 1
	end
end
