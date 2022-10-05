--local consts = require(script.Parent.Parent.Constants)

return {
	cmd = "Set";
	desc = "Description";
	req = "Admin";
	args = {
		{var="Player",type="player",req=true,desc="",default=nil};
		{var="Humanoid Property",type="string",req=true,desc="",default=nil};
		{var="Value",type="number",req=true,desc="",default=nil};
	};
	exe = function(Player,Property,Value)
		local Character = Player.Character or Player.CharacterAdded:Wait();
		local Humanoid = Character:WaitForChild("Humanoid");
		Humanoid[Property]=Value;
	end,
}