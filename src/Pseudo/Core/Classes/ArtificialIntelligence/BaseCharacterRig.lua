--[=[
	@class BaseCharacterRig
]=]
local Types = require(script.Parent.Parent.Parent.Parent.Parent.Types);

local BaseCharacterRig = {
    __PseudoBlocked = true;
};

local n = {
    Shirt = function()
        return Instance.new("Shirt")
    end;
    Pants = function()
        return Instance.new("Pants")
    end;
}

--[=[]=]
function BaseCharacterRig:GetClothing():{}
    self._Clothing = self._Clothing or {};
    local Clothing = self._Clothing
    for name:string,handler:()->(Shirt,Pants) in pairs(n) do
        if(not Clothing[name])then
            Clothing[name] = handler();
        end
    end;
    return self._Clothing;
end;

function BaseCharacterRig:GetCharacterInRadius(Radius:number?)
    return {
        workspace:WaitForChild("DemoCharacter");
        -- workspace:WaitForChild("MightTea");
    };
end;

--[=[]=]
function BaseCharacterRig:GetBaseHumanoid(Target:Instance|Types.Pseudo)
    local Humanoid = Target:FindFirstChild("Humanoid");
    return Humanoid;
end;

--[=[]=]
function BaseCharacterRig:DestroyClothing()
    if(self._Clothing)then
        for _,x in pairs(self._Clothing) do
            x:Destroy();
        end
    end;
    self._Clothing = nil;
end;

return BaseCharacterRig