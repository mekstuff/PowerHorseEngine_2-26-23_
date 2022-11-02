--[=[
    @class Math
    @tag Library
]=]

local Math = {};

local sin = math.sin;
local pi = math.pi;

function Math.oscillate(min:number,max:number?,Time:number?):number
    max = max or (min < 0 and math.abs(min) or min-(min*2))
    Time = Time or time();
    local addv = (min + max)/2;
    local subv = (min - max)/2
                
    return (addv + subv *(sin(Time*1*pi*2)) );
end

return Math;