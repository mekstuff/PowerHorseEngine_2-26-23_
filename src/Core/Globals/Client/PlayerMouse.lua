local Class = {
	Name = "ClientMouse";
	ClassName = "ClientMouse";
	Busy = false;
};

function Class:_Render()
	
	local App = self:_GetAppModule();
	local Indicator;
	
	return {
		["Parent"]=function()end;
		["Busy"] = function(v)
			if(v)then
				if(not Indicator)then
					Indicator = App.new("ProgressIndicator");
					Indicator.Color = Color3.fromRGB(255, 255, 255);
					Indicator.CycleSpeed = .75;
					
					Indicator.Parent = game.Players.LocalPlayer:GetMouse();
				else
					Indicator.Enabled = true;
				end
			else
				if(Indicator)then
					Indicator.Enabled = false;
				end
			end;
		end,
	}
end

return Class;
