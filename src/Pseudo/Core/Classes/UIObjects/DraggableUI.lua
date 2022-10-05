local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService")

local Draggables = {
    dockable = {},
    transmitters = {},
};

local DraggableUI = {
    Name = "DraggableUI",
    ClassName = "DraggableUI",
    AutoDragging = true;
    Dragging = false;
    Enabled = true;
    Transmits = {"Draggable"};
    Docks = false;
    AppendDraggable = "**any";
    -- Recieves = "Draggable";
};

function DraggableUI:_Render(App)

    -- local activeParent;

    local hasinBounds = {};
    local totalinBounds = 0;

    local ButtonDrag = Instance.new("TextButton");
    -- ButtonDrag.ButtonFlexSizing = false;
    ButtonDrag.Size = UDim2.fromScale(1,1);
    ButtonDrag.BackgroundTransparency = 1;
    ButtonDrag.Text = "";

    local DragStarted,DragEnded = self:AddEventListener("DragStarted",true),self:AddEventListener("DragEnded",true);

    self:AddEventListener("DockEntered",true);
    self:AddEventListener("DockExited",true);
    self:AddEventListener("Docked",true);

    -- self:AddEventListener("DraggableActive");
    self:AddEventListener("DraggableEntered",true);
    self:AddEventListener("DraggableExited",true);
    self:AddEventListener("DraggableDocked",true);
    
    local MouseButton1Down;
    local MouseButton1Up;
    local function disconnectButtonEvents()
        if(MouseButton1Down)then MouseButton1Down:Disconnect();MouseButton1Down=nil;end;
        if(MouseButton1Up)then MouseButton1Up:Disconnect();MouseButton1Up=nil;end;
    end;

    local function connectButtonEvents()
        if(MouseButton1Down)then return end;
        MouseButton1Down = ButtonDrag.MouseButton1Down:Connect(function()
            self.Dragging = true;
        end);
        -- print("called");
        MouseButton1Up = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
            if(input.UserInputType == Enum.UserInputType.MouseButton1)then
                self.Dragging = false;
            end;
        end);
    end;

    local clonedState,ToolTip;

    local function createClonedState()
        if(not ToolTip)then
            -- print(self._activeParent);
            ToolTip = App.new("ToolTip", self.AppendDraggable or self._activeParent.Parent);
            -- print(self.AppendDraggable);
            -- print(App:GetService("PluginService"):IsPluginMode())
            ToolTip.RevealOnMouseEnter = false;
            ToolTip.IdleTimeRequired = 0;
        end
        if(clonedState)then return end;
        local c = self._activeParent:Clone();
        for _,x in pairs(c:GetDescendants()) do
            if(x:IsA("BaseScript") or x:IsA("ModuleScript"))then
                x:Destroy();
            end
        end;
        c.Parent = ToolTip:GetGUIRef();
        clonedState = c;
    end;

    local FramePositionChangedConnection;

    local function disconnectFramePositionChanged()
        if(FramePositionChangedConnection)then FramePositionChangedConnection:Disconnect(); FramePositionChangedConnection=nil;end;
    end;
    local function connectFramePositionChanged()
        disconnectFramePositionChanged();
        local toolTipsFrame = ToolTip:GET("Frame"):GetGUIRef();
        FramePositionChangedConnection = toolTipsFrame:GetPropertyChangedSignal("Position"):Connect(function()
            for _,v in pairs(Draggables.dockable) do
                local sameChannel=false;
                for _,q in pairs(self.Transmits) do
                    if table.find(v.Transmits, q) then
                        sameChannel=true;
                        break;
                    end
                end
                if(sameChannel)then
                local itsEventer = v:GET("Eventer");
                local x,y = toolTipsFrame.AbsolutePosition.X+toolTipsFrame.AbsoluteSize.X,toolTipsFrame.AbsolutePosition.Y+toolTipsFrame.AbsoluteSize.Y;
	
                local xstart,xend = itsEventer.AbsolutePosition.X, itsEventer.AbsolutePosition.X+itsEventer.AbsoluteSize.X;
                local ystart,yend = itsEventer.AbsolutePosition.Y, itsEventer.AbsolutePosition.Y+itsEventer.AbsoluteSize.Y;
                
                
                if( x >= xstart and x <= xend and y >= ystart and y <= yend )then
                    if(hasinBounds[v._dev.__id])then return end;
                    hasinBounds[v._dev.__id] = v;
                    totalinBounds+=1;
                    v:GetEventListener("DraggableEntered"):Fire(self,self._realParent, self._activeParent);
                    self:GetEventListener("DockEntered"):Fire(v,v._realParent, v._activeParent);
                else
                    if(hasinBounds[v._dev.__id])then
                        totalinBounds-=1;
                        v:GetEventListener("DraggableExited"):Fire(self,self._realParent, self._activeParent);
                        self:GetEventListener("DockExited"):Fire(v,v._realParent, v._activeParent);
                        hasinBounds[v._dev.__id] = nil;end;
                end;
            end; 
        end
    end);    
end

    -- local toolTip;
    local function bindContext()
        createClonedState(); 
        ToolTip.Offset = Vector2.new(-self._activeParent.AbsoluteSize.X/2,-self._activeParent.AbsoluteSize.Y/2 - 10)
        ToolTip:Show();
        DragStarted:Fire();
        -- print(Draggables.dockable);
        connectFramePositionChanged();
    end;

    local function unbindContext()
        if(ToolTip)then
            ToolTip:Hide();
            DragEnded:Fire();
        end;
        disconnectFramePositionChanged();
        -- toolTip:Hide();
    end;


    -- local ButtonDragSizeChanged_
    local firstdragrun = true;
    return {
        _Components = {
            Eventer = ButtonDrag;
        };
        ["Docks"] = function(v)
            if(v)then
                unbindContext();
                disconnectButtonEvents();
                Draggables.dockable[self._dev.__id] = self;
                Draggables.transmitters[self._dev.__id] = nil;
            else
                Draggables.dockable[self._dev.__id] = nil;
                Draggables.transmitters[self._dev.__id] = self;
            end
        end;
        ["Dragging"] = function(v)
            if(v)then
                bindContext();
            else
                unbindContext();
                if(firstdragrun)then firstdragrun=false;return;end;
                self:GetEventListener("Docked"):Fire(hasinBounds,totalinBounds);
                for _,x in pairs(hasinBounds) do
                    x:GetEventListener("DraggableDocked"):Fire(self,self._realParent,self._activeParent);
                end;
                hasinBounds = {};
                totalinBounds = 0;
            end
        end;
        ["AutoDragging"] = function(v)
            if(self.Docks)then return end;
            if(v)then
                connectButtonEvents();
            else
                disconnectButtonEvents();
            end
        end;
        ["Enabled"] = function(v)
            if(not v)then
                self.Dragging = false;
            end
        end;
        ["*Parent"] = function(p)
            self._realParent = p;
            if(p:IsA("Pseudo"))then
                p = p:IsA("BaseGui") and p:GetGUIRef() or (p:GET("_Appender") or p:GetRef());
            end;
            self._activeParent = p;
            ButtonDrag.Parent = p;
            
        end;
    };
end

return DraggableUI;