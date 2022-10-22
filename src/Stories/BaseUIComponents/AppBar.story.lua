return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local AppBar = App.new("AppBar",Wrapper);
    AppBar.AnchorPoint = Vector2.new(.5,.5);
    AppBar.Position = UDim2.fromScale(.5,.5);
    -- AppBar.Size = UDim2.fromOffset(300,100);
    AppBar.BackgroundColor3 = Color3.fromRGB(76, 172, 228);
    AppBar.TextColor3 = Color3.fromRGB(255,255,255);
    AppBar.BackgroundTransparency = 0;

    return function ()
        AppBar:Destroy();
    end;
end