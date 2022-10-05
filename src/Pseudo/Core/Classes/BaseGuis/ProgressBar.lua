local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");

local ProgressBar = {
	Name = "ProgressBar";
	ClassName = "ProgressBar";
	Value = 0;	
	Progress = 0;
	Size = UDim2.new(0,120,0,25);
	BackgroundColor3 = Color3.fromRGB(248, 248, 248);
	ForegroundColor3 = Theme.getCurrentTheme().Primary;
	StrokeThickness = 1;
	TweenSpeed = .2;
	Roundness = UDim.new(0);
};
ProgressBar.__inherits = {"BaseGui"}


function ProgressBar:_Render(App)
	
	local ProgressBarWrapper = App.new("Frame", self:GetRef());
	ProgressBarWrapper.Name = "$l_ProgressBarWrapper";
	local ProgressBar = App.new("Frame", ProgressBarWrapper:GetGUIRef());
	ProgressBar.Name = "$l_ProgressBar";

	local ValueChanged = self:AddEventListener("ValueChanged",true);
	
	return {
		["ZIndex"] = function(Value)
			ProgressBarWrapper.ZIndex = Value;
			ProgressBar.ZIndex = Value+1;
		end;
		["Progress"] = function(Value)
			self.Value = Value;
		end;
		["Value"] = function(Value)
			local calc = Value
			-- print(Value);
			if(Value > 1)then
				calc = Value/100;
			end;
			
			TweenService:Create(ProgressBar:GetGUIRef(), TweenInfo.new(self.TweenSpeed), {Size = UDim2.new(math.clamp(calc,0,1),0,1,0)}):Play();
			ValueChanged:Fire(Value);
		end,
		["ForegroundColor3"] = function(Value)
			ProgressBar.BackgroundColor3 = Value;
			ProgressBarWrapper.StrokeColor3 = Value;
		end,
		["Roundness"] = function(Value)
			ProgressBarWrapper.Roundness = Value;
			ProgressBar.Roundness = Value;
		end,["StrokeThickness"] = function(Value)
			ProgressBarWrapper.StrokeThickness = Value;
			ProgressBar.StrokeThickness = Value;
		end,
		_Components = {
			FatherComponent = ProgressBarWrapper:GetGUIRef();
			ProgressBar = ProgressBar;
		};
		_Mapping = {
			[ProgressBarWrapper] = {
				"Size","Position","AnchorPoint","BackgroundColor3","Visible";
			},[ProgressBar] = {
				"StrokeThickness";
			}
		};
	};
end;


return ProgressBar
