local std = require("std")

local color = {
	0,
	0,
	0,
	0,

	__index = function(self, k)
		if k == "r" then
			return self[1] * 255
		end
		if k == "g" then
			return self[2] * 255
		end
		if k == "b" then
			return self[3] * 255
		end
		if k == "a" then
			return self[4] * 255
		end

		if k == "__type" then
			return "color"
		end

		return nil
	end,

	__newindex = function(self, k, v)
		if k == "r" then
			rawset(self,1 , v / 255)
			return
		end
		if k == "g" then
			rawset(self,2 , v / 255)
			return
		end
		if k == "b" then
			rawset(self,3 , v / 255)
			return
		end
		if k == "a" then
			rawset(self,4 , v / 255)
			return
		end
	end,
}

local function new(opt)
	local r,g,b,a = table.unpack(opt)
	local o = {
		r / 255,
		g / 255,
		b / 255,
		a / 255,
	}

	setmetatable(o, color)
	return o
end

color.__add = function(a,b)
	if std.typeof(a) != std.typeof(b) and std.typeof(a) != "color" then
		error(string.format("cant add %s with %s", std.typeof(a), std.typeof(b)))
	end

	local red = a.r + b.r
	local green = a.g + b.g
	local blue = a.b + b.b
	local alpha = a.a + b.a

	return new{red, green, blue, alpha}
end
color.__sub = function(a,b)
	if std.typeof(a) != std.typeof(b) and std.typeof(a) != "color" then
		error(string.format("cant sub %s with %s", std.typeof(a), std.typeof(b)))
	end

	local red = a.r - b.r
	local green = a.g - b.g
	local blue = a.b - b.b
	local alpha = a.a - b.a

	return new{red, green, blue, alpha}
end
color.__mul = function(a,b)
	local typeA = std.typeof(a)
	local typeB = std.typeof(b)

	if typeB == "color" and typeA == "number" then
		-- always deal with color*number
		return color.__mul(b,a)
	end

	if typeA != 'color' or typeB != "number" then
		error(string.format("cant mul %s with %s", std.typeof(a), std.typeof(b)))
	end

	local red = a.r*b
	local green = a.g*b
	local blue = a.b*b
	local alpha = a.a*b

	return new{red, green, blue, alpha}

end
-- https://uchu.style/
-- duck.ai to convert the src lch to lua rgb
return {
  blue = new{ 62, 66, 166, 255 },
  blue_light = new{ 76, 75, 210, 255 },
  blue_dark = new{ 63, 83, 145, 255 },

  gray = new{ 214, 211, 199, 255 },
  gray_light = new{ 225, 223, 232, 255 },
  gray_dark = new{ 166, 170, 184, 255 },

  green = new{ 76, 163, 118, 255 },
  green_light = new{ 90, 215, 148, 255 },
  green_dark = new{ 76, 137, 103, 255 },

  orange = new{ 175, 108, 57, 255 },
  orange_light = new{ 212, 150, 84, 255 },
  orange_dark = new{ 148, 92, 43, 255 },

  pink = new{ 182, 90, 160, 255 },
  pink_light = new{ 214, 100, 179, 255 },
  pink_dark = new{ 131, 79, 123, 255 },

  purple = new{ 105, 64, 168, 255 },
  purple_light = new{ 162, 95, 211, 255 },
  purple_dark = new{ 78, 43, 122, 255 },

  red = new{ 158, 50, 33, 255 },
  red_light = new{ 205, 78, 62, 255 },
  red_dark = new{ 122, 49, 32, 255 },

  yellow = new{ 236, 189, 92, 255 },
  yellow_light = new{ 239, 196, 93, 255 },
  yellow_dark = new{ 191, 155, 72, 255 },

  yin = new{ 99, 87, 153, 255 },
  yin_light = new{ 137, 109, 201, 255 },
  yin_dark = new{ 66, 59, 96, 255 },

	white = new {255,255,255,255},
	black = new {0,0,0,255},
	transparent = new {0,0,0,0},

	new = new,
}
