return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Component = App.New "$Button" {
        Parent = Wrapper;
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.5);
        Text = "Hover me";
    };

    local ToolTip = App.New "$ToolTip" {
        Parent = Wrapper;
        Adornee = Component;
        IdleTimeRequired = 0;
        require(script.Parent["Text.story"])
    }

    return function ()
        Component:Destroy();
        ToolTip:Destroy();
    end;
end