-- https://forums.mudlet.org/viewtopic.php?t=3258
local function parseMilliseconds(milliseconds)
  local totalseconds = math.floor(milliseconds / 1000)
  milliseconds = milliseconds % 1000
  local seconds = totalseconds % 60
  local minutes = math.floor(totalseconds / 60)
  local hours = math.floor(minutes / 60)
  minutes = minutes % 60

	return { milliseconds = milliseconds, seconds = seconds, minutes = minutes, hours = hours }
end

local function toggleFullscreen()
	_, _, flags = love.window.getMode()
	love.window.setFullscreen(not flags.fullscreen)
end

local function mergeTable(t1,t2)
	for k,v in pairs(t2) do
		if t1[k] == nil then
			t1[k] = v
		end
	end
end

local function typeof(o)
	if type(o) != 'table' then
		return type(o)
	end

	if o.__type != nil then
		return o.__type
	end

	return "table"
end

local function clamp(l,v,u)
	v = math.max(l,v)
	v = math.min(v,u)
	return v
end

return {
	toggleFullscreen = toggleFullscreen,
	parseMilliseconds = parseMilliseconds,
	mergeTable = mergeTable,
	typeof = typeof,
	clamp = clamp,
}
