if(not game:GetService("RunService"):IsRunning())then
	script.Parent:Destroy();
	return;
end;

local sss = game:GetService("ServerScriptService");
local rs = game:GetService("ReplicatedStorage");

--> in the case that the force-env {game} flag was passed
if(script.Parent == sss)then
	task.wait(); --> Prevents module from being required recursively
	require(rs.PowerHorseEngine.Packages.PackageControllerModule):LaunchPackages(true);
	script:Destroy();
	return;
end;

if(script.Parent.Parent.Parent ~= sss)then
	script.Parent:Destroy() --> no need for packages to run, PowerHorseEngine is proabably being used by a external source or something
	return;
end;

--> If PHe is placed directly into ServerScriptService, then packages are automatically release
require(script.Parent.PackageControllerModule):LaunchPackages(true);

script.Parent:Destroy();