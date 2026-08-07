return function(file)
	if file == nil then
		return nil, "You have to provide a valid scene file to run"
	end

	return {
		filePath = file,
		fileLastModified = 0,
		scene = nil,
		canvas = nil,

		update = function(self)
			-- hotreload file based on https://github.com/kjarvi/monocle/blob/master/monocle.lua
			local fileInfo = love.filesystem.getInfo(self.filePath)
			if fileInfo ~= nil and self.fileLastModified ~= fileInfo.modtime then
				if self.canvas ~= nil then
					self.canvas:release()
				end

				self.fileLastModified = fileInfo.modtime
				self.scene = love.filesystem.load(self.filePath)()
				self.scene:setup()
				self.canvas = love.graphics.newCanvas(self.scene.width, self.scene.height)
				return true
			end

			return false
		end
	}
end
