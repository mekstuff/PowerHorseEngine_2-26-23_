return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Button = App.new("Button",Wrapper);
    Button.AnchorPoint = Vector2.new(.5,.5);
    Button.Position = UDim2.fromScale(.5,.5);
    Button.Text = "Buttons are cool";
    Button.Icon = "ico-mdi@action/thumb_up";
    Button.TextColor3 = Color3.fromRGB(255,255,255);
    return function ()
        Button:Destroy();
    end;
end