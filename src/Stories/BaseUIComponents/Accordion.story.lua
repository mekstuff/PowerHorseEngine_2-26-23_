return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Accordion = App.new("Accordion",Wrapper);
    Accordion.AnchorPoint = Vector2.new(.5,0);
    Accordion.Position = UDim2.fromScale(.5);
    Accordion.Size = UDim2.fromOffset(300,100);
    Accordion.BackgroundColor3 = Color3.fromRGB(76, 172, 228);
    Accordion.Text = "Accordions are cool";
    Accordion.AutoExpand = true;
    Accordion.TextColor3 = Color3.fromRGB(255,255,255);

    local ButtonStory = require(script.Parent["Button.story"]);
    ButtonStory(Accordion);

    return function ()
        Accordion:Destroy();
    end;
end