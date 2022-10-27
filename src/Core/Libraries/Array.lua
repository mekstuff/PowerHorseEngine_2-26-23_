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
function Array.Adapt(self:table,originalArray:table,properTypes:boolean?,AdaptNestedArrays:boolean?,onImproperType:any?):table
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
function Array.new():table
    return {};
end;

return Array;