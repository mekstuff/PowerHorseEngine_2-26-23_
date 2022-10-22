return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Component = App.New "$Frame" {
        Parent = Wrapper;
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.5);
    };
    return function ()
        Component:Destroy();
    end;
end