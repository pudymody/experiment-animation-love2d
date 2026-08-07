return function()
	return {
		isPlaying = true,

		position = 0,
		positionSeekStep = 2,
		duration = 0,

		setDuration = function(self, d)
			self.duration = d
		end,

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
			self.position = math.min(self.duration, self.position + self.positionSeekStep)
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
			self.position = math.min(self.position, self.duration)
		end,

		keypressed = function(self, key, scancode, isrepeat)
			if key == "right" then
				self:forward()
			end

			if key == "left" then
				self:backward()
			end

			if key == "r" then
				self:stop()
			end

			if key == "space" then
				love.timer.step()
				self:toggle()
			end
		end
	}
end
