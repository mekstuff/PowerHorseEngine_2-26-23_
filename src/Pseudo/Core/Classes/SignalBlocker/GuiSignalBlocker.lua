local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local GuiSignalBlocker = {
	Name = "GuiSignalBlocker";
	ClassName = "GuiSignalBlocker";
	--ZIndex = 0;
	Transparency = .3;
	Size = UDim2.fromScale(1,1);
	Color = Color3.fromRGB(0);
	ShowIndicator = false;
};
GuiSignalBlocker.__inherits = {"BaseGui"}


function GuiSignalBlocker:_Render(App)
	
	local Background = Instance.new("Frame",self:GetRef());
	Background.Name = "PHe-GuiSignalBlocker_Frame";
	local Button = Instance.new("TextButton",Background);
	Button.Name = "PHe-GuiSignalBlocker_Button";
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.Text = "";
	
	local e = self:AddEventListener("Focus",true);
	
	Button.InputBegan:Connect(function(InputObject)
		if(InputObject.UserInputType == Enum.UserInputType.MouseButton1 and InputObject.UserInputState == Enum.UserInputState.Begin)then
			local atPos = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(InputObject.Position.X,InputObject.Position.Y);
			--print(atPos)
			--if(#atPos == 2)then
			--	e:Fire();
			--	return;
			--end;
			for _,v in pairs(atPos) do
				if(v.BackgroundTransparency ~= 1 and (v.Name  ~= "PHe-GuiSignalBlocker_Frame" or v.Name  ~= "PHe-GuiSignalBlocker_Button"))then
					 return;
				end
			end;
			e:Fire();
		end
	end)
	--self:AddEventListener("Focus",true,Button.MouseButton1Click);
	
	local Indicator;
	
	return {
		["ShowIndicator"] = function(v)
			if(v)then
				if(not Indicator)then
					Indicator = App.new("ProgressIndicator",Background);
					Indicator.Color = Color3.fromRGB(255,255,255)	
				end;
				Indicator.Enabled = true;
			else
				if(Indicator)then Indicator.Enabled = false;end;
			end
		end,
		["ZIndex"] = function(Value)
			Background.ZIndex = Value;
			Button.ZIndex = Value;
		end,
	
		["Transparency"] = function(v)
			Background.BackgroundTransparency = v;
		end,
		["Color"] = function(v)
			Background.BackgroundColor3 = v;
		end,
		_Components = {};
		_Mapping = {
			[Background] = {
				"AnchorPoint","Position","Size","Visible";
			}	
		};
	};
end;


return GuiSignalBlocker
