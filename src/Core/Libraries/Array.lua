--[=[
    @class Array
    @tag Library
]=]

local Array = {};

--[=[
    ```lua
    local Array1 = {
        Object1 = true;
        NoLongerSupported = true;
    }
    local Array2 = {
        Object1 = "This will only change if proper types are true";
        NewlySupported = {
            Supported = true;
            Version = 1;
        }
    }

    Array.Adapt(Array1,Array2);
    --[[
        Array 1 will now be: 

        Array1 = {
            Object1 = true;
            NewlySupported = {
                Supported = true;
                Version = 1;
            }
        }
    ]]
    ```

]=]
function Array.Adapt(self:table,originalArray:{},properTypes:boolean?,AdaptNestedArrays:boolean?,onImproperType:any?):{}
    for a,b in pairs(originalArray) do
        if(self[a] == nil)then
            self[a] = b;
        else
            if(properTypes and typeof(self[a]) ~= typeof(b))then
                local v;
                if(onImproperType)then
                        local improperResults = onImproperType(a,b,self[a],self,originalArray);
                        assert(improperResults ~= nil, ("Expected A Value from onImproperType callback function, got nil"));
                        v = improperResults;
                    else
                        v = b;
                end;
                self[a]=v;
            end;
        end;
        if(AdaptNestedArrays and typeof(b) == "table")then
            self[a] = Array.Adapt(self[a],b,properTypes,AdaptNestedArrays,onImproperType);
        end
    end;
    for x,y in pairs(self) do
        if(originalArray[x] == nil)then self[x]=nil;end;
    end
    return self;
end;

--[=[]=]
function Array.new():{}
    return {};
end;


--[=[
    Loops through the array and calls the conditional statement on each member, if condition returns true then the item will be removed after
    each member was finished iterating

    This function is not yet well optimized.

    @return {}
]=]
function Array.detach(self:any, conditional:(key:any,value:any)->boolean|nil)
    local neededContent = {};
    for a,b in pairs(self) do
        local res = conditional(a,b);
        assert(typeof(res) == "boolean" or res == nil, ("Array.detach conditional handler must return a boolean or nil, got \"%s\""):format(tostring(res)))
        if(res ~= true)then
            table.insert(neededContent,b);
        end
    end;

    for i,x in pairs(neededContent) do
        table.insert(self,i,x);
    end;

    for i = #self,1,-1 do
        if(i == #neededContent)then
            break;
        end
        table.remove(self,i);
    end;
    neededContent = nil;
    return self;
end;

--[=[
```lua
local x = {
    {Name = "Hello"},
    {Name = "World"},
};

Array.find(x,function(key, value)
    return value.Name == "Hello" and true or false;
end, function(key, value)
    print("Found ! ",key,value)
end)
```
You can also query for the first item to match by not passing a handler

```lua
print(Array.find(x,function(key, value) return value.Name == "World" and true;end));
```
]=]
function Array.find(self:any,conditional:(key:any,value:any)->any,handler:(key:any,value:any)->any?,executeHandlersAfterConditionals:boolean?)
    local toexec = executeHandlersAfterConditionals and {};
    for a,b in pairs(self) do
        local res = conditional(a,b);
        assert(typeof(res) == "boolean" or res == nil, ("Array.find conditional handler must return a boolean or nil, got \"%s\""):format(tostring(res))) 
        if(res)then
            if(not handler)then
                return a,b;
            end
            if(executeHandlersAfterConditionals)then
                table.insert(toexec, {a = a,b = b});
            else
                handler(a,b);
            end
        end
    end;
    if(toexec)then
        for _,x in pairs(toexec) do
            handler(x.a,x.b);
        end;
        toexec = nil;
    end
end;

--[=[]=]
function Array.weighChances(self:any,chanceIdentifierFunction:(key:any,value:any)->number?):(any,any)
    local defaultIdentifierType;
    local isFirstCheck;
    chanceIdentifierFunction = chanceIdentifierFunction or function(key,value)
        local asNumber = tonumber(value);
        if(not asNumber)then
            warn(("Array.weighChances default IdentifierFunction tried to use the value of the item, but failed. If value of items aren't numbers, pass a custom chanceIdentifierFunction. %s = %s"):format(tostring(key),tostring(value)))
            return 0;
        end;
        return asNumber;
    end;
    local w = 0;
    local chances_t = {};
    for a,b in pairs(self) do
        local chance = chanceIdentifierFunction(a,b);
        assert(typeof(chance) == "number", ("number expected from .weighChances, got %s"):format(typeof(chance)));
        chances_t[a] = chance;
        w+=(chance)
    end;
    local rand = math.random(1,w);
    w = 0;
    for a,b in pairs(self) do
        w += (chances_t[a]);
        if(w >= rand) then
            return a,b;
        end
    end
end;

--[=[]=]
function Array.len(self:any,dictionary:boolean?)
    if(not dictionary)then
        return #self;
    else
        local t = 0;
        for _,_ in pairs(self) do
            t+=1;
        end;
        return t;
    end
end

return Array;