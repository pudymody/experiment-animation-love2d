local rectangle = require("objects.rectangle")
local point = require("objects.point")
local line = require("objects.line")
local circle = require("objects.circle")
local arc = require("objects.arc")
local ellipse = require("objects.ellipse")
local timeline = require("timeline")

local function mergeTable(t1,t2)
	for k,v in pairs(t2) do
		if t1[k] == nil then
			t1[k] = v
		end
	end
end

local scene = {
	width = 1920,
	height = 1080,
	fps = 60,
	background = {1,1,1,1},

	defaults = {
		line = {
			startPoint = { x = 0, y = 0 },
			endPoint = { x = 0, y = 0 },
			strokeWidth = 1,
			strokeColor = {0,0,0,1},
		},
		circle = {
			x = 0,
			y = 0,
			radius = 100,
			strokeWidth = 1,
			strokeColor = {0,0,0,1},
			background = {1,1,1,1},
		},
		arc = {
			x = 0,
			y = 0,
			radius = 100,
			startAngle = 0,
			endAngle = math.pi * 2,
			strokeWidth = 1,
			strokeColor = {0,0,0,1},
			background = {1,1,1,1},
		},
		ellipse = {
			x = 0,
			y = 0,
			radiusX = 100,
			radiusY = 50,
			rotation = 0,
			strokeWidth = 1,
			strokeColor = {0,0,0,1},
			background = {1,1,1,1},
		},
		point = {
			x = 0,
			y = 0,
		},
		rectangle = {
			x = 0,
			y = 0,
			width = 100,
			height = 50,
			rotation = 0,
			strokeWidth = 1,
			strokeColor = {0,0,0,1},
			background = {1,1,1,1},
		},
	},
}
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

function scene:circle(o)
	mergeTable(o, self.defaults.circle)

	if type(o.x) == "number" then
		o.x = timeline(o.x)
		o.x.context = self.context
	end

	if type(o.y) == "number" then
		o.y = timeline(o.y)
		o.y.context = self.context
	end

	if type(o.radius) == "number" then
		o.radius = timeline(o.radius)
		o.radius.context = self.context
	end

	if type(o.strokeWidth) == "number" then
		o.strokeWidth = timeline(o.strokeWidth)
		o.strokeWidth.context = self.context
	end

	local c = circle(o)
	self:add(c)
	return c
end

function scene:arc(o)
	mergeTable(o, self.defaults.arc)

	if type(o.x) == "number" then
		o.x = timeline(o.x)
		o.x.context = self.context
	end

	if type(o.y) == "number" then
		o.y = timeline(o.y)
		o.y.context = self.context
	end

	if type(o.radius) == "number" then
		o.radius = timeline(o.radius)
		o.radius.context = self.context
	end

	if type(o.startAngle) == "number" then
		o.startAngle = timeline(o.startAngle)
		o.startAngle.context = self.context
	end

	if type(o.endAngle) == "number" then
		o.endAngle = timeline(o.endAngle)
		o.endAngle.context = self.context
	end

	if type(o.strokeWidth) == "number" then
		o.strokeWidth = timeline(o.strokeWidth)
		o.strokeWidth.context = self.context
	end

	local a = arc(o)
	self:add(a)
	return a
end

function scene:ellipse(o)
	mergeTable(o, self.defaults.ellipse)

	if type(o.x) == "number" then
		o.x = timeline(o.x)
		o.x.context = self.context
	end

	if type(o.y) == "number" then
		o.y = timeline(o.y)
		o.y.context = self.context
	end

	if type(o.radiusX) == "number" then
		o.radiusX = timeline(o.radiusX)
		o.radiusX.context = self.context
	end

	if type(o.radiusY) == "number" then
		o.radiusY = timeline(o.radiusY)
		o.radiusY.context = self.context
	end

	if type(o.strokeWidth) == "number" then
		o.strokeWidth = timeline(o.strokeWidth)
		o.strokeWidth.context = self.context
	end

	if type(o.rotation) == "number" then
		o.rotation = timeline(o.rotation)
		o.rotation.context = self.context
	end

	local e = ellipse(o)
	self:add(e)
	return e
end

function scene:point(o)
	mergeTable(o, self.defaults.point)

	if type(o.x) == "number" then
		o.x = timeline(o.x)
		o.x.context = self.context
	end

	if type(o.y) == "number" then
		o.y = timeline(o.y)
		o.y.context = self.context
	end

	return point(o) 
end

function scene:line(o)
	mergeTable(o, self.defaults.line)

	if type(o.startPoint.x) == "number" then
		o.startPoint.x = timeline(o.startPoint.x)
		o.startPoint.x.context = self.context
	end
	if type(o.startPoint.y) == "number" then
		o.startPoint.y = timeline(o.startPoint.y)
		o.startPoint.y.context = self.context
	end
	if type(o.endPoint.x) == "number" then
		o.endPoint.x = timeline(o.endPoint.x)
		o.endPoint.x.context = self.context
	end
	if type(o.endPoint.y) == "number" then
		o.endPoint.y = timeline(o.endPoint.y)
		o.endPoint.y.context = self.context
	end
	if type(o.strokeWidth) == "number" then
		o.strokeWidth = timeline(o.strokeWidth)
		o.strokeWidth.context = self.context
	end
	
	local l = line(o)
	self:add(l)
	return l
end

function scene:rectangle(o)
	mergeTable(o, self.defaults.rectangle)

	if type(o.x) == "number" then
		o.x = timeline(o.x)
		o.x.context = self.context
	end

	if type(o.y) == "number" then
		o.y = timeline(o.y)
		o.y.context = self.context
	end

	if type(o.width) == "number" then
		o.width = timeline(o.width)
		o.width.context = self.context
	end

	if type(o.height) == "number" then
		o.height = timeline(o.height)
		o.height.context = self.context
	end

	if type(o.strokeWidth) == "number" then
		o.strokeWidth = timeline(o.strokeWidth)
		o.strokeWidth.context = self.context
	end

	if type(o.rotation) == "number" then
		o.rotation = timeline(o.rotation)
		o.rotation.context = self.context
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

	opts.objs = {}
	opts.context = newContext()
	setmetatable(opts, scene)

	return opts 
end
