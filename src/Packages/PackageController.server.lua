if(not game:GetService("RunService"):IsRunning())then
	-- print("Packages are not supposed to unlaoded in plugin mode.");
	script.Parent:Destroy();
	return;
end;
local sss = game:GetService("ServerScriptService");
if(script.Parent.Parent.Parent ~= sss)then
	-- print("not releasing packages");
	script.Parent:Destroy() --> no need for packages to run, PowerHorseEngine is proabably being used by a external source or something
	return;
end;

local setBackCalls=0;
local maxSetBackCalls=10;

local function setBack()
	if(script.Parent.Parent.Parent ~= game:GetService("ReplicatedStorage"))then
		--pcall(function()
			script.Parent.Parent.Parent = game:GetService("ReplicatedStorage");
		--end);
		if(script.Parent.Parent.Parent ~= game:GetService("ReplicatedStorage"))then
			setBackCalls+=1;
			if(setBackCalls == maxSetBackCalls)then
				return error("PackageController couldn't properly import PowerHorseEngine. Please update PowerHorseEngine then restart the server.");
			end
			wait(setBackCalls/2)
			setBack();
		end
	end
end;


for _,Package in pairs(script.Parent:GetChildren())do
	if(Package:IsA("Folder") and Package.Name ~= "$Preloaders")then
		for _,x in pairs(Package:GetChildren())do
			x.Parent = game:FindFirstChild(Package.Name);
		end
	end
end;

task.wait(.1)
setBack();

script.Parent:Destroy();