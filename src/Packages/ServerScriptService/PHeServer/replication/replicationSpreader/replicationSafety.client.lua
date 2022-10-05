--//
local function try()
	local PHeGui = script.Parent:FindFirstChild("PHeGui");
	return PHeGui and true or false;
end;

local p = false;
for i = 1,10 do
	local res = try();
	if(res)then
		p=true;
		break;
	end;

	wait(i/5);
end;

if(not p)then
	local callback = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine")):GetGlobal("Engine"):FetchStorageEvent("replicationSafetyCallback"):FireServer();
end;

script:Destroy();
