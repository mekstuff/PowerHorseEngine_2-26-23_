local Array = {};

function Array.Adapt(self:table,originalArray:table,properTypes:boolean,AdaptNestedArrays:boolean,onImproperType:any):table
    for a,b in pairs(originalArray) do
        -- print(AdaptNestedArrays,typeof(b))
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

function Array.new()
    return {};
end;

return Array;