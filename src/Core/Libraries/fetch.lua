local HttpService = game:GetService("HttpService");
--[=[
    To use RequestAsync, pass a table as the param argument
    To use GetAsync
    @return Promise
]=]

local _App
local function App()
    if(not _App)then
        _App = require(script.Parent.Parent.Parent);
    end;
    return _App;
end;

local function GET(...)
    local args = {...};
    return App().new("Promise"):Try(function(resolve)
        resolve(HttpService:GetAsync(unpack(args)));
    end);
end;

local function POST(...)
    local args = {...};
    return App().new("Promise"):Try(function(resolve)
        resolve(HttpService:PostAsync(unpack(args)));
    end);
end

return setmetatable({}, {
    __index = function(_,key)
        if(key == "POST")then
            return POST
        elseif(key == "GET")then
            return GET;
        else
            App():GetService("ErrorService").tossError(("%s is not a valid member of fetch, It only accept POST or GET, got \"%s\"."):format(key))
        end
    end,
    __tostring = function()
        return "fetch";
    end,
    __call = function(_,params:{[any]:any})
        return App().new("Promise"):Try(function(resolve)
            resolve(HttpService:RequestAsync(params));
        end);
    end
})

--[[
return function(params:{[any]:any}|string,url:string?,...:any)
    local App = require(script.Parent.Parent.Parent);
    local args = {...}
    if(typeof(params) == "table")then
        return App.new("Promise"):Try(function(resolve)
            resolve(HttpService:RequestAsync(params));
        end)
    else
        if(params == "Post")then
            return App.new("Promise"):Try(function(resolve)
                resolve(HttpService:PostAsync(url,unpack(args)));
            end)
        else
            return App.new("Promise"):Try(function(resolve)
                resolve(HttpService:GetAsync(url,unpack(args)));
            end)
        end;
    end

end
]]