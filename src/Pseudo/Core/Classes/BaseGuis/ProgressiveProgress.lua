-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Thursday, September 08 2022 @ 10:48:09

local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

--[[
    @class ProgressiveProgress
]]
local ProgressiveProgress = {
	Name = "ProgressiveProgress";
	ClassName = "ProgressiveProgress";
    CurrentIndex = "1",
    NextIndex = "2",
    ProgressBarPadding = 10;
};
ProgressiveProgress.__inherits = {"BaseGui","ProgressBar"};

function ProgressiveProgress:_Render(App)

    local Container = App.new("Frame",self:GetRef());
    Container.BackgroundTransparency = 1;

    local CurrentIndexButton = App.new("Button",Container);
    CurrentIndexButton.ButtonFlexSizing = false;
    CurrentIndexButton.Size = UDim2.new(.15,0,1,0);
    CurrentIndexButton.TextAdjustment = Enumeration.Adjustment.Center;
    CurrentIndexButton.AnchorPoint = Vector2.new(0,.5);
    CurrentIndexButton.Position = UDim2.fromScale(0,.5);
    CurrentIndexButton.TextScaled = true;
    local NextIndexButton = App.new("Button",Container);
    NextIndexButton.AnchorPoint = Vector2.new(1,.5);
    NextIndexButton.Position = UDim2.fromScale(1,.5);
    NextIndexButton.ButtonFlexSizing = false;
    NextIndexButton.Size = UDim2.new(.15,0,1,0);
    NextIndexButton.TextAdjustment = Enumeration.Adjustment.Center;
    NextIndexButton.TextScaled = true;

    local ProgressBar = App.new("ProgressBar",Container);
    ProgressBar.AnchorPoint = Vector2.new(.5,.5);
    ProgressBar.Position = UDim2.fromScale(.5,.5);
	
	return {
        ["CurrentIndex"] = function(v)
            CurrentIndexButton.Text = v;
        end;
        ["NextIndex"] = function(v)
            NextIndexButton.Text = v;
        end;
        ["ProgressBarPadding"] = function(v)
            ProgressBar.Size = UDim2.new(1-.3,-v,1,0);
        end;
		["Size"] = function(Value)
            Container.Size = Value;
            
            task.spawn(function()
                local abs = Container:GetGUIRef().AbsoluteSize;
                print(abs);
            end)
			-- local TotalYValue = 
		end,
		_Components = {
            FatherComponent = Container:GetGUIRef();
            CurrentIndexButton = CurrentIndexButton;
            NextIndexButton = NextIndexButton;
        };
		_Mapping = {
            [Container] = {"Position","AnchorPoint","Visible"},
            [ProgressBar] = {"Progress","BackgroundColor3","ForegroundColor3","Roundness","TweenSpeed"}
        };
	};
end;


return ProgressiveProgress;
