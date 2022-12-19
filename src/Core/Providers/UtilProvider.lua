--[=[
	@class UtilProvider
	@tag Provider
	Provides Utilities
]=]

local UtilProvider = {}

--[=[
	Loads the util
	@private
	@return UtilProvider
]=]
function UtilProvider.LoadUtil(UtilName:string)
	
	local targetUtil = script.Parent.Parent.Parent.Util:FindFirstChild(UtilName);
	--[[
	if(targetUtil)then
		return require(targetUtil);
	else
		local pLib = (script.Parent.Parent.Parent.Content.Config.Libraries);
		local x = pLib:FindFirstChild(UtilName);
		if(x and x:IsA("ModuleScript"))then
			 return require(x);
		end
		return ErrorService.tossError("\""..UtilName.."\" is not a valid util name");
	end
	]]
end

return UtilProvider
