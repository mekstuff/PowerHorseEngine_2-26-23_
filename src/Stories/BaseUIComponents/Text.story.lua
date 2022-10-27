return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Component = App.New "$Text" {
        Parent = Wrapper;
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.5);
        AutomaticSize = Enum.AutomaticSize.XY;
        Text = "This is a Text Pseudo"
    };
    return function ()
        Component:Destroy();
    end;
end