local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local State = App:Import("State");

local _popoutwidget;
local function PopoutWidget()
	if(_popoutwidget)then return _popoutwidget;end;
	local Widget = App.new("Widget");
	Widget.Name = "PHe | Custom Pages";

	_popoutwidget = Widget;
	Widget.Parent = script.Parent.Parent.Components;
	return Widget;
end;

return {
	Name = "";
	Icon = "ico-mdi@navigation/more_horiz";
	Func = function(_,TabButton)
		local Frame = App.new("Frame");

	

		local OriginalParent;
		local hasPoppedOut:boolean = false;
		local Popout,setPopout = State(false);
		local ActionMenu = App.new("ActionMenu",script.Parent.Parent.Components);
		local PopoutOption = ActionMenu:AddAction("Popout","popout");

		local CustomPagePopoutDisplay = App.New "$Frame" {
			Size = UDim2.fromScale(1,1);
			BackgroundTransparency = 1;
			Visible = Popout;
			App.New "$Text" {
				Text = "CustomPages are in a different Widget, Press SHIFT+RIGHTCTRL to open",
				Position = UDim2.fromScale(0,.5);
				AnchorPoint = Vector2.new(0,.5);
				Size = UDim2.new(1);
				BackgroundTransparency = 1;
				TextWrapped = true;
			}
		};


		ActionMenu.ActionTriggered:Connect(function(action)
			if(action.ID == "popout")then
				setPopout(function(prev)
					return not prev;
				end)
			end;
		end)

		Popout:useEffect(function()
			if(Popout())then
				PopoutOption.Text = "Restore";
				PopoutOption.Icon = "ico-mdi@action/close_fullscreen";
				Frame.Parent = PopoutWidget();
			else
				Frame.Parent = OriginalParent;
				PopoutOption.Text = "Popout";
				PopoutOption.Icon = "ico-mdi@action/open_in_new";
				if(_popoutwidget)then
					_popoutwidget:Destroy();
					_popoutwidget = nil;
				end
			end
		end);
		TabButton.MouseButton2Click:Connect(function()
			ActionMenu:Show();
		end);
		local Connect;
		Connect = Frame:GetPropertyChangedSignal("Parent"):Connect(function()
			Connect:Disconnect();
			Connect = nil;
			OriginalParent = Frame.Parent;
			CustomPagePopoutDisplay.Parent = OriginalParent
		end)
		return Frame;
	end,
}