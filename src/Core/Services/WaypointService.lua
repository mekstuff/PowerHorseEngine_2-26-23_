local Player = game.Players.LocalPlayer;
if(not Player)then 
	require(script.Parent.ErrorService).tossError("WaypointService can only be used by the client.");
end;

local Character = Player.Character or Player.CharacterAdded:Wait();
local HumanRP = Character:WaitForChild("HumanoidRootPart");
local CustomClassService = require(script.Parent.CustomClassService);

local module = {}

local WaypointClass = {
	Name = "Waypoint";
	ClassName = "Waypoint";
	ShowOnMap = false;
	ShowScreenIndicator = false;
	ShowDirectionalArrow = true;
	WaypointInfo = "";
};

function WaypointClass:_Render()
	local App = self:_GetAppModule();
	local CoreGuiService = App:GetService("CoreGuiService");

	local DirectionalArrow;
	
	local WaypointReached = self:AddEventListener("WaypointReached",true);
	local FiringWaypointReached = false;
	
	local Direction = self._dev.args.Direction;
	
	return{
		["WaypointInfo"] = function(v)
			if(v ~= "")then
				local CoreSubtitle = CoreGuiService:WaitFor("Subtitle");
				local sub = CoreSubtitle:new(v,nil,nil,App:GetGlobal("Enumeration").NotificationPriority.High);
				self._dev._subtitle = sub;
				
			end
		end,
		["ShowDirectionalArrow"] = function(v)
			if(v)then
				if(not DirectionalArrow)then
					DirectionalArrow = App:Import("DirectionalArrow3D").new(HumanRP,Direction);
					DirectionalArrow.Parent = self:GetRef();
					self._dev._MagnitudeConnection = DirectionalArrow:GetPropertyChangedSignal("Magnitude"):Connect(function()
						if(DirectionalArrow.Magnitude <= 5)then
							if(not FiringWaypointReached)then
								FiringWaypointReached = true;
								WaypointReached:Fire(DirectionalArrow.Magnitude);
								task.wait(1);
								FiringWaypointReached = false;
							end
						end
					end)
					self._dev._directionalArrow = DirectionalArrow;
				end;
				DirectionalArrow.Enabled = true;
			else
				if(DirectionalArrow)then DirectionalArrow.Enabled=false;end;
			end
		end,
		
	};
end

function module:CreateWaypoint(Direction,WaypointInfo)
	local Waypoint = CustomClassService:CreateClassAsync(WaypointClass,nil,{Direction = Direction});
	Waypoint.WaypointInfo = WaypointInfo;
	return Waypoint;
end;

return module