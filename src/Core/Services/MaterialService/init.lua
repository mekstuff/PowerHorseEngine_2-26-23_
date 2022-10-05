local module = {}
local ClassCache = {};
local ErrorService = require(script.Parent.ErrorService);
local CustomClassService = require(script.Parent.CustomClassService);

function module.new(Class,...)
	if(ClassCache[Class])then return ClassCache[Class].new(CustomClassService,...);end;
	local search = script:FindFirstChild(Class,true);
	if(search)then
		ClassCache[Class]=require(search);
		return ClassCache[Class].new(CustomClassService,...);
	else
		ErrorService.tossWarn(Class.." is not a valid MaterialService Class.");
	end;
	
end;

return module
