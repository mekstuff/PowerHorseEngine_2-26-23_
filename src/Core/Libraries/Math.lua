--[=[
    @class Math
    @tag Library
    Everything available in native luau [math](https://create.roblox.com/docs/reference/engine/libraries/math) is accessible in this library aswell.
    :::warning
    In the case that Math and math have to same functions, this Math library will be preferred.
    :::
]=]

local Math = {};

local sin = math.sin;
local pi = math.pi;

--[=[]=]
function Math.oscillate(min:number,max:number?,Time:number?):number
    max = max or (min < 0 and math.abs(min) or min-(min*2))
    Time = Time or time();
    local addv = (min + max)/2;
    local subv = (min - max)/2
                
    return (addv + subv *(sin(Time*1*pi*2)) );
end;
--[=[]=]
function Math.perc(x:number,y:number,max:number?)
    if(x == 0 and y == 0)then
        return 0;
    end
    return (x/y)*(max or 100);
end;

return setmetatable(Math,{
    __index = math
});