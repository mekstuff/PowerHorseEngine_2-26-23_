-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Tuesday, August 30 2022 @ 13:42:25

--[[
    @class State
]]
local State = {
    Name = "State",
    ClassName = "State",
    State = "**any";
};


function State:useEffect(callback:any,dependencies:table)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    local lastrescallback;
    local function handleCallback()
        if(lastrescallback)then
            lastrescallback();
            lastrescallback=nil;
        end;
        local res = callback(self.State);
        if(typeof(res) == "function")then
            lastrescallback = res;
        end
    end;
    local useEffectServant = App.new("Servant");
    local Servant = self._dev.Servant;
    Servant:Keep(useEffectServant);
    handleCallback();
    useEffectServant:Connect(self:GetPropertyChangedSignal("State"), function()
        handleCallback();
    end);

    if(dependencies)then
        for key,value in pairs(dependencies) do
            if(typeof(key)~="number")then
                if(typeof(value)~="table")then ErrorService.tossError("Expected a table when using object as dependency key, got "..typeof(value)..". \""..tostring(key).."\"");end;
                for k,x in pairs(value) do
                    useEffectServant:Connect(key:GetPropertyChangedSignal(x), function()
                        handleCallback();
                    end)
                end;
            else
                if(typeof(value) == "table" and value:IsA("Pseudo"))then
                    if(value:IsA("State"))then
                        useEffectServant:Connect(value:GetPropertyChangedSignal("State"), function()
                            handleCallback();
                        end)
                    end
                end;
            end
            
        end
    end;
    return useEffectServant;
    -- return x,;
end;


function State:_Render(App)
    local Servant = App.new("Servant");
    local StateLib = App:Import("State");
    self.__metamethods = {

        __call = function()
            return self.State;
        end;
        __tostring = function()
            return tostring(self.State);
        end;
        __concat = function(this,concat)
            local inversed = false;
			if(this ~= self)then
				local oldthis = this;
				this = concat;
				concat = oldthis;
				oldthis = nil;
				inversed = true;
			end;
            local STATE,setSTATE = StateLib("");
            STATE.Name = "CONCATSTATE";
            STATE.Parent = workspace;
            if(typeof(concat) == "table" and concat.IsA and concat:IsA("Pseudo") and concat:IsA("State"))then
                self:useEffect(function()
                    setSTATE(not inversed and this.State..concat.State or concat.State..this.State);
                end, {concat})
            else
                self:useEffect(function()
                    setSTATE(not inversed and this.State..concat or concat..this.State);
                end)
            end;
            return STATE;
            --[[
			local inversed = false;
			if(this ~= self)then
				-- print('switching')
				local oldthis = this;
				this = concat;
				concat = oldthis;
				oldthis = nil;
				inversed = true;
			end;
            local NewState,setNewState = StateLib(this.State..concat);

            print(this.Name, inversed)

            this:useEffect(function()
                setNewState(this.State..concat);
            end);

            NewState.Parent = workspace;
            return NewState;
			-- return inversed and concat..tostring(this) or tostring(this)..concat;
        ]]
		end;
    }
    self._dev.Servant = Servant;
    return {};
end

return State;