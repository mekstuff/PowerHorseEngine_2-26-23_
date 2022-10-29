return function(Wrapper:Frame)
    local App = require(script.Parent.Parent.Parent);
    local Badge1 = App.new("Badge");
    local Badge2 = App.new("Badge");
    Badge2.xAdjustment = App.Enumeration.Adjustment.Left
    Badge2.Text = "Adjusted Left"
    local Badge3 = App.new("Badge");
    Badge3.xAdjustment = App.Enumeration.Adjustment.Center
    Badge3.Text = "Adjusted Center"
    local Button = App.New "$Button" {
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.45);
        Parent = Wrapper;
        Text = "This Badge can be adjusted also";
        Badge1;
    }
    local Button2 = App.New "$Button" {
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.55);
        Parent = Wrapper;
        Text = "This Badge can be adjusted also";
        Badge2;
    }
    local Button3 = App.New "$Button" {
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.65);
        Parent = Wrapper;
        Text = "This Badge can be adjusted also";
        Badge3;
    }
    -- local Button = require(script.Parent["Button.story"])(Wrapper);
    -- Badge1.Parent = Button;
    return function ()
        Button:Destroy();Button2:Destroy();Button3:Destroy();
        Badge1:Destroy();Badge2:Destroy();Badge3:Destroy();
    end;
end;