local easing = require("easing")

local track = {
	frames = {},
	context = {
		currentTime = 0,
		add = function(self, f)
			self.currentTime = f.start + f.duration 
		end
	},

	__call = function(self, t)
		if #self.frames == 1 then
			return self.frames[1].value
		end

		local thisFrameIndex = 1 
		for i,v in ipairs(self.frames) do
			if v.start <= t then
				thisFrameIndex = i 
			end
		end

		-- we dont have a previous frame to interpolate
		if thisFrameIndex == 1 then
			return self.frames[1].value
		end

		local thisFrame = self.frames[thisFrameIndex]
		local thisFrameEnd = thisFrame.start + thisFrame.duration

		-- we are past the interpolation phase
		if thisFrameEnd < t then
			return thisFrame.value
		end

		-- interpolate
		local previousFrame = self.frames[thisFrameIndex - 1]
		local p = thisFrame.easing((t - thisFrame.start) / thisFrame.duration)

		return previousFrame.value + (thisFrame.value - previousFrame.value)*p
	end,

	add = function(self, o)
		if o.easing == nil then
			o.easing = easing.linear
		end
		table.insert(self.frames, o)
		self.context:add(o)
	end,

	to = function(self, o)
		local lastFrame = self.frames[ #self.frames ]
		o.start = math.max(lastFrame.start + lastFrame.duration, self.context.currentTime)
		self:add(o)
	end
}
track.__index = track

return function(val)
	local o = {
		frames = {
			{ start = 0, duration = 0, value = val }
		},
	}
	setmetatable(o, track)
	return o
end
