local IsClient = game:GetService("RunService"):IsClient();

--[=[
    :::info
    A promise can be viewed as pcall (protected call). Unlike a pcall, a promise does not yield the current thread
    :::
    @class Promise
]=]
local Promise = {
	Name = "Promise";
	ClassName = "Promise";
	PromiseState = "state";
    Error = false;
    _REPLICATEDTOCLIENTS = false;
};

Promise.__inherits = {}

--[=[
    @return Promise
]=]
function Promise:Cancel()
    if(self.PromiseState ~= "pending")then
        return self:_GetAppModule():GetService("ErrorService").tossWarn("Promises can only be cancelled in a pending state");
    end
    -- print(self.PromiseState);
    -- if(self.PromiseState == "resolved" or self.PromiseState == "rejected")then
        -- self:_GetAppModule():GetService("ErrorService").tossWarn("Cannot cancel a completed promise");
        -- return;
    -- end
    self.PromiseState = "cancelled";
    if(self._dev._activeExecutionThread)then
        coroutine.close(self._dev._activeExecutionThread);
        print("cancelled");
        -- coroutine.pause(self._dev._activeExecutionThread);
        self._dev._activeExecutionThread = nil;
    end;
    self._catchEvent:Fire("Promise cancelled process")
end;

--[=[
    @return Promise
]=]
function Promise:Then(cb:any)
    print("Connected cb")
    if(self._resolve)then
        local resfromCB = cb(self._resolve);
        if(resfromCB)then self._resolve = resfromCB;end;
        return self;
    end
    if(self._cbEvent)then
        task.spawn(function()
            local res = self._cbEvent:Wait();
            wait(.1);
            local resfromCB = cb(res);
            if(resfromCB)then self._resolve = resfromCB;end;

        end);
    end;
    return self;
end;

--[=[
    @return Promise
]=]
function Promise:Catch(cb:any)
    if(self._reject)then
        cb(self._reject);
        return self;
    end
    if(self._catchEvent)then
        task.spawn(function() 
            local res = self._catchEvent:Wait();
            cb(res);
        end);
    end;
    return self;
end;

--[=[
    :::warning
    `:try` should only be used once and be called directly after creating the promise

    it takes an argument `func` which is a callback function which has arguments `resolve` and `reject`

    ### Creating a promise

    ```lua
    local Promise = .new("Promise"):try(function(resolve,reject)
        if(true == true)then
            resolve("true is infact true");
        else
            reject("wait.. what?");
        end;
    end;
    ```

    ### How to use a promises in your functions

    Let's say your module has a function "RegisterToWeb" that makes HTTP calls that can will yield the thread and have chances of failing

    ### Your function:
    ```lua
    local function RegisterToWeb(...)
        local RegisterPromise = .new("Promise");
        
        -->:try (anything within here does not pause the thread)
        RegisterPromise:try(function(resolve,reject)
            local HTTPRequest = blahblahblah;
            wait(5);
            print("Running promise");
            if(HTTPRequest)then
                if(HTTPRequest.hasVitalInformation)then
                    resolve(HTTPRequest.hasVitalInformation)
                else
                    reject("HTTP Request does not contain the vital information");
                end;
            else
                reject("No response from server");
            end;
            reject("Something went wrong"); --> This is not needed, if a promise does not respond, the promise will automatically reject with 'no response from promise'
        end;

        return RegisterPromise;
    end;
    ```

    ### Calling your function:

    ```lua
        RegisterToWeb(...):Then(function(vitalInformation)
            print("Registered To web!");
        end):Catch(function(rejectionReason)
            print("Failed To Register because ", rejectionReason);
        end);

        print("Ran before promise");
        wait(6);
        print("Ran after promise");

        ---------OUTPUT---------
        --> Ran before promise
        --> Running promise
        --> Ran after promise
    ```

    :::
    @return Promise
]=]
function Promise:try(func:any)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    ErrorService.assert(not self._try, ":try already initiated");
    -- ErrorService.assert(getfenv(0).script == self._orgfenv, ":try can only be called by the script the created the promise");
    ErrorService.assert(typeof(func) == "function", "function expected for promise:try, got "..typeof(func));
    self._try=true;
        local promiseResolved;
        local promiseRejected;

        local function checkResRej()
            ErrorService.assert(not promiseResolved, "Promise was already resolved")
            ErrorService.assert(not promiseRejected, "Promise was already rejected")
        end;
        local function cleanupEvents()
            self._catchEvent:Destroy();self._catchEvent=nil;
            self._cbEvent:Destroy();self._cbEvent=nil;
        end;


    local function resolve(res)
        checkResRej();
        if(type(res) == "userdata")then
            if(typeof(res) == "Instance")then
                local c;
                c = self:GET("Servant"):Connect(res.Destroying, function()
                    self._resolve = nil;
                    self:GET("Servant"):Disconnect(c);
                end)
            elseif(typeof(res) == "table" and res.IsA and res:IsA("Pseudo"))then
                local c;
                c = self:GET("Servant"):Connect(res.Destroying, function()
                    self._resolve = nil;
                    self:GET("Servant"):Disconnect(c);
                end)
            end
        end
        promiseResolved = true;
        self._resolve = res;
        self._resolved = true;
        self._cbEvent:Fire(res);
        cleanupEvents();
        self.PromiseState = "resolved";
    end;
    local function reject(reason)
        checkResRej();
        promiseRejected = true;
        self._reject = reason;
        self._rejected = true;
        self._catchEvent:Fire(reason);
        cleanupEvents();
        self.PromiseState = "rejected";
    end; 
    -- task.spawn(function()
        self.PromiseState = "pending";
        self._dev._activeExecutionThread = coroutine.create(function()

        local ran,results = pcall(function()
                local res = func(resolve,reject);  
                -- coroutine.close(self._dev._activeExecutionThread);
                self._dev._activeExecutionThread = nil;
                return res;
            -- end 
        end);
        -- print(results);
        if(not ran)then
            if(self.Error)then error(results);end;
            reject(results);
        end
        if(not self._resolved and not self._rejected) then
            reject("Promise Error: No Response from :try");
        end;
    end)
    coroutine.resume(self._dev._activeExecutionThread);
    -- end);
    return self;
end

function Promise:_Render(App)
	local SignalProvider = App:GetProvider("SignalProvider");
    local Servant = App.new("Servant");


    -- self._dev._Servant = Servant;
    -- self._orgfenv = getfenv(0).script;
    self._cbEvent = SignalProvider.new("PromiseSignal");
    self._catchEvent = SignalProvider.new("PromiseSignal");

	return {
		_Components = {
            Servant = Servant;
        };
		_Mapping = {};
	};
end;

return Promise
