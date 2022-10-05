local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local HealthBar = {
	Name = "HealthBar";
	ClassName = "HealthBar";
	Health = 100;
	MaxHealth = 100;
	DisplayHealth = true;
	DisplayMaxHealth = true;
	BackgroundColor3 = Color3.fromRGB(132, 132, 132);
	ForegroundColor3 = Color3.fromRGB(92, 255, 80);
	AutomaticForeground = true;
	MaxDistance = 50;
	LightInfluence = 0;
	AlwaysOnTop = true;
	Size = UDim2.fromScale(8,1.7);
	StudsOffset = Vector3.new(0,1.7,0);
};
HealthBar.__inherits = {}


function HealthBar:_Render(App)
	if(IsClient)then
		local BillboardGui = Instance.new("BillboardGui",self:GetRef());
		-- BillboardGui.AlwaysOnTop = true;
		BillboardGui.ResetOnSpawn = false;
		--bill
		--BillboardGui.Size = UDim2.fromScale(10,2);
		--BillboardGui.StudsOffset = Vector3.new(0,BillboardGui.Size.Y.Scale+1,0)
		
		local ProgressBar = App.new("ProgressBar",BillboardGui);
		ProgressBar.Size = UDim2.fromScale(1,1)		
		
		local text;
		
		local autoforegroundConnection;
		local originalForeground = self.ForegroundColor3;
		
		local function autoForeground()
			local percentage = (self.Health/self.MaxHealth) * 100;
			if(percentage > 75)then
				self.ForegroundColor3 = originalForeground;
			elseif(percentage < 75 and percentage >= 50)then
				self.ForegroundColor3 = Color3.fromRGB(180, 255, 58);
			elseif(percentage <50 and percentage >=25)then
				self.ForegroundColor3 = Color3.fromRGB(230, 255, 61);
			elseif(percentage <25)then
				self.ForegroundColor3 = Color3.fromRGB(255, 84, 62);
			end
		end
		
		local function enableAutomaticForeground()
			if(autoforegroundConnection)then return;end;
			autoForeground();
			autoforegroundConnection = self:GetPropertyChangedSignal("Health"):Connect(function()
				autoForeground();
			end)
		end;
		local function disableAutomaticForeground()
			if(autoforegroundConnection)then
				autoforegroundConnection:Disconnect();
				autoforegroundConnection=nil;
			end
		end
		
		local function DisplayText()
			if(not self.DisplayHealth)then return end;
			if(not text)then
				text = App.new("Text",ProgressBar);
				text.Size = UDim2.new(1,0,1,0);
				text.BackgroundTransparency = 1;
				text.Text = "??/??";
				text.TextScaled=true;
			end;
			local t = tostring(self.Health)
			if(self.DisplayMaxHealth)then
				t = t.."/"..tostring(self.MaxHealth);
			end
			text.Text = t;
		end
		local function updateBar()
			ProgressBar.Value = (self.Health/self.MaxHealth)*100;
			DisplayText();
		end;

		return {
			["*Parent"] = function(Value)
				if(Value)then
					BillboardGui.Adornee = Value;
					BillboardGui.Parent = Value;
				end
			end,
			["Health"] = function(Value)
				updateBar();
			end,["MaxHealth"] = function(Value)
				updateBar();
			end,
			["DisplayHealth"] = function(v)
				if(v)then
					DisplayText();
				else
					if(text)then text.Visible=false;end;
				end
			end,
			["DisplayMaxHealth"] = function(v)
				DisplayText();
			end,
			["AutomaticForeground"] = function(v)
				if(v)then
					enableAutomaticForeground();
				else
					disableAutomaticForeground();
				end
			end,
			_Components = {};
			_Mapping = {
				[BillboardGui] = {
					"AlwaysOnTop","LightInfluence","MaxDistance","Size","StudsOffset";
				},
				[ProgressBar] = {
					"BackgroundColor3","ForegroundColor3"
				}
			};
		};
		
	else
		return {} --> Nothing is made on the server, only here for replication
	end
end;


return HealthBar
