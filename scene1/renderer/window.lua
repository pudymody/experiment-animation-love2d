return function()
	return {
		windowFlags = {
			fullscreen = false,
			resizable = true,
		},

		draw = function(self, canvas)
			local windowWidth, windowHeight = love.window.getMode()
			local sceneWidth = canvas:getWidth() 
			local sceneHeight = canvas:getHeight()
			local scale = math.min( windowWidth / sceneWidth, windowHeight / sceneHeight)
			local offsetX = (windowWidth - (sceneWidth * scale)) / 2
			local offsetY = (windowHeight - (sceneHeight * scale)) / 2

			love.graphics.reset()
			love.graphics.clear(0,0,0,1)
			love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)

			love.graphics.present()
		end,

		load = function(self, scene)
			love.window.setMode(scene.width, scene.height, self.windowFlags)
		end,

		keypressed = function(self,key,scancode,isrepeat)
			if key == "f" then
				_, _, flags = love.window.getMode()
				love.window.setFullscreen(not flags.fullscreen)
			end
		end,
	}
end
