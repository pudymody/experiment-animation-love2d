local newEventBus = require("events")
local newLoader = require("loader")
local loopWindow = require("loop.window")
local loopExportPNG = require("loop.export_png")

events = newEventBus()

function love.run()
	local args = love.arg.parseGameArguments(arg)

	local file = args[1]
	if file == nil or file == "" then
		local srcPath = love.filesystem.getSourceBaseDirectory()
		file = srcPath.."/default.lua"
	end

	local loader = newLoader(file, events)

	return loopWindow(loader)
end
