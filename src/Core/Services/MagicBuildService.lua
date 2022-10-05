local module = {}
local IsServer = game:GetService("RunService"):IsServer();

local TweenService = game:GetService("TweenService");

local Engine = require(script.Parent.Parent.Parent.Engine);
local MagicBuild_ExecuteBuild = Engine:FetchStorageEvent("MagicBuild_ExecuteBuild");

local SerializationService = require(script.Parent.SerializationService);

--//
local function storeBuild(model)
	local orgdata = {};
	for _,v in pairs(model:GetDescendants())do
		if(v:IsA("BasePart"))then
			table.insert(orgdata,{
				Position = v.Position;
				Size = v.Size;
				Transparency = v.Transparency;
				CFrame = v.CFrame;
				BrickColor = v.BrickColor;
				BasePart = v;
			});
			v.Size = Vector3.new(0);
			v.Transparency = 1;
		end;
		
		--v.Brick
	end;

	local serialized = SerializationService:SerializeTable(orgdata);
	local stored = Instance.new("StringValue",model);
	stored.Name = "%MagicBuildService-BuildLog%";
	stored.Value = serialized;
	orgdata=nil;
end
--//
local function executebuild(model,speed,delay_)
	speed = speed or 1;
	delay_ = delay_ or false;
	local data = model:FindFirstChild("%MagicBuildService-BuildLog%").Value;
	data = SerializationService:DeserializeTable(data);
	
	for _,x in pairs(data) do
		task.spawn(function()
			local t = TweenService:Create(x.BasePart,TweenInfo.new(speed), {
				Size = x.Size;
				Transparency = x.Transparency;
			})
			t:Play();
			if(delay_)then
				task.wait(delay_)
			end
		end);
	end

end

--//
function module.Build(...)
	executebuild(...)
end;
--//
function module.Clear(model)
	local data = model:FindFirstChild("%MagicBuildService-BuildLog%");
	if(data)then data:Destroy();end;
end

--//
function module.Store(...)
	storeBuild(...)
end


return module
