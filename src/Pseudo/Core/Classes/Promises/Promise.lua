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
    print("res")
    if(self._dev.WhenThen)then
        self._dev.WhenThen:Fire();
    end;
    for _,x in pairs(self._then) do
        local res = x(self._resolve);
        if(res)then
            self._resolve = res;
        end;
    end;
    coroutine.yield(self._dev.tryThread);
    -- coroutine.close(self._dev.tryThread);
end;
function Promise:_handleReject()
    for _,x in pairs(self._catch) do
        local res = x(self._reject);
        if(res)then
            self._reject = res;
        end;
    end;
    coroutine.yield(self._dev.tryThread);
    -- coroutine.close(self._dev.tryThread);
end;
function Promise:_handleCancel()
    for _,x in pairs(self._cancels) do
        local res = x(self._cancel);
        if(res)then
            self._cancel = res;
        end
    end;
    coroutine.yield(self._dev.tryThread);
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
        handler(resolve,reject,cancel);
        if(self.State == "stale")then
            ErrorService.tossWarn("[Promise] -> Promise stale after Try function completed, did not call resolve,reject or cancel. If you did not intend for this, please review your Then function::"..debug.info(handler,"s").." -> "..debug.traceback())
            -- self:Destroy(nil,true);
        end;
    end)coroutine.resume(self._dev.tryThread);
    return self;
end;

--[=[
    Waits until the promise is resolved, if it isn't resolve then it will yield forever.
]=]
function Promise:WhenThen(...)
    local App = self:_GetAppModule();
    local SignalProvider = App:GetProvider("SignalProvider");
    if(self.State == "stale")then
        local ThenConnector = self._dev.WhenThen;
        if(not ThenConnector)then
            ThenConnector = SignalProvider.new("WhenThen-"..self.__id);
        end;
        ThenConnector:Wait();
        return self:Then(...);
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