local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local ModuleFetcher = (PowerHorseEngine:GetProvider("ModuleFetcherProvider"));

local function getCBType(cb)
	if(cb:match("^%$"))then
		return "Function";
	end
end;

return function(cb,...)
	local cbType = getCBType(cb);
	local m = ModuleFetcher(cb:match("%w+"),script:FindFirstChild(cbType.."s"),"PHE failed to process cb: \""..cb.."\" of type: \""..cbType.."\"",true);
	return m(PowerHorseEngine,...);
	--[[
	if(cbType == "Function")then
		return m(PowerHorseEngine,...);
	elseif(cbType == "Reference")then
		return 
	end
	]]
end