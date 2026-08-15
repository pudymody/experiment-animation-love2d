local point = {
	x = function(time) return 0 end,
	y = function(time) return 0 end,
}
point.__index = point 

return function(opts)
	local o = opts or {}
	setmetatable(o, point)
	return o
end
