local CoreEngine = script.Parent.Parent.Parent;
local CoreServices = CoreEngine.Services;
local ErrorService = require(CoreServices.ErrorService);

local moduleCache = {};


local function fetch(mod,search,catch,recursive)
	if(moduleCache[search.Name])then
		if(moduleCache[search.Name][mod])then return moduleCache[search.Name][mod];end;
	end;
	local module = search:FindFirstChild(mod,recursive)
	if(not module)then
		return;
	else
		local n = require(module); 
		if(not moduleCache[search.Name])then moduleCache[search.Name]={};end;
		moduleCache[search.Name][mod] = n;
		return n;
	end
end

--[=[
	@class ModuleFetcher
	@tag Provider
	@private
	A Constant Provider used to organize fetching Core Modules
]=]

return function(mod,search,catch,recursive,...)
	local s = fetch(mod,search,catch,recursive);
	if(not s)then
		local more = {...}
		if(#more > 0)then
			for _,v in pairs(more)do
				local f = fetch(mod,v);
				if(f)then return f; end;
			end
		end
	else
		return s;
	end;
	--ErrorService.tossError(catch or "something went wrong when fetching module \""..tostring(mod).."\"");
end
