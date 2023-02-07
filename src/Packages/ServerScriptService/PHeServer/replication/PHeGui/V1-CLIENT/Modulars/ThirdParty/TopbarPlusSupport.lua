local TopbarPlusSupport:SillitoBranch = {
    flag = "thirdparty-topbarplus";
    Running = false;
};

function TopbarPlusSupport:AddToDropdown(Icon:any)
    table.insert(self._dropdownIcons, Icon);
    return self._icon:setDropdown(self._dropdownIcons);
end

function TopbarPlusSupport:Init()
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    local Flags = App:GetProvider("UtilProvider").LoadUtil("Flags");
    local TopbarPlus = (Flags:GetFlag(self.flag));
    if(typeof(TopbarPlus) == "Instance" and TopbarPlus:IsA("ModuleScript"))then
        local Icon = require(TopbarPlus);
        self._Icon = Icon;
        local icon = Icon.new()
        self._icon = icon;
        self.Running = true;

        icon:setLabel("")
        :setImage("rbxtemp://1")
        :setLabel("PowerHorseEngine","selected")
        :setRight()

    else
        ErrorService.tossWarn(self.Name.." could not start because the the flag provided does not point to a ModuleScript.");
    end;
    self._dropdownIcons = {};
end;

--[=[]=]
function TopbarPlusSupport:GetIcon()
    return self._Icon;
end

return TopbarPlusSupport;