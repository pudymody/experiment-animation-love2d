local newScene = require("scene")
local easing = require("easing")

local scene = newScene {
	width = 1920,
	height = 1080,
	fps = 60,
	background = {1,1,1,1},
}

local colors = {
	{255,0,0,255},
	{255/255,127/255,0,255/255},
	{255,255,0,255},
	{0,255,0,255},
	{0,0,255,255},
	{139,0,255,255},
}

local squareWidth = scene.width / #colors
local duration = 0.875
local interval = 0.125

for i,c in ipairs(colors) do
	local r = scene:rectangle {
		x = squareWidth * (i-1),
		y = scene.height,
		width = squareWidth,
		height = 0,
		background = c
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

scene:waitAndSleep(0.5)

for i,r in ipairs(scene.objs) do
	r.height:to {
		duration = duration,
		easing = easing.out_cubic,
		value = 0,
	}

	scene:sleep(interval)
end

return scene
