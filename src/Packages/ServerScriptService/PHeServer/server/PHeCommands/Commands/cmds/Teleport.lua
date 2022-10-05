--local consts = require(script.Parent.Parent.Constants)

return {
	cmd = "Teleport";
	desc = "Teleports Player A to Player B";
	req = "Admin";
	args = {
		{var="Player A",type="player",req=true,desc="Player To Be Teleported",default=nil};
		{var="Point A",type="player,vector3",req=true,desc="",default=nil};
	};
	exe = function(Player1, Player2)
		local P1Character = Player1.Character or Player1.CharacterAdded:Wait();
		local tVector;
		if(typeof(Player2) == "Vector3")then
			tVector = Player2;
		else
			local P2Character = Player2.Character or Player2.CharacterAdded:Wait()
			tVector = P2Character.HumanoidRootPart.Position+Vector3.new(0,10,0)
		end
		--local P1Character,P2Character = Player1.Character or Player1.CharacterAdded:Wait(),Player2.Character or Player2.CharacterAdded:Wait();
		P1Character:MoveTo(tVector);
		
	end,
}