local EaseFrameAnimationClass = require(script.Parent._EaseFrameAnimation);

local module = {
	Name = "EaseFrame";
	ClassName = "EaseFrame";
};

module.__inherits = {}

function module:new(easeframes)
    local App = self:_GetAppModule();
    local CustomClassService = App:GetService("CustomClassService");
    local cc = CustomClassService:Create(EaseFrameAnimationClass,nil,easeframes);
    return cc;
end;

function module:_Render(App)
    -- self._dev.actives = {};
	return {};
end;

function module:_OrganizeEaseFrames(EaseFrames)
    local organized = {};
    local total = 0;

    for key,value in pairs(EaseFrames) do
        total+=1;
        local num = tonumber(key:match("%d+"));
        local TweenInfo_;
        local Callbacks;
        local Props;
        local NoTimeWaste;
        for a,x in pairs(value) do
            if(typeof(a) ~= "number") then
                Props = Props or {};
                Props[a] = x;
            else
                if(typeof(x) == "TweenInfo")then
                    -- if not(TweenInfo_)then
                        -- TweenInfo_ = TweenInfo.new(   
                    -- end;
                elseif(typeof(x) == "function")then
                    Callbacks = Callbacks or {};
                    table.insert(Callbacks, x);
                elseif(typeof(x) == "string" and x == "$")then
                    NoTimeWaste = true;
                end
            end
           
        end
        table.insert(organized, {key = key, value = value, num = num, tweeninfo = TweenInfo_, callbacks = Callbacks, props = Props, ntw = NoTimeWaste})
        -- organized[key] = {
            -- value = value, num = num, tweeninfo = TweenInfo_, callbacks = Callbacks
        -- }
    end;
    --[
    table.sort(organized, function(a,b)
        return a.num < b.num
    end);
    -- ]]
    return organized,total;
end


return module
