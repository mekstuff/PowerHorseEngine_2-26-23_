--!strict
--[=[
	@class AICharacterRIg
]=]
local Types = require(script.Parent.Parent.Parent.Parent.Parent.Types);

local AICharacterRig = {
	Name = "AICharacterRig",
	ClassName = "AICharacterRig",
	ShirtTemplate = "http://www.roblox.com/asset/?id=407513695",
	PantsTemplate = "http://www.roblox.com/asset/?id=608305444",
	WalkToPoint = Vector3.new(0),
	WalkToPart = "**Instance"
};
AICharacterRig.__inherits = {"BaseCharacterRig"};

--[=[
	@private
]=]

function AICharacterRig:_InitializeParent()
	local Character:Model = self.Parent;
	local Clothing = self:GetClothing();
	Clothing.Shirt.Parent = Character;
	Clothing.Pants.Parent = Character;
end;

--[=[
	@private
]=]
function AICharacterRig:_BreakdownParent()
	
end;

function AICharacterRig:_Render(App:Types.PHeApp)
	return function(Hooks:Types.PseudoHooks)
		local useEffect,useRender, useMapping = Hooks.useEffect,Hooks.useRender,Hooks.useMapping;
		useEffect(function()
			if(self.Parent)then
				self:_InitializeParent();
			else
				self:_BreakdownParent();
			end
		end, {"Parent"});
		useMapping({"ShirtTemplate"}, {self:GetClothing().Shirt});
		useMapping({"PantsTemplate"}, {self:GetClothing().Pants});
		useRender(function()
			local Humanoid:Humanoid = self:GetBaseHumanoid(self.Parent);
			Humanoid.WalkToPoint = self.WalkToPoint;
		end, {"WalkToPoint"});
		useRender(function()
			local Humanoid:Humanoid = self:GetBaseHumanoid(self.Parent);
			Humanoid.WalkToPart = self.WalkToPart;
		end, {"WalkToPart"});
	end;
end


return AICharacterRig;