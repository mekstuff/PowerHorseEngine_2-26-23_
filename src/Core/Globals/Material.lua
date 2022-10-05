local MaterialService = require(script.Parent.Parent.Services:WaitForChild("MaterialService"));
local module = {}

function module.new(...)
	return MaterialService.new(...);
end

return module
