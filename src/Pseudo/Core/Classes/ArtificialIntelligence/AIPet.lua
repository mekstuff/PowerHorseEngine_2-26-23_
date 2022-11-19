local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local Player = game.Players.LocalPlayer;
local Character;local RootPart:any;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
Character = Player and (Player.Character or Player.CharacterAdded:Wait());
RootPart = Character and Character:WaitForChild("HumanoidRootPart");

local module = {
	Name = "AIPet";
	ClassName = "AIPet";
	IdleAnimation = "";
	WalkAnimation = "";
	RunAnimation = "";
	JumpAnimation = "";
	Skin = "**Instance";
	Health = 100;
	RenderDistance = 400;
	TargetRotation = Vector3.new(0);
	--FaceTarget = true;
	FaceDirection = Enumeration.FaceDirection.Relative;
};
module.__inherits = {"AI"};


local function tossWarnParentMessage(Parent,self,ErrorService)
	ErrorService.tossWarn(Parent.Name.." is not a valid AIHuman 'Adornee'. Try pareting "..self.Name.." to a model which contains a humanoid and a humanoidRootPart.");
end

function module:_DetermineIsValidAIHumanModel(Parent)
	local App = self:_GetAppModule();
	local ErrorService = App:GetService("ErrorService");
	
	if(Parent:IsA("Model"))then
		--local RootPart = Parent:FindFirstChild("HumanoidRootPart");
		--local Human = Parent:FindFirstChild("Humanoid");
		--if(not RootPart)then tossWarnParentMessage(Parent,self,ErrorService);return;end;
		--if(not Human)then tossWarnParentMessage(Parent,self,ErrorService);return;end;
		return true;
	else
			tossWarnParentMessage(Parent,self,ErrorService)
		return;
	end
end;
--//
function module:_WeldJoints()
	if(self.Skin:FindFirstChildWhichIsA("WeldConstraint",true) or self.Skin:FindFirstChildWhichIsA("Motor6D",true))then print("Not welding"); return end;
	local WeldService =  self:_GetAppModule():GetService("QuickWeldService");
	WeldService:AnchorAll(self._dev._targetSKIN);
	local JointConnections = WeldService:WeldAll(self._dev._targetSKIN);
	WeldService:UnAnchorAll(self._dev._targetSKIN);
end;

--//
function module:_GetBodyMovers():(BodyPosition,BodyGyro)
	--local p = self.Parent.PrimaryPart or self.Parent:FindFirstChildWhichIsA("BasePart");
	if not(self._dev._position)then
		local n = Instance.new("BodyPosition");
		n.Name = "Mover_Position";
		--n.Parent = p;
		self._dev._position = n;
	end;
	if not(self._dev._gyro)then
		local n = Instance.new("BodyGyro");
		n.Name = "Mover_Gyro";
		n.MaxTorque = Vector3.new(40000,40000,40000);
		--n.Parent = p;
		self._dev._gyro = n;
	end;
	return self._dev._position,self._dev._gyro;
end;
--//

function module:_Render(App)

	local Enumeration = App:GetGlobal("Enumeration");
	--<Server side
	if(not IsClient)then

		return {};
	end;
	--<Client side;

	
	local Container = workspace:FindFirstChild("AIPetContainer%PowerHorseEngine");
	if(not Container)then Container = Instance.new("Folder",workspace);Container.Name = "AIPetContainer%PowerHorseEngine";end;
	
	local RenderSteppedConnection;
	local PrevClone;
	
	local function RenderSteppedConnectionHandler()
		if(self.Target)then

			if( (RootPart.Position - self.Target.Position).Magnitude > self.RenderDistance)then
				
				if(self._dev._targetSKIN and self._dev._targetSKIN.Parent ~= ReplicatedStorage)then
					print("Not rendering");
					self._Rendering = false;
					self._dev._targetSKIN.Parent = ReplicatedStorage;
				end
			else
				if(self._dev._targetSKIN.Parent == ReplicatedStorage)then
					print("rendering");
					self._Rendering = true;
					self._dev._targetSKIN.Parent = Container;
				end
			end;
			
			local BodyPosition,BodyGyro = self:_GetBodyMovers();
			BodyPosition.Position = self:GetTargetPosition();
			BodyGyro.CFrame = CFrame.Angles(self.TargetRotation.X,self.TargetRotation.Y,self.TargetRotation.Z);
		end

	end;
	local function run()
		if(not RenderSteppedConnection)then
			RenderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(RenderSteppedConnectionHandler);
		end;
	end;
	local function stop()
		if(RenderSteppedConnection)then
			RenderSteppedConnection:Disconnect();RenderSteppedConnection=nil;
		end
	end;
	

	local function handleFaceTargetStep()
		if(self.Target)then
			
			if(self.FaceDirection == Enumeration.FaceDirection.Relative)then
				--local vec = self.Target.CFrame.LookVector;
				local x,y,z = self.Target.CFrame:ToEulerAnglesXYZ();
				--self.
				self.TargetRotation = Vector3.new(x,y,z);
			elseif(self.FaceDirection == Enumeration.FaceDirection.LookAt)then
				local CFx,CFy,CFz = CFrame.lookAt(self._dev._targetSKINROOT.Position,self.Target.Position):ToEulerAnglesXYZ();
				self.TargetRotation = Vector3.new(CFx,CFy,CFz);
			end
			--
		end
	end;
	local faceTargetStepConnection;
	
	return {
		["FaceDirection"] = function(v)
		
			if(v ~= Enumeration.FaceDirection.None)then
				if(not faceTargetStepConnection)then
					faceTargetStepConnection = game:GetService("RunService").RenderStepped:Connect(handleFaceTargetStep);
				end
			else
				if(faceTargetStepConnection)then
					faceTargetStepConnection:Disconnect();
					faceTargetStepConnection=nil;
					--self.TargetRotation = Vector3.new(0);
				end
			end
		end,
		["Skin"] = function(v)
			if(v)then
				
				local t;
				if(PrevClone)then 
					local Pos,Gyro = self:_GetBodyMovers();
					Pos.Parent= ReplicatedStorage;
					Gyro.Parent= ReplicatedStorage;
					PrevClone:Destroy();PrevClone=nil;
				end;
				local cloned = v:Clone();
				if(cloned:IsA("Model"))then
					
					t = cloned.PrimaryPart or cloned:FindFirstChildWhichIsA("BasePart");
				elseif(cloned:IsA("BasePart"))then
					t = cloned;
				end;
				local Pos,Gyro = self:_GetBodyMovers();
				cloned.Parent = Container;
				PrevClone=cloned;
				Pos.Parent = t;Gyro.Parent = t;
				self._dev._targetSKIN = cloned;
				self._dev._targetSKINROOT = t;
				self:_WeldJoints();
				--self.Parent = cloned;
				run();
			end
		end,
		["Target"] = function(v)
			if(v)then
				run();
			else
				stop();
			end
		end,
		--[[
	
		["Target"] = function(v)
			
			if(v)then
				if(not t)then
					t = v;
					self:WeldJoints();
				end
				run();
			end
		end,
		]]
	--[[
		["*Parent"] = function(Value)
			if(Value)then
				if(self:_DetermineIsValidAIHumanModel(Value))then
					run();		
				end
			end
		end,
	]]
		_Components = {};
		_Mapping = {};
	};
end;


return module
