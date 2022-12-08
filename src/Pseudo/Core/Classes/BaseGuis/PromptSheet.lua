--[=[
    @class PromptSheet
]=]

local PromptSheet = {
    Name = "PromptSheet",
    ClassName = "PromptSheet",
    PromptClass = "PromptSheet",
    Size = UDim2.new(1,0,0,0);
    StartAnchorPoint = Vector2.new(.5,0);
    StartPosition = UDim2.new(.5,0,1,0);
    AnchorPoint = Vector2.new(.5,0);
    Position = UDim2.new(.5,0,1,0);
};
PromptSheet.__inherits = {"BaseGui","Prompt","Modal","GUI","Frame"}

function PromptSheet:AddButton(...:any)
    return self:GET("Prompt"):AddButton(...);
end;

function PromptSheet:_Render()
    local App = self:_GetAppModule();
    local Prompt = App.new("Prompt",self:GetRef());
    self:AddEventListener("ButtonClicked",true,Prompt:GetEventListener("ButtonClicked"));
	self:AddEventListener("ButtonAdded",true,Prompt:GetEventListener("ButtonAdded"));
    local PropProvider = App:GetProvider("PropProvider");
    return function(Hooks:PseudoHooks)
        local useMapping,useComponents = Hooks.useMapping,Hooks.useComponents;
        useMapping(PropProvider:FromPseudoClass("Prompt"), {Prompt});
        useMapping(PropProvider:FromPseudoClass("Modal"), {Prompt:GET("Modal")});
        useComponents({
            Prompt = Prompt;
            FatherComponent = Prompt:GetGUIRef();
            _Appender = Prompt:GET("_Appender");
        })
    end;
end

return PromptSheet;