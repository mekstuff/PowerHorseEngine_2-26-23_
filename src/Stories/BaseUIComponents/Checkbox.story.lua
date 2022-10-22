return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Checkbox = App.New "$Checkbox" {
        Parent = Wrapper;
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.5);
    };
    return function ()
        Checkbox:Destroy();
    end;
end