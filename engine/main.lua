local newEventBus = require("events")
local newLoader = require("loader")
local loopWindow = require("loop.window")

events = newEventBus()

function love.run()
	local args = love.arg.parseGameArguments(arg)

	local file = args[1]
	local loader, err = newLoader(file, events)
	if err ~= nil then
		print(err)
		return
	end

	if args[2] == nil then
		return loopWindow(loader)
	end

	if args[2] == "--export-png" then
		print("export png")
		return
	end
end
