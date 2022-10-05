return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Prompt = App.new("Prompt");
    Prompt.StartPosition = UDim2.new(.5,0,-1,0);
Prompt.Body = [[
A Prompt is very similar to a modal, actual a prompt is just a component that expands on modals. Only a single prompt can be shown at 
a time unless you state otherwise. Prompts have levels so some prompts can override other prompts and so on...
]]
Prompt.Highlighted = true;
Prompt.Blurred = true;
    -- Prompt.Body = "A Prompt can be used to display information, you can parent components to a Prompt and they will appear here, where this current Body text is shown.\n\nYou can also add buttons to Prompts";
    Prompt.ButtonsAdjustment = App:GetGlobal("Enumeration").Adjustment.Right;
    Prompt:AddButton("ButtonB", {
        BackgroundColor3 = App:GetGlobal("Theme").getCurrentTheme().Secondary;
    })
    Prompt:AddButton("ButtonA");
    Prompt.Parent = Wrapper;

    local SnackbarExample = App.new("Snackbar");
    SnackbarExample.Text = "Snackbars also use prompts, but we can see both of these prompts because the \"PromptClass\" property are different from the default prompts."
    SnackbarExample.Parent = Wrapper;
    return function ()
        SnackbarExample:Destroy();
        Prompt:Destroy();
    end;
end