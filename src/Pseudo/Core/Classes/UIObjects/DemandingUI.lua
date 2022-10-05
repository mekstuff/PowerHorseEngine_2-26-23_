local Enumeration = require(script.Parent.Parent.Parent.Enumeration);

local DemandingUI = {
    Name = "DemandingUI";
    ClassName = "DemandingUI";
    Speed = 5;
    Offset = 10;
    AnchorPoint = Vector2.new(0,0);
    -- PositionOffset = UDim2.new(0);
    Position = UDim2.fromScale(0);
    Adjustment = Enumeration.Adjustment.Bottom;
    UseAdjustment = "Bottom";
    Adornee = "**any";
};

-- DemandingUI.__inherits = {"BaseG"}

function DemandingUI:_Render()
    local App = self:_GetAppModule();

    local Utils = App:Import("@Utils");
    local CalculateUIBounds = Utils.CalculateUIBounds;

    
    local MainContainer = Instance.new("Frame",self:GetRef());
    MainContainer.Size = UDim2.fromOffset(20,20);
    MainContainer.AutomaticSize = Enum.AutomaticSize.XY;
    MainContainer.BackgroundTransparency = .5;

    local i = 0;
    local lastUDimi;
--[[
    task.spawn(function()
        while true do
            game:GetService("RunService").Heartbeat:Wait();
            i+=(1/self.Speed);
            if(i >= self.Offset)then
                i = 0;
            end;
            local UDim2_ = self.Adjustment == Enumeration.Adjustment.Bottom and (self.Position + UDim2.fromOffset(0,i)) or self.Adjustment == Enumeration.Adjustment.Top and (self.Position + UDim2.fromOffset(0,-i)) or self.Adjustment == Enumeration.Adjustment.Left and (self.Position - UDim2.fromOffset(i,0)) or self.Adjustment == Enumeration.Adjustment.Right and (self.Position + UDim2.fromOffset(i,0));
            local Offset;
            if(self.Adornee)then
                if(self.Adjustment == Enumeration.Adjustment.Bottom)then
                    Offset = UDim2.fromOffset( (self.Adornee.AbsolutePosition.X/2)-(MainContainer.AbsoluteSize.X/2), self.Adornee.AbsolutePosition.Y);
                elseif(self.Adjustment == Enumeration.Adjustment.Top)then
                    Offset = UDim2.fromOffset((self.Adornee.AbsolutePosition.X/2)-(MainContainer.AbsoluteSize.X/2), 0);
                elseif(self.Adjustment == Enumeration.Adjustment.Right)then
                    Offset = UDim2.fromOffset((self.Adornee.AbsolutePosition.X), (self.Adornee.AbsolutePosition.Y/2)-(MainContainer.AbsoluteSize.Y/2));
                elseif(self.Adjustment == Enumeration.Adjustment.Left)then
                    Offset = UDim2.fromOffset(0, (self.Adornee.AbsolutePosition.Y/2)-(MainContainer.AbsoluteSize.Y/2));   
                end;
            end;
            
            MainContainer.Position = Offset and UDim2_+Offset or UDim2_;
            
        end
    end);
]]
    
    return{
        ["Adornee"] = function(v)
            
        end;
        ["UseAdjustment"] = function(v)
            self.Adjustment = Enumeration.Adjustment[v]
        end;
        _Components = {
            _Appender = DemandingUI;
            -- FatherComponent = MainContainer;
        }
    };
end;

return DemandingUI;