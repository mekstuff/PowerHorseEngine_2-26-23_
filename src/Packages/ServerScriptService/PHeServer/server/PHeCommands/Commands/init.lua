local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

local CMDS = {}
local function insertToCmds(p)
	for _,v in pairs(p:GetChildren())do if(v:IsA("ModuleScript"))then
			table.insert(CMDS,require(v));
		end;end;
end;
insertToCmds(script.cmds);

local Config = App:GetGlobal("Engine"):RequestContentFolder():FindFirstChild("Config");
if(Config)then
	local CustomCMDS = Config:FindFirstChild("CustomCMDS");
	if(CustomCMDS)then
		insertToCmds(CustomCMDS);
	end
end

return CMDS;
