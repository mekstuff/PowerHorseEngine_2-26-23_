local ServiceProvider = require(script.Parent.ServiceProvider);
local PseudoService = ServiceProvider:LoadServiceAsync("PseudoService");
local SerializationService = ServiceProvider:LoadServiceAsync("SerializationService");
local PropProvider = {};

function PropProvider:GetProps(propSheet:{},ignoreHiddenProps:boolean?,ignoreFunctions:boolean?,onlykeys:boolean?):{[any]:any}
    local x = {};
    for a,b in pairs(propSheet)do
        if not( (ignoreHiddenProps and string.match(a,"^_")) or (ignoreFunctions and typeof(b) == "function"))then
            if(onlykeys)then
                 table.insert(x,a)
            else
                x[a]=b;
            end;
        end
    end;
    return x;
end

function PropProvider:FromPseudoClass(Class:string,ignoreHiddenProps:boolean?,ignoreFunctions:boolean?,onlyKeys:boolean?)
    ignoreHiddenProps = ignoreHiddenProps == nil and true or false;
    ignoreFunctions = ignoreFunctions == nil and true or false;
    onlyKeys = onlyKeys == nil and true or false;
    local ClassModule = (PseudoService:GetPseudoModule(Class));
    if(ClassModule)then
        local x = require(ClassModule);
        local props = (self:GetProps(x,ignoreHiddenProps,ignoreFunctions,onlyKeys));
        return props;
    else
        warn("NO");
    end
end;

return PropProvider;