local ContextActionService = game:GetService("ContextActionService");
--[=[
    @class Contextor
    @tag Library

]=]
local Contextor = {};

local actions = {};
--[=[
```lua
Contextor:Bind("Test", function(actionName:string,inputObject:InputObject)
    print("Input Began")
    return function(x)
        print("Input Ended");
    end,function()
        print("Input Changed");
    end,function()
        print("Input Cancelled");
    end
end,false,Enum.KeyCode.F);

-->
Contextor:Bind("MouseHold", function()
    print("Holding");
    return function ()
        print("No longer holding")
    end
end,false,Enum.UserInputType.MouseButton1);
```

For UserInputTypes such as MouseMovement that don't have, the initial funtion binding will be used as a Changed bind
```lua
Contextor:Bind("MouseMove", function()
    print("Mouse is moving!")
end,false,Enum.UserInputType.MouseMovement);
```
    @param mobileButton boolean|{[any]:any} -- You can pass a dictionary to set properties of the buttons, passing Title="string" will call `ContextActionService`:SetTitle, you can also use [State](/api/State) for dynamic values.
]=]
function Contextor:Bind(actionName:string, actionHandler: (actionName:string,InputObject:InputObject)->(()->any??,()->any??,()->any??), mobileButton:boolean|{[any]:any}?,...:Enum.KeyCode|Enum.UserInputType?)
    local handlerId = tostring(actionHandler);
    local createNativeButton = (typeof(mobileButton) == "boolean" or "table") and true;

    ContextActionService:BindAction(actionName, function(Name:string,InputState:Enum.UserInputState,InputObject:InputObject)
        if(not actions[actionName])then
            actions[actionName] = {};
        end
        if(not actions[actionName][handlerId])then
            actions[actionName][handlerId] = {};
        end
        if(InputState == Enum.UserInputState.Begin)then
            local _end,_change,_cancel = actionHandler(Name,InputObject);
            actions[actionName][handlerId]["_end"] = _end;
            actions[actionName][handlerId]["_change"] = _change;
            actions[actionName][handlerId]["_cancel"] = _cancel;
        elseif(InputState == Enum.UserInputState.End)then
            if(actions[actionName][handlerId] and actions[actionName][handlerId]["_end"])then
                actions[actionName][handlerId]["_end"]()
            end
            elseif(InputState == Enum.UserInputState.Change)then
                if(actions[actionName][handlerId] and actions[actionName][handlerId]["_change"])then
                    actions[actionName][handlerId]["_change"]()
            -- else
                -- actionHandler(Name,InputObject);
            end
        elseif(InputState == Enum.UserInputState.Cancel)then
            if(actions[actionName][handlerId] and actions[actionName][handlerId]["_cancel"])then
                actions[actionName][handlerId]["_cancel"]()
            end
        end
    end, createNativeButton,...)
    if(typeof(mobileButton) == "table")then


        if(mobileButton.Title)then
            if(typeof(mobileButton.Title) == "string")then ContextActionService:SetTitle(actionName, mobileButton.Title);
            else mobileButton.Title:useEffect(function() ContextActionService:SetTitle(actionName, mobileButton.Title());end)
        end;end;
        if(mobileButton.Image)then
            if(typeof(mobileButton.Image) == "string")then ContextActionService:SetImage(actionName, mobileButton.Image);
            else mobileButton.Image:useEffect(function() ContextActionService:SetImage(actionName, mobileButton.Image());end)
        end;end;
        if(mobileButton.Description)then
            if(typeof(mobileButton.Description) == "string")then ContextActionService:SetDescription(actionName, mobileButton.Description);
            else mobileButton.Description:useEffect(function() ContextActionService:SetDescription(actionName, mobileButton.Description());end)
        end;end;
        if(mobileButton.Position)then
            if(typeof(mobileButton.Position) == "UDim2")then ContextActionService:SetPosition(actionName, mobileButton.Position);
            else mobileButton.Position:useEffect(function() ContextActionService:SetPosition(actionName, mobileButton.Position());end)
        end;end;


    end;
end;

-- setmetatable(Contextor, {
--     __index = ContextActionService;
-- });

return Contextor;