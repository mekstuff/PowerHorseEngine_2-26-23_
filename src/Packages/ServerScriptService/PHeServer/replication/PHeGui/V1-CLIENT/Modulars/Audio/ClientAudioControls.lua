--[=[
    @class ClientAudioControls
    @client
    @tag Core
]=]

local ClientAudioControls:SillitoBranch = {
    PlayerCanEditAudios = true;
};

function ClientAudioControls:Init()
    
end;

function ClientAudioControls:Start(Hooks:PseudoHooks)
    self:ConnectToTopbarPlus(Hooks);
end;

function ClientAudioControls:ConnectToTopbarPlus(Hooks:PseudoHooks)

    local TopbarPlusSupport = self:GetModular("TopbarPlusSupport");
    if(not TopbarPlusSupport.Running)then
        return;
    end;
    local App = self:_GetAppModule();
    -- local AudioService = App:GetService("AudioService");

    local useEffect = Hooks.useEffect;
    local icon = TopbarPlusSupport._Icon.new()
        :setLabel("Audio");

    -- print(AudioService:GetChannels())
    -- AudioService
    
    local AudiosList = {};
    
    TopbarPlusSupport:AddToDropdown(icon)
    useEffect(function()
        if(self.PlayerCanEditAudios)then
            icon:unlock();
        else
            icon:lock();
        end
    end,{"PlayerCanEditAudios"})
end

return ClientAudioControls
