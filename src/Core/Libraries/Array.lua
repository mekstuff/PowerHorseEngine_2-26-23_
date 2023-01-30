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
end

return Array;