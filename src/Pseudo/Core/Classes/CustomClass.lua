--[=[
    @class CustomClass

    Items Created with CustomClassService will inherit this class, You can detect CustomClasses by using `:IsA("CustomClass")`
]=]

local CustomClass = {
    Name = "CustomClass";
    ClassName = "CustomClass";
    __PseudoBlocked = true;
};

function CustomClass:_Render()
    return {};
end;

return CustomClass;