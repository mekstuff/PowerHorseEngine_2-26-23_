local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Smoke = {
	_REPLICATEDTOCLIENTS = false;
	Name = "Smoke";
	ClassName = "Smoke";
	Texture = "rbxasset://textures/particles/smoke_main.dds";
	
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0,0);
		NumberSequenceKeypoint.new(1,0);
	});
	Brightness = 1;
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.fromRGB(99, 99, 99)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(235, 235, 235))	
	});
	Size = 5;
	--Size = NumberSequence.new({
	--	NumberSequenceKeypoint.new(0,1.6);
	--	NumberSequenceKeypoint.new(.2,2);
	--	NumberSequenceKeypoint.new(.5,3);
	--	NumberSequenceKeypoint.new(1,5);
	--});
	Enabled = true;
	Lifetime = 5;
	Rate = 100;
	Rotation = NumberRange.new(0,0);
	RotSpeed = NumberRange.new(0,0);
	Speed = 5;
	SpreadAngle = Vector2.new(10,10);
	Shape = Enum.ParticleEmitterShape.Box;
	ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward;
	ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume;
	Acceleration = Vector3.new(0,1,0);
};
Smoke.__inherits = {}

--//
function Smoke:Emit(x)
	local Particle = self:GET("Particle");
	Particle:Emit(x);
end;
--//
function Smoke:_Render(App)
	
	local Particle = Instance.new("ParticleEmitter");
	
	return {
		["Speed"] = function(Value)
			if(typeof(Value) == "number")then
				Particle.Lifetime = NumberRange.new(Value,Value);
			else
				Particle.Lifetime = Value;
			end
		end,
		["Lifetime"] = function(Value)
			if(typeof(Value) == "number")then
				Particle.Lifetime = NumberRange.new(Value,Value);
			else
				Particle.Lifetime = Value;
			end
		end,
		["Size"] = function(Value)
			if(typeof(Value) == "number")then
				Particle.Size = NumberSequence.new({
					NumberSequenceKeypoint.new(0,Value*.25);
					NumberSequenceKeypoint.new(.2,Value*.5);
					NumberSequenceKeypoint.new(.5,Value*.75);
					NumberSequenceKeypoint.new(1,Value);
				});
			else
				Particle.Size = Value;
			end
		end,
		_Components = {
			Particle = Particle;	
		};
		_Mapping = {
			[Particle] = {
				"Texture";"Transparency";"Brightness";"Color";"Enabled";
				"Rate";"Rotation";"RotSpeed";"SpreadAngle";"Shape";
				"ShapeInOut";"ShapeStyle";"Acceleration","Parent";
			}	
		};
	};
end;


return Smoke
