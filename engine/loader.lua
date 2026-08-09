local nativefs = require("nativefs")

return function(file, events)
	if file == nil then
		return nil, "You have to provide a valid scene file to run"
	end

	local loader = {
		filePath = file,
		fileLastModified = 0,
		fileLastCheck = 0,
		fileCheckIntervalSeconds = 1,
		scene = nil,
		events = events,

		update = function(self)
			-- hotreload file based on https://github.com/kjarvi/monocle/blob/master/monocle.lua
			local now = os.time()
			if now - self.fileLastCheck < self.fileCheckIntervalSeconds then
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
