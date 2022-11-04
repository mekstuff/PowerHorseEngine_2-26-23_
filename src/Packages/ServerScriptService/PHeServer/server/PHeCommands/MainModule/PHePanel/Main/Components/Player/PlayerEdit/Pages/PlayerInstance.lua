local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Components = script.Parent.Parent.Parent.Parent;
local HeadsupText = require(Components.HeadsupText);

local function rightSideAction(className:string, props:table?)
    if(props)then
        props.SupportsRBXUIBase = props.SupportsRBXUIBase == nil and true;
    else
        props = {SupportsRBXUIBase = true}
    end
    local obj = App.New (className) (props)
    -- if(props)then
    --     for a,b in pairs(props) do
    --         obj[a] = b;
    --     end;
    -- end
    return obj;
end;

local function actionButton(icon:string?)
    return App.New "$Button" {
        Name = "FilterMe";
        ButtonFlexSizing = false;
        Icon = icon or "";
        Size = UDim2.fromScale(0,1);
        SupportsRBXUIBase = true;
        Text = "";
        App.New "UIAspectRatioConstraint" {
            DominantAxis = Enum.DominantAxis.Height;
            AspectType = Enum.AspectType.ScaleWithParentSize
        };
    }
end;

local function createOtherContent(list, parent)
    for _,v:Instance in pairs(list) do
        if(v:IsA("Folder"))then
            local Accordion = App.new("Accordion");
            Accordion.AutomaticSize = Enum.AutomaticSize.Y;
            Accordion.SupportsRBXUIBase = true;
            Accordion.AutoExpand = true;
            Accordion.Parent = parent;
            Accordion.Text = v.Name;
            Accordion.BackgroundTransparency = 1;
            Accordion:GetPropertyChangedSignal("Expanded"):Connect(function()
                Accordion.BackgroundTransparency = Accordion.Expanded and .7 or 1;
            end);
            local Scroller = App.New "$ScrollingFrame" {
                Size = UDim2.fromScale(1,1);
                BackgroundTransparency = 1;
                -- AutomaticCanvasSize = Enum.AutomaticSize.Y;
                AutomaticSize = Enum.AutomaticSize.Y;
                Parent = Accordion;
                App.New "UIListLayout" {
                    Padding = UDim.new(0,5);
                }
            }
            createOtherContent(v:GetChildren(),Scroller);
        else
            local ActionButton = App.new("Button");
            ActionButton.ButtonFlexSizing = false;
            ActionButton.Size = UDim2.new(1,0,0,30);
            ActionButton.SupportsRBXUIBase = true;
            ActionButton.BackgroundTransparency = 1;
            ActionButton.Text = v.Name;

            local EventButtons = App.new("Frame", ActionButton);
            EventButtons.AnchorPoint = Vector2.new(1,.5);
            EventButtons.Position = UDim2.new(1,-5,.5,0);
            EventButtons.Size = UDim2.new(.75,0,1,-10);
            EventButtons.BackgroundTransparency = 1;

            local EventButtonsList = Instance.new("UIListLayout", EventButtons:GetGUIRef());
            EventButtonsList.HorizontalAlignment = Enum.HorizontalAlignment.Right;
            EventButtonsList.FillDirection = Enum.FillDirection.Horizontal;
            EventButtonsList.VerticalAlignment = Enum.VerticalAlignment.Center;

            -- actionButton("ico-mdi@action/delete").Parent = EventButtons;

            if(v:IsA("ValueBase"))then
                if(typeof(v.Value) == "number" or typeof(v.Value) == "string") then
                    local Input = rightSideAction("$TextInput");
                    Input.Parent = EventButtons;
                    
                    Input.Text = tostring(v.Value);
                    v:GetPropertyChangedSignal("Value"):Connect(function()
                        Input.Text = tostring(v.Value);
                    end);
                elseif(typeof(v.Value) == "boolean")then
                    local Checkbox = rightSideAction("$Checkbox");
                    Checkbox.Parent = EventButtons;
                end 
            end;

            ActionButton.Parent = parent;
        end
    end
end;

return {
    Name = "Instance",
    Icon = "",
    Func = function(_,PlayerInfo)
		local Frame = App.new("Frame");
        local Scroller = App.New "$ScrollingFrame" {
            Size = UDim2.fromScale(1,1);
            BackgroundTransparency = 1;
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
            Parent = Frame;
            App.New "UIListLayout" {
                Padding = UDim.new(0,5);
            }
        }
		if not(PlayerInfo.PlayerInServer)then
			HeadsupText(PlayerInfo.Username.." isn't in the current server, you can't manipulate info.", Frame);
		else
            local Player = PlayerInfo.Player;
            createOtherContent(Player:GetChildren(),Scroller);
        end;
        return Frame;
    end
}