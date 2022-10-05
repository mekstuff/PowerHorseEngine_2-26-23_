local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local Camera = workspace.CurrentCamera;
local TweenService = game:GetService("TweenService");

local module = {
	Name = "CharacterRig";
	ClassName = "CharacterRig";

	WalkAnimation = "";
	RunAnimation = "";
	JumpAnimation = "";

	Shirt = "";
	Pants = "";

	WalkSpeed = 16;
	JumpPower = 50;
	
	Sprinting = false;
	SprintSpeed = 20;
	
	--Walking = false;
	--WalkSpeed = 10;
	
	WalkTo = Vector3.new(0);
	Focus = "**Instance";

};
module.__inherits = {}

function module:Sprint()
	if(IsClient)then
		if(not self._dev.orgfovcam)then
			self._dev.orgfovcam = Camera.FieldOfView;
		end
		local tinfo = TweenInfo.new(1);
		local t1 = TweenService:Create(Camera, tinfo, {FieldOfView = math.clamp(self._dev.orgfovcam+30,70,100)});
		local t2 = TweenService:Create(self._Human, tinfo, {WalkSpeed = self.SprintSpeed});
		t1:Play();t2:Play();
	end;
end;

function module:StopSprint()
	if(not self._Human)then return end;
	local tinfo = TweenInfo.new(1);
	local t1 = TweenService:Create(Camera, tinfo, {FieldOfView = self._dev.orgfovcam or 70});
	local t2 = TweenService:Create(self._Human, tinfo, {WalkSpeed = self.WalkSpeed});
	t1:Play();t2:Play();
end

function module:GetIsCharacter()
	local Humanoid = self:GetBodyParts();
	if(Humanoid)then
		return Humanoid.Parent;
	end
end

function module:GetBodyParts()
	local Model = self.Parent:IsA("Model") and self.Parent or self.Parent.Parent;
	
	local Human = Model:FindFirstChildWhichIsA("Humanoid");
	local RootPart = Model:FindFirstChild("HumanoidRootPart");
	
	self._Human = Human;
	self._Root = RootPart;
	self._Character = Human.Parent;
	
	return self._Human;
end

function module:AddAccessory(Accessory,SpecialId)
	local ErrorService = self:_GetAppModule():GetService("ErrorService");
	local Model;
	
	if(typeof(Accessory) == "number")then
		if(IsClient)then
			ErrorService.tossError("AddAccessory cannot import catalog models from the client, You must import the model from the server and use AddAccessory(Model).")
		else
			local ran, ModelImport =
				pcall(function()
					return game:GetService("InsertService"):LoadAsset(Accessory)
				end);
			if(not ran)then
				ErrorService.tossWarn("AddAccessory Failed : "..ModelImport);
			return;
			end;
			Model = ModelImport:GetChildren()[1];
			Model.Parent = game.ReplicatedStorage;
			ModelImport:Destroy();
		end;
	elseif(typeof(Accessory) == "Instance")then
		Model = Accessory;
	end;
	
	
	Model.Parent = self._Character;
	
end;

function module:WalkToCoordinate(Coordinates,Force)
	self._Human:MoveTo(Coordinates)
	if(Force)then
		local WalkToReached=false;
		self._dev.MoveToConnection = self._Human.MoveToFinished:Connect(function(state)
			if(state)then
				self._dev.MoveToConnection:Disconnect();
				self._dev.MoveToConnection = nil;
				WalkToReached=true;
			end
		end);
		spawn(function()
			while not WalkToReached do
				if(not self or not self._dev or not self._Human)then break;end;
				if(self._Human.WalkToPoint ~= Coordinates)then
					break;
				end
				self._Human:MoveTo(Coordinates);
			end
		end)
	end
end

function module:RemoveAccessory()
	
end;

function module:_Render(App)
	
	--if(not IsClient)then
	local init;
	
	return {
		["*Parent"] = function(Value)
			local Character = self:GetIsCharacter();
			if(Character)then
				local Shirt,Pants = Character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt",Character),Character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants",Character);

				self._Parts = {};
				self._Parts.Shirt = Shirt;
				self._Parts.Pants = Pants;

				Shirt.ShirtTemplate = self.Shirt;
				Pants.PantsTemplate = self.Pants;

			end;	
		end,
		["Focus"] = function(v)
			if(IsClient)then
				if(v)then
					local Character = self:GetIsCharacter();
					local Neck = Character:FindFirstChild("Head"):FindFirstChild("Neck");
					if not(self._originalNeckC0)then
						self._originalNeckC0 = Neck.C0;
					end;
					if(not self._dev.RigFocusStep)then
						self._dev.RigFocusStep = game:GetService("RunService").RenderStepped:Connect(function()
							
							--[[
							local dir = (nearest.Head.Position - script.Parent.Position).unit
							local spawnPos = script.Parent.Position
							local pos = spawnPos + (dir * 1)
							script.Parent:findFirstChild("BodyGyro").cframe = CFrame.new(pos,  pos + dir)
							]]
							
							local dir = (self._originalNeckC0.Position - v.Position).Unit;
							local pos = self._originalNeckC0.Position + (dir * 1);
							
							local C0 = CFrame.lookAt(pos, pos+dir);
							--print(C0)
							Neck.C0 = C0;
						end)
					end
				else
					if(self._originalNeckC0)then
						local Character = self:GetIsCharacter();
						local Neck = Character:FindFirstChild("Head"):FindFirstChild("Neck");
						Neck.C0 = self._originalNeckC0;
					end
				end
			end;
		end,
		["Shirt"] = function(v)
			if(self._Parts)then
				self._Parts.Shirt.ShirtTemplate = v;
			end
		end,
		["Pants"] = function(v)
			if(self._Parts)then
				self._Parts.Pants.PantsTemplate = v;
			end
		end,
		["WalkTo"] = function(v)
			if(init)then
				self:WalkToCoordinate(v);
			else
				init=true;
			end;
		end,
		["Sprinting"] = function(v)
			if(v)then
				self:Sprint();
			else
				self:StopSprint();
			end;
			
		end,
		_Components = {};
		_Mapping = {};
		};
		--else return {};
	--end
end;


return module
