--[=[
    @class Test
    @server
]=]

local Test = {
    Awesome = false;
};

function Test:Init()
    
end;

function Test:Start()
    self.Awesome = 1;
    print(self.Awesome)
end;

return {}
