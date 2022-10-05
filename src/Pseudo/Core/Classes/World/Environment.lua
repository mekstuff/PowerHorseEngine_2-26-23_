local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local TweenService = game:GetService("TweenService");
local LightningTweenInfo_In = TweenInfo.new(.45);
local LightningTweenInfo_Out = TweenInfo.new(.45);
local function CreateLightningSegment()
	local Segment = Instance.new("Part");
	Segment.Name = "LightningSegment";
	Segment.Material = Enum.Material.Neon;
	Segment.BrickColor = BrickColor.new("Cyan");
	Segment.Anchored = true;
	Segment.CanCollide = false;
	Segment.Transparency = 1;


	Segment.Parent = workspace;
	return Segment;
end

--//

local StrikeRadius = 40;
local function createLightningStrike(OrgPos,Segments,TotalLength)
	local TargetPos = OrgPos;
	local SegmentSizeY = (TotalLength/Segments) ;
	local SegmentThickness = 1;


	local CreatedSegments = {};
	for i = 1,Segments do

		local LookAtVector = Vector3.new(TargetPos.X+math.random(-StrikeRadius,StrikeRadius),TargetPos.Y+SegmentSizeY, TargetPos.Z+math.random(-StrikeRadius,StrikeRadius))

		local newSegment = CreateLightningSegment();


		local distance = (TargetPos-LookAtVector).Magnitude;

		newSegment.Size = Vector3.new(SegmentThickness,SegmentThickness,distance);
		newSegment.CFrame = CFrame.new(TargetPos,LookAtVector)*CFrame.new(0,0,-distance/2);



		TargetPos = LookAtVector;
		
		game:GetService("Debris"):AddItem(newSegment,1);

		table.insert(CreatedSegments, newSegment);

	end;
local thread = coroutine.create(function()
	for i = #CreatedSegments,1,-1 do
		local Seg = CreatedSegments[i];
		local TransInTween = TweenService:Create(Seg, LightningTweenInfo_In, {Transparency = .25});
		TransInTween:Play();

		wait();
		end
	end);coroutine.resume(thread);

end;


local Environment = {
	Name = "Environment";
	ClassName = "Environment";
	Parent = game.Lighting;
	DayNightCycle = false;
	DayNightCycleRate = 5;
	GameTime = "0:00 AM";
	Raining = false;
	--Wind = true;
	--WindAffectsEnvironment = true;
	--WindSpeeds = Rect.new(0,0,0,0);
	--WindSpeedsDynamic = false;
	LightningStrike = Vector3.new(0,0,0);
	--BooleanValue = true;
};

function Environment:EnvironmentFunction()

	print("YES OMG YESSS")
end;

local EnvironmentExists = false;
local Player,Character,Humanoid,HumanoidRootPart,RainPartAbove;
Player = game:GetService("Players").LocalPlayer;
if(Player)then
	Character = Player.Character or Player.CharacterAdded:Wait();
	Humanoid = Character:WaitForChild("Humanoid");
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
end

local function createRainPart()
	if(Character)then
		local RainPart = Instance.new("Part");
		RainPart.Name = "EnvironmentRainPart";
		RainPart.Size = Vector3.new(30,.5,30);
		RainPart.Transparency = .5;
		RainPart.CanCollide = false;
		RainPart.Massless = true;
		RainPart.Anchored = true;
		RainPart.Position = workspace.CurrentCamera.CFrame.Position * Vector3.new(0,15,0);
		local Weld = Instance.new("WeldConstraint");
		Weld.Part0 = RainPart;
		Weld.Part1 = HumanoidRootPart;
		Weld.Parent = RainPart;
		RainPart.Anchored = false;
	
		
		
		local EnvironmentRainParticle = game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"):WaitForChild("Content"):WaitForChild("EnvironmentRainParticle"):Clone();
		
		EnvironmentRainParticle.Parent = RainPart;
		RainPart.Parent = Character;
		return RainPart,EnvironmentRainParticle;
	end
end

function Environment:_Render(App)
	

	
	local Lighting = game.Lighting;
	
	if(EnvironmentExists)then
		warn("Only a single environment can be added to a game.");
		return 
	end;EnvironmentExists=true;
	
	local function DayNightCyleEffect()
		Lighting.ClockTime+=(self.DayNightCycleRate*.001);
		local TimeType = Lighting.ClockTime <= 12 and "AM" or "PM";
		local s = Lighting.TimeOfDay:split(":")
		local h,m = tonumber(s[1])%12,(s[2]);
		local GameTimeValue = string.format("%d:%02d %s",h,m,TimeType)
		self.GameTime = GameTimeValue
	end;
	
	
	local DayNightCycleConnectionClient;
	local firstInitiated = true;
	

	
	local function handleRain(isRaining)
		if(not IsClient)then return end;
		
		if(isRaining)then
			if(not RainPartAbove)then
				RainPartAbove = createRainPart();
			end;
			RainPartAbove.EnvironmentRainParticle.Enabled = true;
		else
			if(RainPartAbove)then
				RainPartAbove.EnvironmentRainParticle.Enabled = false;
			end
		end
		
		
	end
	
	return {
		
		["Raining"] = function(isRaining)
			handleRain(isRaining);
		end,
		
		["LightningStrike"] = function(Vector)
			if(IsClient)then
				if(firstInitiated)then firstInitiated=false; return end;
				createLightningStrike(self.LightningStrike,7,600);
			end
		end,
		
		["DayNightCycle"] = function(Value)	
			if(not IsClient)then	
				if(Value == true)then
					if(not DayNightCycleConnectionClient)then DayNightCycleConnectionClient = game:GetService("RunService").Stepped:Connect(DayNightCyleEffect);end;
				else
					if(DayNightCycleConnectionClient)then
						DayNightCycleConnectionClient:Disconnect();
						DayNightCycleConnectionClient = nil;
					end
				end;
			end;

		end,
	};
	

end;


return Environment
