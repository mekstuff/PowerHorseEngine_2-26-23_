# Dark & Light Theme

To test, place the following code into a local script on the client.

```lua
--> Remove :PHeApp if you're not using ts
local App:PHeApp = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Theme = App:GetGlobal("Theme");

local DarkTheme = {
    Background = Color3.fromRGB(21,21,21);
    Text = Color3.fromRGB(240,240,240);
    CustomColor = Color3.fromRGB(95,95,95);
};

local LightTheme = {
    Background = Color3.fromRGB(240,240,240);
    Text = Color3.fromRGB(21,21,21);
    CustomColor = Color3.fromRGB(200,200,200);
};

local function SwitchToTheme(TargetTheme:{[string]:any})
    if(TargetTheme == LightTheme)then
        CurrentTheme = "light";
    else
        CurrentTheme = "dark";
    end
    Theme.extendTheme(TargetTheme)
end;

SwitchToTheme(LightTheme) --> Extend theme on init so our "CustomColor" will be applied

local GUI = Instance.new("ScreenGui");
GUI.Name = "PHe-ThemeDemo";
GUI.ResetOnSpawn = false;
GUI.IgnoreGuiInset = true;
local Player = game.Players.LocalPlayer;

local Background = App.new("Frame");
Background.Size = UDim2.fromScale(1,1);
--> Apply theme to components
Background.BackgroundColor3 = Theme.useTheme("Background");


local Button = App.new("Button");
Button.ButtonFlexSizing = true;
Button.AnchorPoint = Vector2.new(.5,.5);
Button.Position = UDim2.fromScale(.5,.5);
Button.Text = "Click To Switch Theme";
--> Apply theme to components
Button.BackgroundColor3 = Theme.useTheme("CustomColor");
Button.TextColor3 = Theme.useTheme("Text");

Button.Parent =  Background;
Background.Parent = GUI;


Button.MouseButton1Down:Connect(function()
    if(CurrentTheme == "light")then
        SwitchToTheme(DarkTheme);
    else
        SwitchToTheme(LightTheme);
    end
end)

GUI.Parent = Player:WaitForChild("PlayerGui")
```