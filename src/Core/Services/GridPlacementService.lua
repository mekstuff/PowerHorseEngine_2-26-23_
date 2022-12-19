--[=[
	@class GridPlacementService
]=]
local GridPlacementService = {}

local UIS = game:GetService("UserInputService");
local CustomClassService = require(script.Parent.CustomClassService);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local UISInputChangedListener;

local incY = 36;
if(game:GetService("RunService"):IsRunning())then
	incY = 0;
end

--[=[
	@class GridPlacement
]=]
local GridPlacement = {
	Name = "GridPlacement";
	ClassName = "GridPlacement";
	RaycastParams = RaycastParams.new();
	UnitLength = 300;
	Results = "**table";
	AutomaticPlacement = true;
	AutomaticRotation = true;
	RotationKeyCode = Enumeration.KeyCode.R;
	ShowBoundingBox = true;
	GridCellSize = 0;
	Angle = 0;
};

--[=[
	@prop RaycastParams RaycastParams
	@within GridPlacement
]=]
--[=[
	@prop UnitLength number
	@within GridPlacement
]=]
--[=[
	@prop AutomaticPlacement boolean
	@within GridPlacement
]=]
--[=[
	@prop AutomaticRotation boolean
	@within GridPlacement
]=]
--[=[
	@prop ShowBoundingBox boolean
	@within GridPlacement
]=]
--[=[
	@prop GridCellSize number
	@within GridPlacement
]=]
--[=[
	@prop Angle number
	@within GridPlacement
]=]

local function getMouseInput(Position,self)
	local Cam = workspace.CurrentCamera;
	local x = Position.X
	local y = Position.Y;

	local u = Cam:ViewportPointToRay(x,y+incY);
	
	
	local rayCastResults = workspace:Raycast(u.Origin,u.Direction*self.UnitLength,self.RaycastParams);
	local calculatedPosition;
	
	if(rayCastResults)then
		if(self.GridCellSize ~= 0)then	
			local targetX = math.floor(rayCastResults.Position.X/self.GridCellSize+.5)*self.GridCellSize;
			local targetZ = math.floor(rayCastResults.Position.Z/self.GridCellSize+.5)*self.GridCellSize;
		
			calculatedPosition = Vector3.new(targetX,rayCastResults.Position.Y,targetZ);
		else
			calculatedPosition = rayCastResults.Position;
		end;
		
		--rayCastResults.Position = Vector3.new(math.floor(rayCastResults.Position.X/self.GridCellSize+.5)*self.GridCellSize;
	end
	
	return rayCastResults,calculatedPosition;
	--local hit,pos = workspace:findparonra
end;


function GridPlacement:_Render()
	
	local function update(_position)
		local results,Position = getMouseInput(_position,self);
		if(results)then

			if(not self._Instance)then return;end;
			local Size;
			if(self._InstanceType == "Model")then
				local _,Size = self._Instance:GetBoundingBox();
				Size = Size; --> For LSP in vs code to remove annoying warning
			else
				Size = self._Instance.Size;
			end;

			local tCFrame = CFrame.new(Position+Vector3.new(0,not self._IgnoreSize and Size.Y/2 or Position.Y,0)) * CFrame.Angles(0,math.rad(self.Angle),0);
			self.Results = {
				Instance = results.Instance;
				Position = results.Position;
				Material = results.Material;
				Normal = results.Normal;
				CFrame = tCFrame;
			};
		else
			self.Results = {};
		end;
	end
	
	
	self._dev._UISCHANGEDCONNECTION = UIS.InputChanged:Connect(function(InputObject,gameProccessed)
		if(gameProccessed)then return end;
		if(InputObject.UserInputType == Enum.UserInputType.MouseMovement)then
			update(InputObject.Position);			
		end
	end)
	
	--local RotationKeyCodeConnection;
	local function autoRotate()
		if(not self.AutomaticRotation)then return end;
		if(self._dev.RotationKeyCodeConnection)then self._dev.RotationKeyCodeConnection:Disconnect();self._dev.RotationKeyCodeConnection=nil;end;
		self._dev.RotationKeyCodeConnection = UIS.InputBegan:Connect(function(Key)
			if(Key.KeyCode.Name == self.RotationKeyCode.Name)then
				self.Angle = self.Angle + 45;
			end;
		end);

	end;
	
	--local ResultsChangedConnection

	return {
		["AutomaticPlacement"] = function(Value)
			if(Value)then
				if(not self._dev.ResultsChangedConnection)then
					self._dev.ResultsChangedConnection = self:GetPropertyChangedSignal("Results"):Connect(function(Results)
						if(Results.CFrame)then
							if(self._Instance)then
								if(self._InstanceType == "Model")then
									self._Instance:PivotTo(Results.CFrame);
								else
									self._Instance.CFrame = Results.CFrame;
								end
							
							end
							--Part.CFrame = Results.CFrame;
							--Results.CF
							--
						end
					end);
				end
			else
				if(self._dev.ResultsChangedConnection)then
					self._dev.ResultsChangedConnection:Disconnect();self._dev.ResultsChangedConnection=nil;
				end
			end
		end,
		["Angle"] = function(Value)
			if(not Value)then return;end;
			if(Value <= 360)then
				update(UIS:GetMouseLocation())
			else
				self:_RenderOnStep(function()
					self.Angle = Value%360;
				end)
			end
			
		end,
		["AutomaticRotation"] = function(Value)
			if(not Value)then
				if(self._dev.RotationKeyCodeConnection)then self._dev.RotationKeyCodeConnection:Disconnect();self._dev.RotationKeyCodeConnection=nil;end;
			else
				autoRotate();
			end
		end,
		["RotationKeyCode"] = function(Value)
			autoRotate();
		end,
		["ShowBoundingBox"] = function(Value)
			if(self._dev.sBox)then
				self._dev.sBox.Visible = Value;
			end;
			
		end,	
	};
end

--[=[
	@return GridPlacement
]=]
function GridPlacementService:Create(Instance_:Instance)
	--if(UISInputChangedListener)then return 
	local Player = game:GetService("Players").LocalPlayer;
	local Char;
	if(Player)then 
		Char = Player.Character or Player.CharacterAdded;
	end
	
	local CC = CustomClassService:CreateClassAsync(GridPlacement);
	local SelectionBox = Instance.new("SelectionBox");
	SelectionBox.LineThickness = 0.05;
	SelectionBox.SurfaceTransparency = .6;
	SelectionBox.Color3 = Color3.fromRGB(0, 255, 127);
	SelectionBox.SurfaceColor3 = SelectionBox.Color3;
	SelectionBox.Adornee = Instance_;
	SelectionBox.Parent = Instance_;
	CC._dev.sBox = SelectionBox;
	CC.RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist;
	CC.RaycastParams.FilterDescendantsInstances = {Instance_,Char};
	CC._InstanceType = Instance_:IsA("Model") and "Model" or "BasePart"; 
	CC._Instance = Instance_;
	
	return CC;
end;

return GridPlacementService
