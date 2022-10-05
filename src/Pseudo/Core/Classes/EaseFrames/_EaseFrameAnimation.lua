local TweenService = game:GetService("TweenService");
local module = {
	Name = "EaseFrameAnimation";
	ClassName = "EaseFrameAnimation";
    TweenInfo = TweenInfo.new(1);
    Playing = false;
    Props = {};
};

module.__inherits = {"EaseFrame"}


function module:_GenerateTweens()
    if(self._tCache)then return self._tCache;end;
    self._tCache = {};
    for i,v in pairs(self._data) do
        local Next = self._data[i+1];
        if(Next and Next.props)then
            local Difference = Next.num - v.num;
            local TweenSpeed = Difference/100 * self.TweenInfo.Time;
            local Tweens = {};
            for instance,props in pairs(Next.props) do
                -- print(instance,props)
                local noReRenderProps = {};
                local ReRenderProps = {};
               for propname,propvalue in pairs(props) do
                    if(typeof(propvalue) == "string" and propvalue:match("^%$"))then
                        self._mustReRenderOnCall = true;
                        -- print(propvalue);
                        table.insert(Tweens, {
                            name = propname;
                            value = propvalue;
                            instance = instance;
                        })
                    else
                        noReRenderProps[propname] = propvalue;
                        -- table.insert(noReRenderProps, )
                    end
               end;
            --    print(noReRenderProps);
               local noReRendersTween = TweenService:Create(instance, self.TweenInfo, noReRenderProps);
               table.insert(Tweens, noReRendersTween);
               self._tCache[i] = {
                v = v;
                Tweens = Tweens;
            };
            end;
        else
            self._tCache[i] = {
                v = v;
                -- Tweens = nil;
            }
        end
        
    end;   
end

function module:ClearCache()
    self._tCache = nil;
end

--//
function module:Play(clearCache)
    local playThread = coroutine.create(function()
        
    self.Playing = true;
    if(clearCache)then self:ClearCache();end;
    if(not self._tCache)then
        self:_GenerateTweens();
    end;

    local toRemoveFromIndex;
    local currentTweenHost;

    for index,v in pairs(self._tCache) do
        if(v.v.callbacks)then
            for _,q in pairs(v.v.callbacks) do
                q(self);
            end
        end;
        self:GetEventListener("EaseFrameReached"):Fire(v.v.key,index);
        if(self._Signals["easeframe-"..v.v.key])then
            self._Signals["easeframe-"..v.v.key]:Fire();
        end;
        if(v.Tweens)then
            for TweenIndex,Tween in pairs(v.Tweens) do
                if(typeof(Tween) == "table")then
                    -- local instance = Tween.instance;
                    local targetStr = Tween.value:gsub("^%$","");
                    local targetValue = self.Props[targetStr];
                    self:_GetAppModule():GetService("ErrorService").assert(targetValue, "No Prop found \""..targetStr.."\" for EaseFrame "..self.Name.." @ "..v.v.key..". (The next EaseFrame Point is where the property was called)");
                    local newTween = TweenService:Create(Tween.instance,self.TweenInfo,{[Tween.name] = targetValue});
                    if(not toRemoveFromIndex)then toRemoveFromIndex = {};end;
                    table.insert(toRemoveFromIndex, TweenIndex);
                    table.insert(self._tCache[index].Tweens, newTween)
                end;
                if(typeof(Tween) ~= "table")then
                    Tween:Play();
                    if(not currentTweenHost)then currentTweenHost = Tween;end;
                end;
                if(currentTweenHost)then currentTweenHost.Completed:Wait();end;
            end;
            currentTweenHost = nil;
            --FIX: It does not work if we use more than 1 $PropVariable
            if(toRemoveFromIndex)then
                for _,x in pairs(toRemoveFromIndex) do
                    table.remove(self._tCache[index].Tweens,x);
                end
            end;
        else
            if not(v.v.ntw)then
                task.wait(self.TweenInfo.Time);
            end;
            -- coroutine.yield()
            -- 
        end;
    end;
    self.Playing = false;
end)self._activePlayThread = playThread;
coroutine.resume(playThread);

end;


function module:Pause()
    
end;

function module:Destroy()
    self:Cancel();
    self:GetRef():Destroy();
end;

function module:Cancel()
    if(self._tCache)then
        if(self.Playing)then
            if(self._activePlayThread)then
                -- print(coroutine.status(self._activePlayThread))
                -- local s,r = pcall(function()
                    -- task.wait(.1);
                    -- if(coroutine.status(self._activePlayThread) == )
                    -- coroutine.
                    -- coroutine.yield(self._activePlayThread);
                    task.wait(.2);
                    coroutine.close(self._activePlayThread);
                    self._activePlayThread = nil; 
                -- end);if(not s)then warn("EaseFrameWarning: :Stop() misthread");end;
            end
            -- self._stopInTracks = true;
        end
        for _,v in pairs(self._tCache) do
            if(v.Tweens)then
                for _,x in pairs(v.Tweens) do
                    x:Cancel()
                    -- print(x.Playing)
                end
            end
            -- self._stopInTracks = true;
        end
    end
end;

function module:GetEaseFrameReached(EaseFrame)
    if(self._Signals["easeframe-"..EaseFrame])then
        return self._Signals["easeframe-"..EaseFrame];
    end;
    local e = self:_GetAppModule():GetProvider("SignalProvider").new("easeframe-"..EaseFrame);
    self._Signals["easeframe-"..EaseFrame] = e;
    return e;
end

function module:_Render(App)

    local Organized,Total = self:_OrganizeEaseFrames(self._dev.args)
    self._dev.args=nil;
    self._data = Organized;
    -- self._tCache = ;
    -- self._easeFrameConnections;

    self:AddEventListener("EaseFrameReached", true);
    -- self._data = {
        -- Organized = Organized,
        -- Total = Total
    -- }
    -- local easeFrames = self._dev.args

	return {
	
	};
end;



return module
