local module = {}
local ErrorService = require(script.Parent.ErrorService);

local function run(ClassName,t)
	local Class = (script.Parent.Parent.Parent.Pseudo.Core.Classes:FindFirstChild(ClassName,true));
	if(Class)then
		local c = require(Class);
		--local t = {}
		for prop,val in pairs(c) do
			if(typeof(val) ~= "function" and not prop:match("^_") and prop~="ClassName")then
				t[prop]=val;
			end
		end
		return t;
	else
		return ErrorService.tossWarn(ClassName.." is not a valid class. :GETCLASSPROPS(Class)");
	end
end
--//
function module:GETPROPSAS_STRING(Props)
	local x = {};
	for key,_ in pairs(Props) do
		table.insert(x,key);
	end;
	return x;
end;
--//
function module:GETCLASSPROPS(...)
	local x = {};
	for _,v in pairs({...}) do
		run(v,x)
		--table.insert(x, run(v));
	end;
	return x;
end;

return module
