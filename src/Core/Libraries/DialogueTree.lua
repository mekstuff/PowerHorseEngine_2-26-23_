local module = {};

local function fetchInitRoute(dialogue)
	return dialogue[1]
end;
local function fetchExitRoute(dialogue)
	return dialogue[#dialogue]
end

function module:executeDialogue(dialogue)
	local coreInformation = {
		initRoute=nil,
		exitRoute=nil,
	}
	coreInformation.initRoute = fetchInitRoute(dialogue);coreInformation.exitRoute = fetchExitRoute(dialogue)
	
	print()
end;

return module;