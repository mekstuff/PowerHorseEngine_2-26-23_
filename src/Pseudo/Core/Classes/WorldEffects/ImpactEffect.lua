local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();


local ImpactEffect = {
	_REPLICATEDTOCLIENTS = false;
	Name = "ImpactEffect";
	ClassName = "ImpactEffect";
	
	Position = Vector3.new(0,0,0);
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new( 0, Color3.fromRGB(153, 102, 74)),
		ColorSequenceKeypoint.new( 1, Color3.fromRGB(195, 128, 94)),
	});
	ImpactDebrisTexture = "http://www.roblox.com/asset/?id=342731255";
	
	ImpactForce = 50;
	Emit = -1;
	Acceleration = -1;
	Speed = -1;
	SpreadAngle = -1;
	SmokeSize = -1;
	Size = 1;
	LifeTime = NumberRange.new(5);
	--Material = Enum.Material.Air;
};
ImpactEffect.__inherits = {}

--//
local function createDebrisParticle(App)
	local DebrisPart = Instance.new("Part");
	DebrisPart.Name = "ImpactEffect_Data";
	DebrisPart.Size = Vector3.new(1,1,1);
	DebrisPart.Anchored = true;
	DebrisPart.CanCollide = false;

	local FlyingDebrisParticle = Instance.new("ParticleEmitter");
	FlyingDebrisParticle.LightInfluence = 0;
	FlyingDebrisParticle.EmissionDirection = Enum.NormalId.Top;
	FlyingDebrisParticle.Enabled = false;

	FlyingDebrisParticle.Orientation = Enum.ParticleOrientation.FacingCamera;
	
	local Smoke = App.new("Smoke");
	Smoke.Enabled = false;
	Smoke.SpreadAngle = Vector2.new(90,90);
	
	Smoke.Parent = DebrisPart;
	FlyingDebrisParticle.Parent = DebrisPart;
	
	return {
		DebrisPart = DebrisPart;
		FlyingDebrisParticle = FlyingDebrisParticle;
		Smoke = Smoke;
	}
end;

--//
local MaterialForces = {}

function ImpactEffect:_Render(App)
	
	local Simulated;
	
	local function calcPhysics()
		local ImpactForceTogether = self.ImpactForce;
		--local val = (ImpactForceTogether+workspace.Gravity+(workspace.Gravity*.5));
		local SpreadAngle = self.SpreadAngle == -1 and math.min(ImpactForceTogether*2,45) or self.SpreadAngle;
		local val = ImpactForceTogether+30;
		local Speed = self.Speed == -1 and NumberRange.new(val,val) or NumberRange.new(self.Speed-5,self.Speed+5);
		local Acceleration = self.Acceleration == -1 and Vector3.new(0,-Speed.Min-100,0) or Vector3.new(0,self.Acceleration,0)
		local Emit = self.Emit == -1 and ImpactForceTogether/5 or self.Emit;
		local seq = {
			NumberSequenceKeypoint.new(0, self.Size); 
			NumberSequenceKeypoint.new(1, 0);
		};
		local Size = NumberSequence.new(seq)
		
		return {
			SpreadAngle = SpreadAngle;
			Acceleration = Acceleration;
			EmitCount = Emit;
			Speed = Speed;
			Size = Size;
			SmokeSize = self.SmokeSize == -1 and ImpactForceTogether/4 or self.SmokeSize;
		};
	end;
	--//
	local function Simulate() 
		local SimulationObjects = createDebrisParticle(App);
		local DebrisPart = SimulationObjects.DebrisPart;
		local FlyingDebrisParticle = SimulationObjects.FlyingDebrisParticle;
		local Smoke = SimulationObjects.Smoke;
		
		FlyingDebrisParticle.Lifetime = self.LifeTime;
		FlyingDebrisParticle.Texture = self.ImpactDebrisTexture;
		FlyingDebrisParticle.Color = self.Color;
		DebrisPart.Parent = workspace;
		DebrisPart.Position = self.Position;
	
		local results = calcPhysics();
	
		FlyingDebrisParticle.Size = results.Size;
		
		FlyingDebrisParticle.SpreadAngle = Vector2.new(results.SpreadAngle,results.SpreadAngle);
		FlyingDebrisParticle.Speed = results.Speed;
		FlyingDebrisParticle.Acceleration = results.Acceleration;
		
		Smoke.Size = results.SmokeSize;
		Smoke.Speed = results.SmokeSize;
		
		Smoke:Emit(results.EmitCount+math.random(3,5));
		FlyingDebrisParticle:Emit(results.EmitCount);
		
		
		delay(Smoke.Lifetime,function()
			DebrisPart:Destroy();
			SimulationObjects=nil;
		end)
	
		
	end
	
	return {
		["*Parent"] = function(Value)
			if(Value and not Simulated)then
				Simulated=true;
				Simulate();
			end
		end,
	}
	
end;


return ImpactEffect
