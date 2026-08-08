-- https://forums.mudlet.org/viewtopic.php?t=3258
function parseTime(milliseconds)
  local totalseconds = math.floor(milliseconds / 1000)
  milliseconds = milliseconds % 1000
  local seconds = totalseconds % 60
  local minutes = math.floor(totalseconds / 60)
  local hours = math.floor(minutes / 60)
  minutes = minutes % 60

	return { milliseconds = milliseconds, seconds = seconds, minutes = minutes, hours = hours }
end

local osc = {
	background = {0.2,0.2,0.2,1},
	padding = 5,
	currentOffset = 0,
	seekbar_background = {0.3, 0.3, 0.3, 1},
	seekbar_foreground = {1,1,1,1},
	seekbar_offset = 0,
	seekbar_width = 0,

	x = 0,
	y = 0,
	width = 0,
	height = 30,

	playback = nil,
	playback_wasPlaying = false,

	seekbar_pressed = false,

	playButton = function(self)
		love.graphics.setColor(self.seekbar_foreground)
		love.graphics.polygon(
			"fill",
			self.currentOffset + self.padding, self.y + self.padding,
			self.currentOffset + self.height - self.padding, self.y + self.padding + (self.height - self.padding * 2) / 2,
			self.currentOffset + self.padding, self.y + self.height - self.padding
		)

		self.currentOffset = self.currentOffset + self.height
	end,

	pauseButton = function(self)
		love.graphics.setColor(self.seekbar_foreground)
		local barWidth = (self.height - self.padding * 2) / 3
		love.graphics.rectangle(
			"fill",
			self.currentOffset + self.padding,
			self.y + self.padding,
			barWidth,
			self.height - self.padding * 2
		)
		love.graphics.rectangle(
			"fill",
			self.currentOffset + self.padding + barWidth * 2,
			self.y + self.padding,
			barWidth,
			self.height - self.padding * 2
		)
		self.currentOffset = self.currentOffset + self.height
	end,

	positionFormat = function(self)
		local current = parseTime(self.playback.position)
		local total = parseTime(self.playback.duration)

		if total.minutes == 0 then
			return string.format(
				"%02d:%03d / %02d:%03d",

				current.seconds,
				current.milliseconds,

				total.seconds,
				total.milliseconds
			)
		end

		if total.hours == 0 then
			return string.format(
				"%02d:%02d:%03d / %02d:%02d:%03d",

				current.minutes,
				current.seconds,
				current.milliseconds,

				total.minutes,
				total.seconds,
				total.milliseconds
			)
		end
	end,

	playbackPosition = function(self)
		love.graphics.setColor(self.seekbar_foreground)

		local font       = love.graphics.getFont()
		local text = self:positionFormat()
		local textWidth  = font:getWidth(text)
		local textHeight = font:getHeight()
		love.graphics.print(
			text,
			self.currentOffset + self.padding,
			self.y + self.padding + (self.height - self.padding * 2)/2 - textHeight/2
		)

		self.currentOffset = self.currentOffset + self.padding * 2 + textWidth
	end,

	seekbar = function(self)
		self.seekbar_width = self.width - self.padding*2 - self.currentOffset
		self.seekbar_offset = self.currentOffset

		love.graphics.setColor(self.seekbar_background)
		love.graphics.rectangle(
			"fill",
			self.currentOffset + self.padding,
			self.y + self.padding,
			self.seekbar_width,
			self.height - self.padding * 2
		)

		love.graphics.setColor(self.seekbar_foreground)
		local currentSeekbarWidth = self.seekbar_width * (self.playback.position / self.playback.duration)
		love.graphics.rectangle(
			"fill",
			self.currentOffset + self.padding,
			self.y + self.padding,
			currentSeekbarWidth,
			self.height - self.padding * 2
		)
	end,

	draw = function(self)
		self.currentOffset = self.x

		-- osc background
		love.graphics.setColor(self.background)
		love.graphics.rectangle(
			"fill",
			self.x,
			self.y,
			self.width,
			self.height
		)

		-- play/pause button
		if self.playback.isPlaying then
			self:pauseButton()		
		else
			self:playButton()		
		end

		-- duration
		self:playbackPosition()

		-- seekbar
		self:seekbar()

	end,

	seek = function(self,x)
		local percentage = (x - self.seekbar_offset - self.padding) / self.seekbar_width
		percentage = math.min(percentage, 1)
		percentage = math.max(percentage, 0)
		self.playback.position = self.playback.duration * percentage
	end,

	-- this is super fragile as it depends on the order we draw them
	mousepressed = function(self,x, y, button, istouch, presses )
		if x <= self.height then
			self.playback:toggle()
		end

		if x >= self.seekbar_offset and x <= self.seekbar_offset + self.seekbar_width then
			self.seekbar_pressed = true
			self:seek(x)
			self.playback_wasPlaying = self.playback.isPlaying
			self.playback:pause()
		end
	end,

	mousereleased = function(self,x, y, button, istouch, presses )
		if self.seekbar_pressed and self.playback_wasPlaying then
			self.playback:play()
		end
		self.seekbar_pressed = false
	end,

	mousemoved = function(self,x, y, dx, dy, istouch )
		if self.seekbar_pressed then
			self:seek(x)
		end
	end,

	mousefocus = function(self, f)
		if not f then
			self.seekbar_pressed = false
		end
	end,
}

return function(playback)
	osc.playback = playback

	return {
		playback = playback,
		draw = function(self, canvas)
			local windowWidth, windowHeight = love.window.getMode()

			osc.y = windowHeight - osc.height
			osc.width = windowWidth
			windowHeight = windowHeight - osc.height

			local sceneWidth = canvas:getWidth() 
			local sceneHeight = canvas:getHeight()
			local scale = math.min( windowWidth / sceneWidth, windowHeight / sceneHeight)
			local offsetX = (windowWidth - (sceneWidth * scale)) / 2
			local offsetY = (windowHeight - (sceneHeight * scale)) / 2

			love.graphics.reset()
			love.graphics.clear(0,0,0,1)
			love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)

			osc:draw()

			love.graphics.present()
		end,

		toggleFullscreen = function(self)
			_, _, flags = love.window.getMode()
			love.window.setFullscreen(not flags.fullscreen)
		end,

		keypressed = function(self,key,scancode,isrepeat)
			if key == "f" then
				self:toggleFullscreen()
			end
		end,

		mousepressed = function(self,x, y, button, istouch, presses )
			if y < osc.y then
				self.playback:toggle()
				return
			end

			osc:mousepressed(x,y,button,istouch,presses)
		end,

		mousereleased = function(self,x, y, button, istouch, presses )
			osc:mousereleased(x,y,button,istouch,presses)
		end,

		mousemoved = function(self,x, y, dx, dy, istouch )
			osc:mousemoved(x,y,dx,dy,istouch)
		end,

		mousefocus = function(self,f)
			osc:mousefocus(f)
		end,
	}
end
