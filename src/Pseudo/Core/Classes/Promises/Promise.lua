local Promise = {};
Promise.Name = "Promise";
Promise.ClassName = "Promise";
Promise.PromiseState = "pending";

--[=[
    @class Promise
]=]

function Promise:_Render()
    local App = self:_GetAppModule();
    self._callbackhandlers = {
        _then = {};
        _catch = {};
    };
    local firstRun = true;
    return {
        ["PromiseState"] = function(x)
            if(firstRun)then firstRun = false;return;end;
            if(self.__allowStateSet)then
                -- return;
            else
                error("Tried to set state of promise. PromiseState is readonly.")
            end
        end
    };
end;

function Promise:_handleThen(callback)
    local results = callback(self._resolved);
    if(results)then
        self._resolved = results;
    end
end;

function Promise:_handleCatch(callback)
    local results = callback(self._rejected);
    if(results)then
        self._rejected = results;
    end
end

--[=[
    This method should be called right after the promise is created, here is where you will pass
    the handler function for your promise. This method should only be called once per promise.

    ```lua
    local function asyncFunction()
        local Promise = .new("Promise");
        Promise:Try(function(resolve, reject)
            local HttpService = game:GetService("HttpService");
            if(not HttpService.HttpEnabled)then return reject({success = false, error = "http service must be enabled"});end; 
            local website = "https://lanzoinc.com/fakeurl/rawdata";
            local data = HttpService:GetAsync(website,...); --> this will naturally yield, but only within this :Try
            --// as you can see ^^^ we did not wrap this in a pcall
            --// if an error ever occurs within your :Try function
            --// it will automatically call reject("callbackerror: "..errormessage)
            --// if you want to override this, then you need to handle errors using pcalls
            resolve({
                success = true;
                data = data;
            })
        end);

        return Promise; --> this will be returned immediately even though within our :Try method we have yielding code
    end;
    ```
]=]
function Promise:Try(handler:any)

    local function checkIsFullfilled()
        if(self._resolved)then return true; end;
        if(self._rejected)then return true; end;
        return nil;
    end;
    
    local function stopTryThread()
        if(self._dev.__activeThread)then
            self._dev.__activeThread = nil;
            coroutine.yield(self._dev.__activeThread);   
        end
    end;

    local function resolve(results)
        if(not checkIsFullfilled())then
            self._resolved = results or "";
            for _,v in pairs(self._callbackhandlers._then) do
                self:_handleThen(v);
            end;
            self._callbackhandlers = nil;
            stopTryThread();
        else
            warn("Promise state cannot be changed to resolved", results)
        end;
    end;

    local function reject(err)
        if(not checkIsFullfilled())then
            self._rejected = err or "";
            for _,v in pairs(self._callbackhandlers._catch) do
                self:_handleCatch(v);
            end;
            self._callbackhandlers = nil;
            stopTryThread();
        else
            warn("Promise state cannot be changed to rejected", err)
        end
    end;

    local function cancelled(err)
        if(self._callbackhandlers)then
            -- reject(err);
            -- stopTryThread();
        end
    end;

    self._rejectMethod = reject;
    self._resolveMethod = resolve;
    self._cancelMethod = cancelled;

    self._dev.__activeThread = coroutine.create(function()
        local ran,results = pcall(function()
            local x = handler(resolve,reject,cancelled);
            reject("Promise :Try did not resolve,reject or cancel.")
            return x;
        end);
        if(not ran)then
            reject("Promise thread execution error : "..results);
        end;
    end);coroutine.resume(self._dev.__activeThread);
    return self;
end;

--[=[
    Whenever the promise is resolved using resolve(), Then functions will be called
]=]
function Promise:Then(callback:any)
    if(self._resolved)then
        self:_handleThen(callback);
    else
        if(not self._callbackhandlers)then return self;end;
        table.insert(self._callbackhandlers._then, callback);
    end
    return self;
end;
--[=[
    Whenever the promise is rejected with reject(), Catch functions will be called
]=]

function Promise:Catch(callback:any)
    if(self._rejected)then
        self:_handleCatch(callback);
    else
        if(not self._callbackhandlers)then return self;end;
        table.insert(self._callbackhandlers._catch, callback);
    end
    return self;
end;
--[=[
    Similar to :Catch but instead if the promise is cancelled instead of rejected
]=]
function Promise:Cancel(reason:any)
    if(self._cancelMethod)then
        self._cancelMethod(reason);
    end;
    return self;
end;

--[=[
    Whenever is promise is destroyed, if the :Try method is still executing, it will 
    call Cancel() on the promise
]=]
function Promise:Destroy(cancelReason:any)
    if(self._dev.__activeThread and not self._resolved and not self._rejected)then
        self._cancelMethod(cancelReason or "Promise was destroyed prematurely while operation was executing");
    end;
    self:GetRef():Destroy();
end;

function Promise:__setState(state:any)
    self.__allowStateSet = true;
    self.State = state;
    self.__allowStateSet = false;
end;

--[[
    Example of using a promise

    Module script:
    ```lua
    local module = {};

    function module:GetUserThumbnail(PlayerNameString)
        local Promise = .new("Promise");
        Promise:Try(function(resolve,reject)
            local Players = game:GetService("Players");
            local PlayerId = Players:GetUserIdAsync(PlayerNameString);
            if(not PlayerId)then return reject({success = false, error = "Could not find userid for player \""..PlayerNameString.."\""});end;
            local PlayerThumbnail = Players:GetUserThumbnailAsync(PlayerId, ...);
            if(not PlayerThumbnail)then return reject({success = false, error = "Could not find player thumbnail for player \""..PlayerNameString.."\""});end;
            resolve({
                success = true,
                results = PlayerThumbnail
            })
        end);
        return Promise;
    end;

    return module;

    ```

    Elsewhere:
    
    ```lua
    local MyThumbnailGetterModule = require(...);
    MyThumbnailGetterModule:GetUserThumbnail("MightTea"):Then(function(res)
        local thumbnail = res.results;
        print("Your thumbnail -> "..thumbnail);
    end):Catch(function(err)
        if(typeof(err)~= "table")then warn("a reject that we didn't handle was passed");return end;
        warn("Oh no! "..err.error)
    end):Cancel(function(reason)
        warn("The promise was cancelled : ",err);
    end);

    ```
]]


return Promise;