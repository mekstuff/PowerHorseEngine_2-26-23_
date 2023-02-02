local HttpService = game:GetService("HttpService");  
--[=[]=]
return function(params:{[any]:any})
    return require(script.Parent.Parent.Parent).new("Promise"):Try(function(resolve,reject)
        local s,r = pcall(function()
            HttpService:RequestAsync(params)
        end);
        if(s)then
            resolve(s);
        else
            reject(r);
        end
    end)
end