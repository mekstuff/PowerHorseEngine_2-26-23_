---
sidebar_position: 3
---

# Stateful Button Incrementing

:::note What you'll learn
> How to use State & the State Library

> How to use the Whiplash Library
:::


All of the following examples below will produce the exact same results, PowerHorseEngine provides alot of ways to complete tasks, you decide which one you feel comfortable transitioning to.

## Vanilla

### State Pseudo

```lua
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui");

local DemoUI = Instance.new("ScreenGui");
DemoUI.Name = "Demo-Ui";
DemoUI.Parent = PlayerGui;

local ClickState = PowerHorseEngine.new("State");
ClickState.State = 0;

local Button = PowerHorseEngine.new("Button");
Button.Position = UDim2.fromScale(.5,.5);
Button.AnchorPoint = Vector2.new(.5,.5);
Button.Parent = DemoUI;

Button.MouseButton1Down:Connect(function()
    ClickState.State += 1;
end)

ClickState:useEffect(function(clickCount)
    local clickCountAsString = tostring(clickCount) or tostring(clickCount()) or tostring(clickCount.State) --> All 3 of these will be the same.
    Button.Text = "You clicked "..clickCountAsString.." "..(clickCount == 1 and "time" or "times")
end)
```

### StateLibrary

```lua
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local State = PowerHorseEngine:Import("State");
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui");

local DemoUI = Instance.new("ScreenGui");
DemoUI.Name = "Demo-Ui";
DemoUI.Parent = PlayerGui;

local ClickState,setClickState = State(0);

local Button = PowerHorseEngine.new("Button");
Button.Position = UDim2.fromScale(.5,.5);
Button.AnchorPoint = Vector2.new(.5,.5);
Button.Parent = DemoUI;

Button.MouseButton1Down:Connect(function()
    setClickState(function(oldClickState)
        return oldClickState+1;
    end)
    --[[OR
        setClickState(oldClickState()+1)
    ]]
end)

ClickState:useEffect(function(clickCount)
    local clickCountAsString = tostring(clickCount) or tostring(clickCount()) or tostring(clickCount.State) --> All 3 of these will be the same.
    Button.Text = "You clicked "..clickCountAsString.." "..(clickCount == 1 and "time" or "times")
end)

```

## Whiplash Library

```lua
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local New = PowerHorseEngine.New or PowerHorseEngine:Import("Whiplash").New --> Same Thing
local OnEvent = PowerHorseEngine.OnWhiplashEvent or PowerHorseEngine:Import("Whiplash").OnEvent --> Same thing
local State = PowerHorseEngine:Import("State");

local ClickCount,setClickCount = State(0);
local ButtonText,setButtonText = State("");

ClickCount:useEffect(function(count)
    setButtonText("You clicked "..tostring(count).." "..(count == 1 and "time" or "times"));
end);

New "ScreenGui" {
    Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui");
    Name = "Demo-Ui";
    New "$Button" {
        Position = UDim2.fromScale(.5,.5);
        AnchorPoint = Vector2.new(.5,.5);
        Text = ButtonText;
        [OnEvent "MouseButton1Down"] = function()
            setClickCount(function(oldClickCount)
                return oldClickCount+1;
            end)
        end
    }
}
```