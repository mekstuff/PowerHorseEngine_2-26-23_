return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Modal = App.new("Modal",Wrapper);
    Modal.Body = "A modal can be used to display information, you can parent components to a modal and they will appear here, where this current Body text is shown.\n\nYou can also add buttons to modals";
    Modal.ButtonsAdjustment = App:GetGlobal("Enumeration").Adjustment.Right;
    Modal:AddButton("ButtonB", {
        BackgroundColor3 = App:GetGlobal("Theme").getCurrentTheme().Secondary;
    })
    Modal:AddButton("ButtonA")
    return function ()
        Modal:Destroy();
    end;
end