local newScene = require("scene")
local easing = require("easing")
local colors = require("colors")

local scene = newScene {}

local rainbowColors = {
	colors.new {255,0,0,255},
	colors.new {255/255,127/255,0,255/255},
	colors.new {255,255,0,255},
	colors.new {0,255,0,255},
	colors.new {0,0,255,255},
	colors.new {139,0,255,255},
}

local squareWidth = scene.width / #rainbowColors
local duration = 875
local interval = 125

for i,c in ipairs(rainbowColors) do
	local r = scene:rectangle {
		x = squareWidth * (i-1),
		y = scene.height,
		width = squareWidth,
		height = 0,
		background = c,
		strokeWidth = 0,
	}

	r.y:to {
		duration = duration,
		easing = easing.out_cubic,
		value = 0,
	}
	r.height:to {
		duration = duration,
		easing = easing.out_cubic,
		value = scene.height,
	}

	scene:sleep(interval)
end

scene:waitAndSleep(500)

for i,r in ipairs(scene.objs) do
	r.height:to {
		duration = duration,
		easing = easing.out_cubic,
		value = 0,
	}

	scene:sleep(interval)
end

return scene
