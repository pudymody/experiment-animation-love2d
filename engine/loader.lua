local nativefs = require("nativefs")

return function(file, events)
	local loader = {
		filePath = file,
		fileLastModified = 0,
		fileLastCheck = 0,
		fileCheckIntervalMS = 250,
		scene = nil,
		events = events,

		update = function(self)
			-- hotreload file based on https://github.com/kjarvi/monocle/blob/master/monocle.lua
			local now = love.timer.getTime() * 1000
			if now - self.fileLastCheck < self.fileCheckIntervalMS and self.fileLastCheck > 0 then
				return false
			end

			self.fileLastCheck = now
			local fileInfo = nativefs.getInfo(self.filePath)
			if fileInfo ~= nil and self.fileLastModified ~= fileInfo.modtime then
				self.fileLastModified = fileInfo.modtime
				self.scene = loadfile(self.filePath)()
				events:dispatch("loader.update", self.scene)
				return true
			end

			return false
		end
	}

	loader:update()
	return loader
end
