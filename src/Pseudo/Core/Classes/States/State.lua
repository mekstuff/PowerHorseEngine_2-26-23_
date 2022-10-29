-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Tuesday, August 30 2022 @ 13:42:25

--[=[
    @class State

    It is recommended that you use the built in [State](StateLibrary) library when working with `State`

    :::warning
    Printing a State will print out the State.State, But be aware that you cannot compare States with premitives. 

    ```lua
    local State = .new("State");
    State.State = 1;
    print(State) --> 1
    print(State == 1) --> false
    ```
    This is because the State is Pseudo, not the actually value `1`. Instead use State.State or State()
    ```lua
    local State = .new("State");
    State.State = 1;
    print(State) --> 1
    print(State() == 1) --> true
    ```

    Comparing States with other Pseudo's may work but you should refrain from doing so if not needed.
    ```lua
    local State = .new("State");
    State.State = 1;
    local State2 = .new("State");
    State2.State = 1;
    print(State() == State2()) --> true | recommeded
    print(State == State2) --> true | not recommeded
    ```
    :::
]=]
local State = {
    Name = "State",
    ClassName = "State",
    State = "**any";
};

--[=[
    @prop State any
    @within State

    Calling the State as a function also returns the State value. This is the preferred way.
    ```lua
    print(State.State) == print(State())
    ```
]=]

--[=[
    @param callback function -- A function that is called when using the effect of the state
    @param callback table -- Depedencies that will trigger the useEffect

    @return Servant

    If you're familiar with `React` then the useEffect is very similar.

    Uses the [useEffect] hook.

    ```lua
    local State1 = .new("State");
    local State2 = .new("State");

    State1:useEffect(function()
        --> This will run everytime State1.State changes
        --> This will also run initially aswell.
    end)
    
    State1:useEffect(function()
        --> This will run everytime both State1.State and State2.State changes
        --> This will also run initially aswell.
    end, {State2}) --> State2 is now a dependency of this use Effect

    State1:useEffect(function()
        --> This will not run everytime State1.State changes, but will only run once which will be the initial run. (This is because the dependency list is empty)
    end, {}) --> Empty Depedency list instead of nil

    State1:useEffect(function()
        local prev = true;
        return function() --> Cleanup function, whenever State1.State changes, the previous useEffects cleanup function will be called
            prev = false;
        end;
    end)

    State1:useEffect(function()
        return function()
            --> This cleanup function will only run when the State is destroyed or the useEffect Servant. (This is because the dependency list is empty)
        end;
    end, {}) --> Empty Depedency list instead of nil
    ```
]=]
function State:useEffect(callback:any,dependencies:table):Instance
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