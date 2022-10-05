local Theme = require(script.Parent.Parent.Parent.Theme);

local Snackbar = {
    Name = "Snackbar";
    ClassName = "Snackbar";
    BackgroundColor3 = Theme.getCurrentTheme().Foreground;
    TextColor3 = Theme.getCurrentTheme().ForegroundText;
    Highlighted = false;
    TextXAlignment = Enum.TextXAlignment.Left;
    TextWrapped = true;
    ActionButtonText = "Action";
    Text = "Snackbar";
    PromptClass = "Snackbar";
    Size = UDim2.new(1,-20);
    Position = UDim2.new(.5,0,1,-10);
    AnchorPoint = Vector2.new(.5,1);
    StartPosition = UDim2.new(.5,0,2,0);
};

Snackbar.__inherits = {"BaseGui","Text"}

function Snackbar:_Render(App)
    local Enumeration = App:GetGlobal("Enumeration");

    local SnackBarPrompt = App.new("Prompt");
    SnackBarPrompt.PromptClass = self.PromptClass;
    SnackBarPrompt.CloseButtonBehaviour = Enumeration.CloseButtonBehaviour.None;
    SnackBarPrompt.Header = "";
    SnackBarPrompt.Position = self.Position;
    SnackBarPrompt.AnchorPoint = self.AnchorPoint;
    SnackBarPrompt.StartPosition = self.StartPosition;
    local PromptModal = SnackBarPrompt:GET("Modal");
    PromptModal:GET("Top"):Destroy();
    PromptModal:GET("Bottom"):Destroy();

    local SnackbarText = App.new("Text", SnackBarPrompt);
    -- SnackbarText:GetGUIRef().Name = "A_$l";
    -- SnackbarText.BackgroundTransparency = .5;
    SnackbarText.SupportsRBXUIBase = true;
    SnackbarText.Size = UDim2.new(1,-30,0,25);
    SnackbarText.AutomaticSize = Enum.AutomaticSize.Y;
    
    -- local UILister = Instance.new("UIListLayout",PromptModal:GET("_Appender"));
    -- UILister.SortOrder = Enum.SortOrder.Name;
    -- UILister.FillDirection = Enum.FillDirection.Horizontal;


    SnackBarPrompt.Parent = self:GetRef();

    local ActionButton;
    local function getActionButton()
        if(ActionButton)then return end;
        ActionButton = App.new("Button");
        ActionButton.TextColor3 = Theme.getCurrentTheme().Foreground;
        ActionButton.BackgroundColor3 = Theme.getCurrentTheme().ForegroundText;
        ActionButton.SupportsRBXUIBase = true;
        ActionButton.AnchorPoint = Vector2.new(1);
        ActionButton.Position = UDim2.new(1,-5);
        ActionButton.Parent = SnackBarPrompt;
        return ActionButton;
    end;

    return {
        -- ["ZIndex"] = function(v)
            -- Snac
        -- end;
        ["ActionButtonText"] = function(v)
            if(v=="")then
            else
                getActionButton();
                ActionButton.Text = v;
            end
        end;
        _Mapping = {
            [SnackBarPrompt] = {"BackgroundColor3","Visible","ZIndex","Highlighted","PromptClass","Size","Position","StartPosition","AnchorPoint","StartAnchorPoint"},
            [SnackbarText] = {"TextColor3","Text","TextWrapped","TextSize","Font","TextScaled","TextTransparency","ZIndex",
            "TextXAlignment"
        },
        }
    };
end;

return Snackbar;