local std = require("std")
local colors = require("colors")

local rectangle = require("objects.rectangle")
local point = require("objects.point")
local line = require("objects.line")
local circle = require("objects.circle")
local arc = require("objects.arc")
local ellipse = require("objects.ellipse")
local polygon = require("objects.polygon")

local timeline = require("timeline")

local scene = {
	width = 1920,
	height = 1080,
	fps = 60,
	background = colors.white,

	defaults = {
		line = {
			startPoint = { x = 0, y = 0 },
			endPoint = { x = 0, y = 0 },
			strokeWidth = 1,
			strokeColor = colors.yin_dark,
		},
		circle = {
			x = 0,
			y = 0,
			radius = 100,
			strokeWidth = 1,
			strokeColor = colors.yin_dark,
			background = colors.white,
		},
		arc = {
			x = 0,
			y = 0,
			radius = 100,
			startAngle = 0,
			endAngle = math.pi * 2,
			strokeWidth = 1,
			strokeColor = colors.yin_dark,
			background = colors.white,
		},
		ellipse = {
			x = 0,
			y = 0,
			radiusX = 100,
			radiusY = 50,
			rotation = 0,
			strokeWidth = 1,
			strokeColor = colors.yin_dark,
			background = colors.white,
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
			strokeColor = colors.yin_dark,
			background = colors.white,
			origin = "",
		},
		polygon = {
			rotation = 0,
			strokeWidth = 1,
			strokeColor = colors.yin_dark,
			background = colors.white,
			origin = "",
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

function scene:timelineProps(o)
	for k,v in pairs(o) do
		local objType = std.typeof(o[k])
		if objType == "number" || objType == "color" then
			o[k] = self:timeline(o[k])
		end
	end
end

function scene:add(o)
	table.insert(self.objs, o)
end

function scene:circle(o)
	std.mergeTable(o, self.defaults.circle)
	self:timelineProps(o)

	local c = circle(o)
	self:add(c)
	return c
end

function scene:arc(o)
	std.mergeTable(o, self.defaults.arc)
	self:timelineProps(o)

	local a = arc(o)
	self:add(a)
	return a
end

function scene:ellipse(o)
	std.mergeTable(o, self.defaults.ellipse)
	self:timelineProps(o)

	local e = ellipse(o)
	self:add(e)
	return e
end

function scene:point(o)
	std.mergeTable(o, self.defaults.point)
	self:timelineProps(o)

	return point(o) 
end

function scene:line(o)
	std.mergeTable(o, self.defaults.line)
	self:timelineProps(o)

	-- TODO: Should it be a deep constructor?
	if std.typeof(o.startPoint.x) == "number" then
		o.startPoint.x = timeline(o.startPoint.x)
		o.startPoint.x.context = self.context
	end
	if std.typeof(o.startPoint.y) == "number" then
		o.startPoint.y = timeline(o.startPoint.y)
		o.startPoint.y.context = self.context
	end
	if std.typeof(o.endPoint.x) == "number" then
		o.endPoint.x = timeline(o.endPoint.x)
		o.endPoint.x.context = self.context
	end
	if std.typeof(o.endPoint.y) == "number" then
		o.endPoint.y = timeline(o.endPoint.y)
		o.endPoint.y.context = self.context
	end
	
	local l = line(o)
	self:add(l)
	return l
end

function scene:rectangle(o)
	std.mergeTable(o, self.defaults.rectangle)
	self:timelineProps(o)

	local r = rectangle(o)
	self:add(r)
	return r
end

function scene:polygon(o)
	std.mergeTable(o, self.defaults.polygon)
	self:timelineProps(o)

	local p = polygon(o)
	self:add(p)
	return p
end



function scene:frameStep()
	return 1000 / self.fps
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
