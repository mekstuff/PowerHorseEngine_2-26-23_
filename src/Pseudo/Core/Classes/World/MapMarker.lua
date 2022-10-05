local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Camera = workspace.CurrentCamera;

local Player = game.Players.LocalPlayer;
local PlayerGui = Player and Player:WaitForChild("PlayerGui");
local PHeGui = Player and PlayerGui:WaitForChild("PHeGui");
local PHeGuiMiscs = Player and PHeGui:WaitForChild("Misc");

local MapMarkersContainer;

local MapMarker = {
	Name = "MapMarker";
	ClassName = "MapMarker";
	Range = 100;
	Enabled = true;
	ClampToScreen = true;
};

MapMarker.__inherits = {"AdorneeObject"}

local function CreateMarkerComponents(App)
	local Container = App.new("Frame");
	local Image = App.new("Image",Container);
	Image.Size = UDim2.fromScale(.9,.9);
	Image.AnchorPoint = Vector2.new(.5,.5);
	Image.Position = UDim2.fromScale(.5,.5);
	Image.Image = "rbxasset://textures/ui/TopBar/inventoryOn.png";
	Image.BackgroundTransparency = 1;
	Container.Roundness = UDim.new(0,30);
	Container.Size = UDim2.fromOffset(60,60);
	
	return Container,Image;
end;

function MapMarker:_Render(App)
	
	local ProximityReader = App.new("ProximityReader", self);
	local Container,Image = CreateMarkerComponents(App);
	
	if(not MapMarkersContainer)then
		MapMarkersContainer = App.new("Portal",PHeGuiMiscs);
		MapMarkersContainer.Name = "MapMarker";
	end;
	
	local TargetAdornee;
	
	local Screen = Camera.ViewportSize;


	
	local function border(x,y,abs)
	
		x = Camera.ViewportSize.X - x;
		y = Camera.ViewportSize.Y - y;
		
		local borderY = math.min(y,Camera.ViewportSize.Y-y);
		local borderX = math.min(x,Camera.ViewportSize.X-x);
		
		if(borderY < borderX)then
			if(y < (Camera.ViewportSize.Y - y))then
				return math.clamp(x,0,Camera.ViewportSize.X-abs.X),0;
			else
				return math.clamp(x,0,Camera.ViewportSize.X-abs.X),Camera.ViewportSize.Y-abs.Y;
			end;
		else
			if(x < (Camera.ViewportSize.X - x))then
				return 0,math.clamp(y,0,Camera.ViewportSize.Y-abs.Y);
			else
				return Camera.ViewportSize.X - abs.X,math.clamp(y,0,Camera.ViewportSize.Y-abs.Y);
			end
		end
		
	end

	
	local function stepped()
		
		if(TargetAdornee and ProximityReader.Activated)then
			
			if(not Container.Visible)then
				Container.Visible = true;
			end
			
			local Pos, Inview = Camera:WorldToScreenPoint(TargetAdornee.Position);
			
			
			if(Inview)then
				Container.Position = UDim2.fromOffset(Pos.X,Pos.Y);
			else
				-->Clamp to screen edges
				if(self.ClampToScreen)then

					local ABSSIZE = Container:GetAbsoluteSize();
					local x,y;
					if(Pos.X < 0)then
						x = 0;
					elseif(Pos.X > (Camera.ViewportSize.X - ABSSIZE.X) )then
						x = Camera.ViewportSize.X - ABSSIZE.X;
					else
						x = Pos.X;
					end
					
					if(Pos.Y < 0)then
						y = 0;
					elseif(Pos.Y > (Camera.ViewportSize.Y - ABSSIZE.Y))then
						y = Camera.ViewportSize.Y - ABSSIZE.Y;
					else
						
						if(Pos.Y > Camera.ViewportSize.Y/2)then
							y = 0;
						else
							y = Camera.ViewportSize.Y - ABSSIZE.Y;
						end
						--y = Pos.Y;
					end
					--print(Pos.Y)
					
					Container.Position = UDim2.fromOffset(x,y)
				end;
				
			end;
			
			
			
		else
			if(Container.Visible)then
				Container.Visible = false;
			end
		end;
	end;
	
	
	
	Container.Parent = MapMarkersContainer;
	
	local firstRan=true;
	
	return {
		["Enabled"] = function(Value)
			if(firstRan)then firstRan=false;return;end;
			if(Value)then
				TargetAdornee = self:GetAdornee(self.Parent);
				ProximityReader.Adornee = TargetAdornee
				if(not self._dev._renderStepConnection)then
					self._dev._renderStepConnection = game:GetService("RunService").RenderStepped:Connect(stepped);
				end;
			else
				if(self._dev._renderStepConnection)then
					self._dev._renderStepConnection:Disconnect();
					self._dev._renderStepConnection=nil;
					Container.Visible = false;
				end
			end
		end,
		["*Parent"] = function(Value)
			TargetAdornee = self:GetAdornee(Value);
			ProximityReader.Adornee = TargetAdornee
			if(not self._dev._renderStepConnection)then
				self._dev._renderStepConnection = game:GetService("RunService").RenderStepped:Connect(stepped);
			end
			
			--print(self:GetAdornee(Value))
		end,
		["Range"] = function(Value)
			ProximityReader.Magnitude = Value;
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return MapMarker
