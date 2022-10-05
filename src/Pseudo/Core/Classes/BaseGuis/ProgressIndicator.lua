local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local ProgressIndicator = {
	Name = "Spinner";
	ClassName = "Spinner";
	Color = Theme.getCurrentTheme().Secondary;
	--ActiveColor = Theme.getCurrentTheme().Secondary;
	AnchorPoint = Vector2.new(.5,.5);
	CycleSpeed = 1;
	--Size = UDim2.fromOffset(60,15);
	Size = 40;
	Position = UDim2.fromScale(.5,.5);
	Enabled = true;
};
ProgressIndicator.__inherits = {"BaseGui"}

local function createIndicator(app,amt)
	local function cr()
		local respectGrid = Instance.new("Frame")
		respectGrid.BackgroundTransparency = 1;
		local frame = app.new("Frame",respectGrid);
		frame.Size = UDim2.fromScale(1,1);
		frame.Position = UDim2.fromScale(.5,.5);
		frame.AnchorPoint = Vector2.new(.5,.5);
		frame.Roundness = UDim.new(1,0);
		frame.StrokeTransparency = 1;
		
		return {frame=frame,respectGrid=respectGrid};
	end
	--
	local x = {}
	for i = 1,amt do
		x[i]=cr();
	end
	
	return unpack(x);
end


function ProgressIndicator:_Render(App)
	local Loader = App.new("ProgressRadial",self:GetRef());
	
	local Mouse = game.Players.LocalPlayer and game.Players.LocalPlayer:GetMouse();
	local SizeOverwritten;
	
	--local SteppedConnection;
	--local int = Instance.new("Vector3Value",workspace);
	local function SteppedFunction(Input)
		--print(Loader.Size, Input.Position.X)
		--Loader.Position = UDim2.new(int.Value.X,int.Value.Y);
		Loader.Position = UDim2.fromOffset(Input.Position.X+(self.Size),Input.Position.Y+(self.Size+5));
	end;
	
	return {
		["*Parent"] = function(v)
			if(Mouse)then
				if(Mouse == v)then
					local MiscFolder = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PHeGui"):WaitForChild("Misc");
					Loader.Parent = MiscFolder;
					if(not self._dev.SteppedConnection)then
						self._dev.SteppedConnection = game:GetService("UserInputService").InputChanged:Connect(function(Input)
							if(Input.UserInputType == Enum.UserInputType.MouseMovement)then
								SteppedFunction(Input);
							end
						end)
						--self._dev.SteppedConnection = game:GetService("RunService").RenderStepped:Connect(SteppedFunction);
					end
					if(not SizeOverwritten)then
						SizeOverwritten=true;
						self.Size = 20;
					end;
				else
					Loader.Parent = self:GetRef();
					if(self._dev.SteppedConnection)then
						self._dev.SteppedConnection:Disconnect();
						self._dev.SteppedConnection=nil;
					end
				end;
			end
		end,
		["Enabled"] = function(v)
			Loader.Yielding = v;
			Loader.Visible = v;
		end,
		["CycleSpeed"] = function(v)
			Loader._Speed = v;
		end,
		["Size"] = function(v)
			Loader.Size = UDim2.fromOffset(v,v);
		end,
		_Mapping = {
			[Loader] = {
				"Position","AnchorPoint","Color","Visible"
			};
			
		}
	}
	--[[
	local a1,a2,a3 = createIndicator(App,3)
	--print(a1)
	local c = Instance.new("Frame");
	c.BackgroundTransparency = 1;
	local Grid = Instance.new("UIGridLayout",c);
	Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
	Grid.CellSize = UDim2.new(1/3,-5,1,0);
	Grid.CellPadding = UDim2.new(0,5);
	a1.respectGrid.Parent=c;a2.respectGrid.Parent=c;a3.respectGrid.Parent=c;
	
	c.Parent = self:GetRef();
	
	local function an(f)
		f.Size = UDim2.new(1,7,1,7);
		f.BackgroundColor3 = self.ActiveColor;
		wait(.5);
		f.Size = UDim2.fromScale(1,1);
		f.BackgroundColor3 = self.Color;
	end
	
	local t = coroutine.create(function()	
		while self._dev do
			print("Loop")
			an(a1.frame);
			an(a2.frame);
			an(a3.frame);
		end;
	end);coroutine.resume(t);
	
	
	return {
		["Size"] = function(Value)
			--c.Size = Value;
			c.Size = UDim2.fromOffset(Value,Value/3-5);
		end,

		_Components = {};
		_Mapping = {
			[c] = {"Position","AnchorPoint"}	
		};
	};
	]]
end;


return ProgressIndicator
