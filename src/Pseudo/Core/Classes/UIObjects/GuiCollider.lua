--[=[
    @class GuiCollider
]=]
local GuiCollider = {
    Name = "GuiCollider",
    ClassName = "GuiCollider",
    AbsolutePosition = Vector2.new(0,0),
    AbsoluteSize = Vector2.new(0,0),
    Collisions = {},
};

local AllGuiColliders;

function GuiCollider:_Render()
    local App = self:_GetAppModule();
    local State = App:Import("State");

    if(not AllGuiColliders)then
        AllGuiColliders = {}
    end;

    table.insert(AllGuiColliders, self); --> Remove on destroy

    return function(Hooks:PseudoHooks)
        local useEffect = Hooks.useEffect;

        useEffect(function()
            if(self.Parent)then

                local Servant = App.new("Servant");

                local absSize,setabsSize = State(self.Parent.AbsoluteSize);
                local absPos,setabsPos = State(self.Parent.AbsolutePosition);
                self.AbsolutePosition = absPos();
                self.AbsoluteSize = absSize();

                Servant:Keep(absSize,absPos);
                
                self.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    setabsSize(self.Parent.AbsoluteSize);
                end);
                self.Parent:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                    setabsPos(self.Parent.AbsolutePosition)
                end);

                absPos:useEffect(function()
                    self.AbsolutePosition = absPos();
                    self.AbsoluteSize = absSize();
                    for _,v in pairs(AllGuiColliders) do
                        if(v ~= self)then
                            local xs = (self.AbsolutePosition.X - self.AbsoluteSize.X);
                            local xsr = (xs + self.AbsoluteSize.X);
                            
                            local xv = (v.AbsolutePosition.X - v.AbsoluteSize.X);
                            local xvr = (xv + v.AbsoluteSize.X);
                            print(xsr,xvr);
                            -- print(v.AbsolutePosition,v.AbsoluteSize,self.AbsolutePosition,self.AbsoluteSize)
                        end
                    end
                end,{absSize})
                
                return function()
                    Servant:Destroy();
                end
            end
        end, {"Parent"});
    end
end

return GuiCollider;


