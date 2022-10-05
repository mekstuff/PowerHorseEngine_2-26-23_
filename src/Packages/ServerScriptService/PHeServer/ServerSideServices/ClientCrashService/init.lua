return function (plr)
	if(plr and plr.Name and game.Players:FindFirstChild(plr.Name))then
		local c = script.crashReport:Clone();
		c.Parent = plr.PlayerGui;
	end
end