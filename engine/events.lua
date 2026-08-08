return function()
	return {
		handlers = {},

		on = function(self, event, fn)
			if self.handlers[event] == nil then
				self.handlers[event] = {}
			end

			table.insert(self.handlers[event], fn)
		end,

		dispatch = function(self, event, data)
			if self.handlers[event] == nil then
				return
			end

			for _,fn in ipairs(self.handlers[event]) do
				fn(data)
			end
		end,
	}
end
