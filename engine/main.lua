local newEventBus = require("events")
local newLoader = require("loader")
local loopWindow = require("loop.window")
local loopExportPNG = require("loop.export_png")

events = newEventBus()

function love.run()
	local args = love.arg.parseGameArguments(arg)

	if #args < 2 then
		print("Available commands:")
		print("play file.lua")
		print("export-png file.lua")
		return
	end

	local file = args[2]
	local loader, err = newLoader(file, events)
	if err ~= nil then
		print(err)
		return
	end

	if args[1] == "play" then
		return loopWindow(loader)
	end

	if args[1] == "export-png" then
		return loopExportPNG(loader)
	end
end
