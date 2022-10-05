local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();


local module = {
	Name = "AICharacterRig";
	ClassName = "AICharacterRig";

	--WalkAnimation = "";
	--RunAnimation = "";
	--JumpAnimation = "";

	Shirt = "";
	Pants = "";
	
	WalkTo = Vector3.new(0);
	Focus = "**Instance";


};
module.__inherits = {};

function module:AddAccessory(...)
	return self:GET("CharacterRig"):AddAccessory(...);
end

function module:_Render(App)
	
--if(not IsClient)then
	local CharacterRig = App.new("CharacterRig");
		--[[
	local AnimScript;
	if(not IsClient)then
		local AnimateScript = script.AnimateServer:Clone();
		AnimScript = AnimateScript;
		AnimScript.Name = "Animate";
	end;
	]]
	
	return {
	
		["*Parent"] = function(Value)
			CharacterRig.Parent = Value;
			--[[
			if(AnimScript)then
				AnimScript.Parent = Value;
			end;
			]]
		end,
	
		_Components = {
			CharacterRig = CharacterRig;	
		};
		_Mapping = {
			[CharacterRig] = {
				"Shirt","Pants","WalkTo","Focus"
			}
		};
		};
	--else return {}
	--end;
end;


return module
