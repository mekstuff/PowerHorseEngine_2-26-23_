local Theme = require(script.Parent.Parent.Parent.Theme);

local FormControl = {
    Name = "FormControl";
    ClassName = "FormControl";
    Size = UDim2.new(1);
    AutomaticSize = Enum.AutomaticSize.Y;
    Position = UDim2.new(0);
    AnchorPoint = Vector2.new(0);
    Visible = true;
    -- BackgroundColor3 = Theme.getCurrentTheme().Text;
    -- BackgroundTransparency = 0;
};


function FormControl:_Render()
    local App = self:_GetAppModule();
    self._POSTMETHODS = {};
    self._INPUTS = {};

    
    local Control = App.new("Frame",self:GetRef());
    Control.BackgroundTransparency = 1;
    local UIListLayout = Instance.new("UIListLayout", Control:GetGUIRef());
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;

    return {
        _Mapping = {
            [Control] = {
                "Size","AutomaticSize","Position","AnchorPoint","Visible"
            },
            [UIListLayout] = {"Padding"};
        },
        _Components = {
            FatherComponent = Control;
            _Appender = Control;
        }
    }
end;

function FormControl:Input(id:any,InputType:string):any
    local App = self:_GetAppModule();
    App:GetService("ErrorService").assert(id, "Missing id from FormControl:Input")
    local TextInput = App.new("TextInput");
    TextInput.SupportsRBXUIBase = true;
    TextInput.Size = UDim2.new(1,0,0,35);
    TextInput.Parent = self:GET("_Appender");
    TextInput.StrokeTransparency = .5;

    self._INPUTS[id] = TextInput.Text;

    TextInput:GetPropertyChangedSignal("Text"):Connect(function()
        self._INPUTS[id] = TextInput.Text;
    end);

    -- table.insert(self._INPUTS, {
    --     id = id or math.random();
    --     input = TextInput;
    -- })
    
    

    return TextInput;
end;
function FormControl:Button(Text:string,POST_Method:string)
    local App = self:_GetAppModule();
    local Button = App.new("Button");
    Button.SupportsRBXUIBase = true;
    Button.ButtonFlexSizing = false;
    Button.Text = Text;
    Button.Size = UDim2.new(1,0,0,35);
    Button.Parent = self:GET("_Appender");

    Button.MouseButton1Down:Connect(function()
        if(self._POSTMETHODS[POST_Method])then
            print(self._POSTMETHODS, POST_Method)
            self._POSTMETHODS[POST_Method](self._INPUTS)
        end
    end)
    

    return Button;
end;

function FormControl:UsePOST(p,s)
    self._POSTMETHODS[p] = s;
end

return FormControl;