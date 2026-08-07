return function()
	return {
		isPlaying = true,

		position = 0,
		positionSeekStep = 2,

		play = function(self)
			self.isPlaying = true
		end,

		pause = function(self)
			self.isPlaying = false
		end,

		toggle = function(self)
			self.isPlaying = not self.isPlaying
		end,

		forward = function(self)
			self.position = self.position + self.positionSeekStep
		end,

		backward = function(self)
			self.position = self.position - self.positionSeekStep
			self.position = math.max(self.position, 0)
		end,

		stop = function(self)
			self.position = 0
			self.isPlaying = false
		end,

		seekBy = function(self, dur)
			self.position = self.position + dur
			self.position = math.max(self.position, 0)
		end
	}
end
