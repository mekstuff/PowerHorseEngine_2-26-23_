local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local CommandService = App:GetService("CommandService");
local Cmds = CommandService:GetCommands();

for _,v in pairs(script.cmds:GetChildren())do
	local req = require(v);
	req.__clientSided = true;
	table.insert(Cmds, req);
end;

return true;