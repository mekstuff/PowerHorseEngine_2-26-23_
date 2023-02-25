--[=[
    @class Promise
    Very basic promise class.
]=]

--[=[
    @interface PromiseState
    @within Promise
    .stale string
    .resolved string
    .rejected string
    .cancelled string
]=]

local Promise = {
    Name = "Promise",
    ClassName = "Promise",
    State = "stale",
    MAXIMUM_RETRIES = 10,
};

function Promise:_onWhenThen()
    if(self._dev._WhenThen)then
        self._dev._WhenThen:Fire();
        self._dev._WhenThen:Destroy();
        self._dev._WhenThen = nil;
    end
end

function Promise:_handleResolve(...)
    if(self.State == "stale")then
        self.State = "resolved";
        self:_lockProperty("State");
        self._resolve = ...;
        self:_onWhenThen();
        for _,x in pairs(self._then) do
            local r = x(self._resolve,self);
            if(r)then
                self._resolve = r;
            end
        end;
    end;
    coroutine.yield(self._executionThread);
end
function Promise:_handleReject(...)
    if(self.State == "stale")then
        self.State = "rejected";
        self:_lockProperty("State");
        self._reject = ...;
        self:_onWhenThen();
        for _,x in pairs(self._catch) do
            local r = x(self._reject,self);
            if(r)then
                self._reject = r;
            end
        end;
    end
    coroutine.yield(self._executionThread);
