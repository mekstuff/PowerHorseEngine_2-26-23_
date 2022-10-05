local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local QuickWeldService = App:GetService("QuickWeldService");
local CustomClassService = App:GetService("CustomClassService");
local Engine = App:GetGlobal("Engine");
local WorkspaceStorage = Engine:FetchWorkspaceStorage();
local ReplicatedStorage = Engine:FetchReplicatedStorage();
local IsClient = game.Players.LocalPlayer and true;
local WeldedOriginalModel = false;

local function CreateModel()
	local New = App:Import("Whiplash").New;
	local Material = Enum.Material.SmoothPlastic;
	local InitialBrickColor = BrickColor.new("Institutional white");
	local m = New "Model" {
		Name = "DirectionArrow";
		New "Part" {
			CanCollide = false;
			Anchored = true;
			Name = "Primary";
			Size = Vector3.new(0.771, 1.542, 3.083);
			Position = Vector3.new(-44.458, 1.542, 17.385);
			Orientation = Vector3.new(0, 90, 0);
			Material = Material;
			BrickColor = InitialBrickColor;
		};
		New "Part" {
			CanCollide = false;
			Anchored = true;
			Name = "Color";
			Size = Vector3.new(0.771, 1.542, 0.771);
			Position = Vector3.new(-46.386, 1.542, 17.385);
			Orientation = Vector3.new(0, 0, 0);
			Material = Material;
			BrickColor = InitialBrickColor;
		};
		New "WedgePart" {
			CanCollide = false;
			Anchored = true;
			Name = "Color";
			Size = Vector3.new(0.771, 0.771, 0.771);
			Position = Vector3.new(-47.156, 1.156, 17.385);
			Orientation = Vector3.new(-90, 90, 0);
			Material = Material;
			BrickColor = InitialBrickColor;
		};
		New "WedgePart" {
			CanCollide = false;
			Anchored = true;
			Name = "Color";
			Size = Vector3.new(0.771, 0.771, 0.771);
			Position = Vector3.new(-46.386, 2.698, 17.385);
			Orientation = Vector3.new(0, 90, 0);
			Material = Material;
			BrickColor = InitialBrickColor;
		};
		New "WedgePart" {
			CanCollide = false;
			Anchored = true;
			Name = "Color";
			Size = Vector3.new(0.771, 0.771, 0.771);
			Position = Vector3.new(-47.156, 1.927, 17.385);
			Orientation = Vector3.new(0, 90, 0);
			Material = Material;
			BrickColor = InitialBrickColor;
		};
		New "WedgePart" {
			CanCollide = false;
			Anchored = true;
			Name = "Color";
			Size = Vector3.new(0.771, 0.771, 0.771);
			Position = Vector3.new(-46.386, 0.385, 17.385);
			Orientation = Vector3.new(-90, 90, 0);
			Material = Material;
			BrickColor = InitialBrickColor;
		};
	
	}
	m.PrimaryPart = m.Primary;
	m.PrimaryPart.Name = "Color";
	m.Parent = script;
	return m;
end;

local Model = script:FindFirstChild("DirectionArrow") or CreateModel();


local module = {}

local DirectionArrowClass = {
	Name = "DirectionalArrow3D";
	ClassName = "DirectionalArrow3D";
	Origin = "**Instance";
	Target = "**Vector3";
	OriginOffset = Vector3.new(0,5,0);
	Magnitude = 0;
	BrickColor = BrickColor.new("Lime green");
	Enabled = true;
};

function DirectionArrowClass:_Render()
	
	if(not WeldedOriginalModel)then
		QuickWeldService:AnchorAll(Model);
		QuickWeldService:WeldAll(Model)
	end;
	
	local Arrow = Model:Clone();
	Arrow.Name = self._dev.__id;
	Arrow.Parent = WorkspaceStorage;
	self._dev.__clonedArrow = Arrow;
	
	local renderSteppedConnection;
	local function renderStepped()		
		local cf =  CFrame.lookAt((self.Origin.CFrame:ToWorldSpace(CFrame.new(self.OriginOffset))).Position, self.Target)
		Arrow:SetPrimaryPartCFrame(cf)	
		self.Magnitude = (self.Origin.Position - self.Target).Magnitude;
	end;

	local function disconnectConnection()
		if(IsClient)then
			if(renderSteppedConnection)then renderSteppedConnection:Disconnect();renderSteppedConnection=nil;end;
		else
			--print("Set to false")
			renderSteppedConnection=false;
		end;
	end
	local function connectConnection()
		--print("Here")
		if(IsClient)then
			if(not renderSteppedConnection)then
				renderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(renderStepped)
				self._dev._connc = renderSteppedConnection;	
			end
		else
			--print("Set to true")
			renderSteppedConnection=true;
		end;
	end;
	
	if(not IsClient)then
		task.spawn(function()
			while true do
				if(renderSteppedConnection)then
					renderStepped();
				end
				task.wait(.1);
			end
		end);
	end;
	
	return {
		["Enabled"] = function(v)
			if(v)then
				if(self.Target and self.Origin)then connectConnection();end;
				Arrow.Parent = WorkspaceStorage;
			else
				Arrow.Parent = ReplicatedStorage;
				disconnectConnection();
			end
		end,
		["Origin"] = function(v)
			--if(IsClient)then
				if(not v)then
					disconnectConnection();
					return;
				end
				if(self.Target and self.Enabled)then
					connectConnection()
				end
			--end
		end,
		["BrickColor"] = function(v)
			for _,x in pairs(Arrow:GetChildren())do
				if(x.Name == "Color")then x.BrickColor = v;end;
			end
		end,
		["Target"] = function(v)
			--if(IsClient)then
				if(not v)then
					disconnectConnection();
					return;
				end
				if(self.Origin and self.Enabled)then
					connectConnection();
				end
			--end
		end,
		
		_Components = {
			Arrow = Arrow;
		}
	};
end;

function module.new(Origin,Target)
	local c = CustomClassService:Create(DirectionArrowClass);
	c.Origin = Origin;
	c.Target = Target;
	return c;
end;

return module
