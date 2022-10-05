local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local Player = game:GetService("Players").LocalPlayer;
local IsClient = game:GetService("RunService"):IsClient();
local Character = Player and Player.Character or Player.CharacterAdded:Wait();
local RootPart = Character and Character:WaitForChild("HumanoidRootPart");

local ProximityReader = {
	Name = "ProximityReader";
	ClassName = "ProximityReader";
	Adornee = "**Instance";
	Enabled = true;
	Magnitude = 30;
	Activated = false;
	DominantAxis = "Magnitude";
};
ProximityReader.__inherits = {"AdorneeObject"}


function ProximityReader:_Render(App)
	
	local RenderStepped = function()
		local Adornee = self:GetAdornee(self.Adornee);
		if(Adornee)then
			local Difference = (Adornee.Position - RootPart.Position).Magnitude;
		--print(Difference)
			if(Difference > self.Magnitude)then
				if(self.Activated)then
					--print("Activated = false")
					self.Activated=false;
				end
				
			else
				if(not self.Activated)then
					--print("Activated = true")
					self.Activated=true;
				end

			end
		end;
	end;
	

	
	return {
		["Enabled"] = function(Value)
			if(Value)then
				if(not self._dev.ProximityConnector)then
					self._dev.ProximityConnector = game:GetService("RunService").RenderStepped:Connect(function()
						RenderStepped();
					end)
				end
			else
				if(self._dev.ProximityConnector)then
					self._dev.ProximityConnector:Disconnect();
					self._dev.ProximityConnector = nil;
					self.Activated = false;
				end
			end
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return ProximityReader
