local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

-- local Core_Vanilla = require(script.Parent.Parent.Vanilla);
-- local Mouse = Core_Vanilla.Mouse;
local System = require(script.Parent.Parent.Parent.System);
local UIS = game:GetService("UserInputService");

local Slider = {
	Name = "Slider";
	ClassName = "Slider";
	Size = UDim2.new(0,120,0,12);
	BackgroundColor3 = Theme.getCurrentTheme().Text;
	ForegroundColor3 = Theme.getCurrentTheme().Primary;
	--Roundness = UDim.new(0);
	Minimum = 0; 
	Maximum = 100;
	ShowSliderValue = false;
	AllowTextInputEditing = true;
	Value = 0;
	SliderValue = 0;
};
Slider.__inherits = {"BaseGui"};


function Slider:_SetSliderValue(Value)
	
end

function Slider:_Render(App)
	
	local ProgressBar = App.new("ProgressBar",self:GetRef())
	ProgressBar.Value = 0;
	ProgressBar.StrokeThickness = 0;
	ProgressBar.Roundness = UDim.new(0);
	local ActionButton = Instance.new("TextButton", ProgressBar:GET("ProgressBar"):GetGUIRef());
	ActionButton.Size = UDim2.new(0,10,1,5);
	ActionButton.Position = UDim2.new(1,ActionButton.AbsoluteSize.X,.5);
	ActionButton.AnchorPoint = Vector2.new(1,.5);
	ActionButton.Text = "";
	ActionButton.BorderSizePixel = 0;
	local lastKnownValueSliderValue;
	local ignoreValueUpdate = false;
	
	local ValueChanged = self:AddEventListener("ValueChanged",true);
	
	local function setSliderValue(Value)
		local MyValue = math.clamp(Value*self.Maximum,self.Minimum,self.Maximum);

		if(MyValue == lastKnownValueSliderValue)then return end;	
		
		if(Value > .5)then
			if(ActionButton.Position ~= UDim2.new(1,0,.5,0))then
				ActionButton:TweenPosition(UDim2.new(1,0,.5,0),"In","Linear",.1,true);
			end;	
		else
			if(ActionButton.Position ~= UDim2.new(1,10,.5,0))then
				ActionButton:TweenPosition(UDim2.new(1,10,.5,0),"In","Linear",.1,true);
			end;
		end;

		--TextInput:SetValue(MyValue);
		ProgressBar.Value = Value*100;
	
		lastKnownValueSliderValue = MyValue;
		self.Value = MyValue;
		ValueChanged:Fire(MyValue,Value);
		--if(ignoreValueUpdate == false)then
			--ignoreValueUpdate = true;
			--self.Value = MyValue;
			--ignoreValueUpdate = false;
		--end;
	end
	
	
	local RenderConnection;

	local function OnMouseUp()
		if(RenderConnection)then
			RenderConnection:Disconnect();
			RenderConnection = nil;
		end
	end;

	UIS.InputEnded:Connect(function(Input)
		if(Input.UserInputType == Enum.UserInputType.MouseButton1)then
			if(RenderConnection)then
				OnMouseUp();
			end
		end
	end)

	ActionButton.MouseButton1Down:Connect(function()
		--if(self.Disabled)then return end;
		RenderConnection = UIS.InputBegan:Connect(function(Input)
			if(Input.UserInputType == Enum.UserInputType.MouseMovement)then
				local Difference = Input.Position.X-ProgressBar:GetAbsolutePosition().X;

				local DifferenceNormalized = System.Processes:Normalize(Difference,0,ProgressBar:GetAbsoluteSize().X);
	
				--print(DifferenceNormalized);
				
			
	
				self.SliderValue = math.clamp(DifferenceNormalized,0,1);
				--self.Value = (DifferenceNormalized)
			end
		end)
		--[[
		RenderConnection = game:GetService("RunService").RenderStepped:Connect(function()

		end)
		]]
	end)
	
	return {
		["ForegroundColor3"] = function(Value)
			ActionButton.BackgroundColor3 = Value;
		end,
		["SliderValue"] = function(Value)
			--if(not ignoreValueUpdate)then
				setSliderValue(Value);
			--else
				--print("Ignored");
			--end
		end,
		_Components = {};
		_Mapping = {
			[ProgressBar] = {
				"Visible","Position","AnchorPoint","Size","BackgroundColor3","ForegroundColor3";
			};
		};
	};
end;


return Slider
