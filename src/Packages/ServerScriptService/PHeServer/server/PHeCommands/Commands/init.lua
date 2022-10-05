local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

local CMDS = {}
local function insetToCmds(p)
	for _,v in pairs(p:GetChildren())do if(v:IsA("ModuleScript"))then
			table.insert(CMDS,require(v));
		end;end;
end;
insetToCmds(script.cmds);

insetToCmds(App:GetGlobal("Engine"):RequestContentFolder().Config.CustomCMDS);
-- insetToCmds(game:GetService("ReplicatedStorage").PowerHorseEngine:WaitForChild("Content"):WaitForChild("Config").CustomCMDS)
return CMDS;
