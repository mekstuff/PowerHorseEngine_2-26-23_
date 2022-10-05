local CustomClassService = require(script.Parent.Parent.Services.CustomClassService);
local Players = game:GetService("Players");

local module = {}

local SpatialAreaClass = {
	Name = "SpitialArea",
	ClassName = "SpitialArea",
	OverlapParams = "**OverlapParams",
	Area = "**Instance",
	CFrame = CFrame.new(Vector3.new(0)),
	Size = Vector3.new(0),
	Enabled = true;
};

function SpatialAreaClass:GetSpotWithinArea(Object)
	local halfSize = self.Size/2
	local RandomX,RandomZ = math.random(-halfSize.X,halfSize.X),math.random(-halfSize.Z,halfSize.Z);

	local cf = self.CFrame:ToWorldSpace(CFrame.new(Vector3.new(RandomX,0,RandomZ)));
	return cf;
	-- print(self.Size);
end;

function SpatialAreaClass:_Render()
	
	local LiveDemo = Instance.new("Part");
	LiveDemo.CanCollide = false;
	LiveDemo.Material = Enum.Material.Neon;
	LiveDemo.Transparency = .85;
	LiveDemo.Anchored = true;
	LiveDemo.BrickColor = BrickColor.Red();
	LiveDemo.CanTouch = false;
	LiveDemo.CanQuery = false;
	self._dev.LiveDemo = LiveDemo;
	LiveDemo.Parent = workspace;
	
	local InActiveRegion = {};
	
	local ObjectAdded = self:AddEventListener("ObjectAdded",true);
	local ObjectRemoved = self:AddEventListener("ObjectRemoved",true)
	
	local PlayerAdded = self:AddEventListener("PlayerAdded",true);
	local PlayerRemoved = self:AddEventListener("PlayerRemoved",true)
	
	local PlayersInActiveRegion = {};
	
	self.ObjectAdded:Connect(function(Object)
		if(not Object)then return end;
		local Player = Players:GetPlayerFromCharacter(Object.Parent) --or Players:GetPlayerFromCharacter(Object.Parent.Parent);
		if(Player)then
			if(PlayersInActiveRegion[Player.UserId])then return end;
			PlayersInActiveRegion[Player.UserId]=true;
			PlayerAdded:Fire(Player,Object);
		end
	end)
	
	self.ObjectRemoved:Connect(function(Object)
		if(not Object)then return end;
		local Player = Players:GetPlayerFromCharacter(Object.Parent) --or Players:GetPlayerFromCharacter(Object.Parent.Parent);
		if(Player)then
			if not(PlayersInActiveRegion[Player.UserId])then return end;
			for _,v in pairs(InActiveRegion) do
				if(v:IsDescendantOf(Player.Character))then return end;
			end;
			PlayersInActiveRegion[Player.UserId] = nil;
			PlayerRemoved:Fire(Player,Object);
		end
	end)
	
	
	local AreaConnection;
	local ExtraEventConnection;
	local function DisconnectAreaConnection()
		if(AreaConnection)then
			AreaConnection:Disconnect();AreaConnection=nil;
		end
	end;local function DisconnectExtraEventConnection()
		if(ExtraEventConnection)then
			ExtraEventConnection:Disconnect();ExtraEventConnection=nil;
		end
	end
	
	local function updateInRegion(CF,Size)
		if(not self.Enabled)then return end;
		local inBox = workspace:GetPartBoundsInBox(CF,Size,self.OverlapParams);
	
		LiveDemo.CFrame = CF; LiveDemo.Size = Size;
		if(#inBox == #InActiveRegion)then
	
			--> Not a good check.. there's a chance the a new search is different but has the same amount
		else
	
			for _,v in pairs(inBox) do
				if(table.find(InActiveRegion,v))then
					--print(v.Name.." added");
				else
					ObjectAdded:Fire(v)
				end
			end
			local obj;
			for _,x in pairs(InActiveRegion) do
				if not(table.find(inBox,x))then
					obj = x;
					break;
					--ObjectRemoved:Fire(x)
				end
			end
			InActiveRegion = inBox;
			if(obj)then ObjectRemoved:Fire(obj);end;
		end

	end;
	
	local function areaUpdate(Object)
		if(Object:IsA("BasePart"))then
			local BoundingBoxCF,BoundingBoxSz = Object.CFrame, Object.Size;
			self.CFrame = BoundingBoxCF;self.Size = BoundingBoxSz;
		elseif(Object:IsA("Model"))then
			local BoundingBoxCF,BoundingBoxSz = Object:GetBoundingBox();
			self.CFrame = BoundingBoxCF;self.Size = BoundingBoxSz;
		end;
	end;
	
	return {
		["OverlapParams"] = function(v)
			table.insert(v.FilterDescendantsInstances, LiveDemo)
		end;
		["Enabled"] = function(v)
			if(not v)then
				InActiveRegion = {};
			end
		end,
		["CFrame"] = function(v)
			if(v)then
				--LiveDemo.CFrame = v;
				updateInRegion(v,self.Size);
			end
		end,
		["Size"] = function(v)
			if(v)then
				--LiveDemo.Size = v;
				updateInRegion(self.CFrame,v);
			end
		end,
		["Area"] = function(Object)
			if(Object)then
				areaUpdate(Object);
				DisconnectAreaConnection();
				AreaConnection = game:GetService("RunService").Heartbeat:Connect(function()
					if(self.Enabled)then
						areaUpdate(Object);
						-- local BoundingBoxCF,BoundingBoxSz = Object.CFrame, Object.Size;
						-- self.CFrame = BoundingBoxCF;self.Size = BoundingBoxSz;
					end;
				end)
			else
				DisconnectAreaConnection();
			end
		end,
	};
end


function module.new()
	local Class = CustomClassService:Create(SpatialAreaClass);
	return Class;
end;

return module
