local PackageControllerModule = {};



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

function PackageControllerModule:LaunchPackages(callSetBack:boolean)
    for _,Package in pairs(script.Parent:GetChildren())do
        if(Package:IsA("Folder") and Package.Name ~= "$Preloaders")then
            for _,x in pairs(Package:GetChildren())do
                x.Parent = game:FindFirstChild(Package.Name);
            end
        end
    end;
    if(callSetBack)then
        task.wait(.1)
        setBack();
    end;
end

return PackageControllerModule;