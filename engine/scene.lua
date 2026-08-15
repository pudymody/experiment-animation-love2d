local rectangle = require("objects.rectangle")
local timeline = require("timeline")

local scene = {}
scene.__index = scene

function scene:draw(time)
	for k,v in ipairs(self.objs) do
		love.graphics.push()
		v:draw(time)
		love.graphics.pop()
	end
end

function scene:wait()
	self.context:wait()
end

function scene:sleep(d)
	self.context:sleep(d)
end

function scene:waitAndSleep(d)
	self.context:wait()
	self.context:sleep(d)
end

function scene:duration()
	return self.context.lastClipEnd
end

function scene:timeline(v)
	local o = timeline(v)
	o.context = self.context
	return o
end

function scene:add(o)
	table.insert(self.objs, o)
end

function scene:rectangle(o)
	if o.x == nil then
		o.x = 0
	end
	if type(o.x) == "number" then
		o.x = timeline(o.x)
		o.x.context = self.context
	end

	if o.y == nil then
		o.y = 0
	end
	if type(o.y) == "number" then
		o.y = timeline(o.y)
		o.y.context = self.context
	end

	if o.width == nil then
		o.width = 100
	end
	if type(o.width) == "number" then
		o.width = timeline(o.width)
		o.width.context = self.context
	end

	if o.height == nil then
		o.height = 100
	end
	if type(o.height) == "number" then
		o.height = timeline(o.height)
		o.height.context = self.context
	end

	if o.strokeWidth == nil then
		o.strokeWidth = 0
	end
	if type(o.strokeWidth) == "number" then
		o.strokeWidth = timeline(o.strokeWidth)
		o.strokeWidth.context = self.context
	end

	if o.rotation == nil then
		o.rotation = 0
	end
	if type(o.rotation) == "number" then
		o.rotation = timeline(o.rotation)
		o.rotation.context = self.context
	end

	if o.background == nil then
		o.background = {1,1,1,1}
	end
	if o.strokeColor == nil then
		o.strokeColor = {0,0,0,1}
	end

	local r = rectangle(o)
	self:add(r)
	return r
end

local function newContext()
	return {
		currentTime = 0,
		lastClipEnd = 0,

		add = function(self, f)
			self.lastClipEnd = math.max(self.lastClipEnd, f.start + f.duration)
		end,

		wait = function(self)
			self.currentTime = self.lastClipEnd
		end,

		sleep = function(self, duration)
			self.currentTime = self.currentTime + duration
		end,
	}
end

return function(opts)
	local o = {
		width = opts.width or 1920,
		height = opts.height or 1080,
		fps = opts.fps or 60,
		background = opts.background or {1,1,1,1},

		objs = {},
		context = newContext(),
	}
	setmetatable(o, scene)

	return o
end
