--[=[
    @class NotificationService
    @client
]=]

local NotificationService:SillitoBranch = {};

function NotificationService:Init()
    
end;

function NotificationService:Start()
    local TopbarPlusSupport = self:GetModular("TopbarPlusSupport");
    if(TopbarPlusSupport.Running)then
        local Notifications = TopbarPlusSupport._Icon.new();
        Notifications:setLabel("Game Notifications"):notify();
        TopbarPlusSupport:AddToDropdown(Notifications)
        -- TopbarPlusSupport._icon:notify();
    end
end;

return NotificationService