end
function Promise:_handleCancel(...)
    if(self.State == "stale")then
        self.State = "cancelled";
        self:_lockProperty("State");
        self._cancel = ...;
        self:_onWhenThen();

        if(#self._cancels == 0) then --> We :Catch instead of :Cancel if no :Cancel are connected at call.
            for _,x in pairs(self._catch) do
                local r = x(self._cancel,self);
                if(r)then
                    self._cancel = r;
                end
            end;
        else
            for _,x in pairs(self._cancels) do
                local r = x(self._cancel,self);
                if(r)then
                    self._cancel = r;
                end
            end;
        end

    end;
    coroutine.yield(self._executionThread);
end;

--[=[
    Whenever a Promise is destroyed, if the current state is "stale", it will cancel the promise, by default it will
    cancel with a string "promise-destroyed". You can overwrite this by passing the cancel params when calling :Destroy(...)
]=]
function Promise:Destroy(cancel_reason:any)
    if(not cancel_reason)then
        cancel_reason = "promise-destroyed"
    end
    if(self.State == "stale")then
        self:_handleCancel(cancel_reason)
    end
    -- print("Destroying a promise!")
end

function Promise:Retry()
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    if(not self._initialTryHandler)then
        ErrorService.tossWarn("[Promise] You can call :Retry on a Promise without an existing :Try handler.");
        return;
    end;
    local nThread = coroutine.create(function()
        self.__totalretries = self.__totalretries and self.__totalretries+1 or 1;
        if(self.__totalretries >= self.MAXIMUM_RETRIES)then
            return ErrorService.tossError(("Promise exhausted MAXIMUM_RETRIES of %s"):format(tostring(self.MAXIMUM_RETRIES)))
        end
        self:_unlockProperty("State");
        self.State = "stale";
        self:Try(self._initialTryHandler);
    end);
    self._executionThread = task.defer(nThread);
end;
--[=[]=]
function Promise:Try(handler:(resolve:any,reject:any,cancel:any,promise:any)->any)

    local function resolve(...:any)
        self:_handleResolve(...);
    end;
    local function reject(...:any)
        self:_handleReject(...);
    end;
    local function cancel(...:any)
        self:_handleCancel(...);
    end;

    self._initialTryHandler = handler;

    local executionThread = coroutine.create(function()
        local s,r = pcall(function()
            handler(resolve,reject,cancel,self)
        end);
        if(not s)then
            reject(r);
        end
    end);
    self._executionThread = executionThread;
    task.spawn(executionThread);
    return self;
end;
--[=[
    Alias for :Then, syntax from other promise libraries
]=]
function Promise:andThen(...)
    return self:Then(...);
end
--[=[]=]
function Promise:await()
    local s,r;
    self:WhenThen(function(...)
        s = true;
        r = ...;
    end):Catch(function(...)
        s = false;
        r = ...;
    end);
    return s,r;
end
--[=[]=]
function Promise:WhenThen(...:any)
    local App = self:_GetAppModule();
    local SignalProvider = App:GetProvider("SignalProvider");
    if(self.State == "resolved")then
        return self:Then(...);
    else
        if(not self._dev._WhenThen)then
            self._dev._WhenThen = SignalProvider.new("WhenThen-"..self.__id);
        end;
        self._dev._WhenThen:Wait();
        if(self.State == "resolved")then
            return self:Then(...);
        end
    end;
    return self;
end

--[=[]=]
function Promise:Then(callback:(...any)->any)
    if(self.State == "resolved")then
        local r = callback(self._resolve,self);
        if(r)then
            self._resolve = r;
        end;
    elseif(self.State == "stale")then
        table.insert(self._then, callback);
    end;
    return self;
end;
--[=[
    Alias for :Catch, syntax from other promise libraries
]=]
function Promise:catch(...)
    return self:Catch(...);
end
--[=[]=]
function Promise:Catch(callback:(...any)->any)
    if(self.State == "rejected")then
        local r = callback(self._reject,self);
        if(r)then
            self._reject = r;
        end;
    elseif(self.State == "stale")then
        table.insert(self._catch, callback);
    end;
    return self;
end;

--[=[
    Alias for :Cancel, syntax from other promise libraries
]=]
function Promise:cancel(...)
    return self:Catch(...);
end
--[=[]=]
function Promise:Cancel(callback:(...any)->any)
    if(self.State == "cancelled")then
        local r = callback(self._cancel,self);
        if(r)then
            self._cancel = r;
        end;
    elseif(self.State == "stale")then
        table.insert(self._cancels, callback);
    end;
    return self;
end;

function Promise:_Render()
    self._then = {};
    self._catch = {};
    self._cancels = {};
    return {};
end

return Promise;

--[[
--[=[
    @class Promise
]=]

--[=[
    @interface PromiseState
    @within Promise
    .stale string
    .resolved string
    .rejected string
    .cancelled string
]=]

local Promise = {
    Name = "Promise",
    ClassName = "Promise",
    State = "stale"
};

--[=[
    @prop State PromiseState
    @within Promise
]=]

function Promise:_Render()
    self._then = {};
    self._catch = {};
    self._cancels = {};
    self._resolve = nil;
    self._reject = nil;
    self._cancel = nil;
    return {}
end;

function Promise:_handleResolved()
    if(self._dev.WhenThen)then
        self._dev.WhenThen:Fire();
    end;
    for _,x in pairs(self._then) do
        local res = x(self._resolve);
        if(res)then
            self._resolve = res;
        end;
    end;
    -- coroutine.yield(self._dev.tryThread);
    -- coroutine.close(self._dev.tryThread);
end;
function Promise:_handleReject()
    if(self._dev.WhenThen)then
        print("WHAT")
        self._dev.WhenThen:Fire(); --> We fire it because :Wait seems to hold even if after it's destroyed.
        self._dev.WhenThen:Destroy();
    end;
    for _,x in pairs(self._catch) do
        local res = x(self._reject);
        if(res)then
            self._reject = res;
        end;
    end;
    -- coroutine.yield(self._dev.tryThread);
    -- coroutine.close(self._dev.tryThread);
end;
function Promise:_handleCancel()
    if(self._dev.WhenThen)then
        self._dev.WhenThen:Fire(); --> We fire it because :Wait seems to hold even if after it's destroyed.
        self._dev.WhenThen:Destroy();
    end;
    for _,x in pairs(self._cancels) do
        local res = x(self._cancel);
        if(res)then
            self._cancel = res;
        end
    end;
    -- coroutine.yield(self._dev.tryThread);
    -- coroutine.close(self._dev.tryThread);
end;

function Promise:Try(handler:any)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    local function resolve(...:any)
        if(self.State == "stale")then
            self.State = "resolved";
            self._resolve = ...;
            self:_handleResolved();
        end
    end;
    local function reject(...:any)
        if(self.State == "stale")then
            print("REJECTING")
            self.State = "rejected";
            self._reject = ...;
            self:_handleReject();
        end;
    end;
    local function cancel(...:any)
        if(self.State == "stale")then
            self.State = "cancelled";
            self._cancel = ...;
            if(#self._cancels == 0)then
                ErrorService.tossWarn("[Promise] A Promise called cancel and no Cancel handlers were yet detected. "..tostring(...).." || "..debug.traceback())
            end
            self:_handleCancel();
        end;
    end;
    self._dev.tryThread = coroutine.create(function()
    -- task.spawn(function()
        
        local s,r = pcall(function()
            handler(resolve,reject,cancel);
        end);
        if(not s)then
            print("We should reject")
            return reject(r);
        end
        if(self.State == "stale")then
            ErrorService.tossWarn("[Promise] -> Promise stale after Try function completed, did not call resolve,reject or cancel. If you did not intend for this, please review your Then function::"..debug.info(handler,"s").." -> "..debug.traceback())
                -- self:Destroy(nil,true);
        end;
    end)
    task.spawn(self._dev.tryThread);
    -- end)coroutine.resume(self._dev.tryThread);
    return self;
end;

--[=[
    Yields the thread until the state is changed, if it resolved then will call callback, else will release yield.
]=]
function Promise:WhenThen(...)
    local App = self:_GetAppModule();
    local SignalProvider = App:GetProvider("SignalProvider");
    if(self.State == "stale")then
        local ThenConnector = self._dev.WhenThen;
        if(not ThenConnector)then
            ThenConnector = SignalProvider.new("WhenThen-"..self.__id);
            self._dev.WhenThen = ThenConnector;
        end;
        print("Waiting",self._dev.WhenThen)
        ThenConnector:Wait();
        print("No longer waiting");
        if(self.State == "resolved")then
            return self:Then(...);
        end
    else
        return self:Then(...)
    end
end
--[=[
    @return Promise
    @tag Chainable
]=]
function Promise:Then(callback:any)
    if(self.State == "stale")then
        table.insert(self._then, callback);
    else
        if(self.State == "resolved")then
            local res = callback(self._resolve);
            if(res)then
                self._resolve = res;
            end;
        end;
    end;
    return self;
end;
--[=[
    @return Promise
    @tag Chainable
]=]
function Promise:Catch(callback:any)
    if(self.State == "stale")then
        table.insert(self._catch, callback);
    else
        if(self.State == "rejected")then
            local res = callback(self._reject);
            if(res)then
                self._reject = res;
            end;
        end;
    end;
    return self;
end;
--[=[
    @return Promise
    @tag Chainable
]=]
function Promise:Cancel(callback:any)
    if(self.State == "stale")then
        table.insert(self._cancels, callback);
    else
        if(self.State == "cancelled")then
            local res = callback(self._cancel);
            if(res)then
                self._cancel = res;
            end;
        end;
    end;
    return self;  
end;

--[=[]=]
function Promise:Destroy(CancelReason:string,dontCancel:boolean?)
    if(not dontCancel and self.State == "stale")then
        self:Cancel(CancelReason);
    end;
    self._dev.tryThread = nil;
    self:GetRef():Destroy();
end;


return Promise;

]]