local Theme = require(script.Parent.Parent.Parent.Theme);

local Objective = {
	Name = "Objective";
	ClassName = "Objective";
    -- Header = "Objective";
    Text = "Deliver something...";
    Icon = "",
    Size = UDim2.new(1,0,0,0);
    AutomaticSize = Enum.AutomaticSize.Y;
    Expanded = true,
    -- Progress = -1;
    -- SupportsRBXUIBase = true

};
Objective.__inherits = {"BaseGui"}

function Objective:Destroy()
    if(self._activeNotifcationObject)then
        self._activeNotifcationObject:Dismiss();
        self._activeNotifcationObject = nil;
    end;
    self:GetRef():Destroy();
end;

function Objective:CreateObjectiveData(Text,Progress)
    local ObjectiveSelf = self;
    local App = self:_GetAppModule();
    local CustomClassService = App:GetService("CustomClassService");
    local _ODS = self:GET("_ODS");
    local ObjectiveDataClass = {
        Name = "ObjectiveData";
        ClassName = "ObjectiveData";
        Text = Text or "Do Objective";
        Progress = Progress or -1,
        -- ProgressColor3 = Theme.getCurrentTheme().Primary;
    }
    ObjectiveDataClass.__inherits = {"BaseGui"}

    function ObjectiveDataClass:_Render(App)
        local MainFrame = App.new("Frame",ObjectiveSelf);
        MainFrame.SupportsRBXUIBase = true;
        MainFrame.Name = "MainFrame";
        MainFrame.Size = UDim2.new(1);
        MainFrame.AutomaticSize = Enum.AutomaticSize.Y;
        local UIListLayout = Instance.new("UIListLayout", MainFrame:GetGUIRef());
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        local TextContent = App.new("Text",MainFrame);
        TextContent.SupportsRBXUIBase = true;
        TextContent.Size = UDim2.new(1);
        TextContent.TextWrapped = true;
        TextContent.TextXAlignment = Enum.TextXAlignment.Left;
        TextContent.AutomaticSize = Enum.AutomaticSize.Y;
        -- TextContent.Text = "This is some content";

        local ProgressBar = App.new("ProgressBar",MainFrame);
        -- ProgressBar.Name = 
        ProgressBar.Size = UDim2.new(1,0,0,10);
        ProgressBar.SupportsRBXUIBase = true;
        
        return {
            ["Progress"] = function(Value)
                if(Value >= 0)then
                    if(not ProgressBar.Visible)then ProgressBar.Visible = true;end;
                    ProgressBar.Value = Value;
                else
                    if(ProgressBar.Visible)then ProgressBar.Visible = false;end;
                end
            end;
            ["Text"] = function(Value)
                TextContent.Text =  Value;
            end;
            _Components = {
                ProgressBar = ProgressBar;
            }
        }
    end

    local c = CustomClassService:Create(ObjectiveDataClass);
    c.Parent = self;

    _ODS:Keep(c);

    return c;
end

function Objective:_Render(App)

    local ObjectiveDataServant = App.new("Servant");
    local Container = App.new("Accordion",self:GetRef());
    -- Container.Size = UDim2.new(1,0);
    -- Container.Text = "• Do Task"

    -- Container.SupportsRBXUIBase = true

    local ContentContainer = App.new("Frame",Container);
    ContentContainer.Name = "CONTENTCONTAINER";
    ContentContainer.SupportsRBXUIBase = true;
    ContentContainer.Size = UDim2.fromScale(1);
    ContentContainer.AutomaticSize = Enum.AutomaticSize.Y;
    -- ContentContainer
    -- local DefaultContent = 
    
	return {
        ["Text"] = function(v)
            Container.Text = "• "..v;
        end;
     
		_Components = {
            FatherComponent = ContentContainer:GetGUIRef();
            -- _Appender = Container:GetGUIRef();
            -- Text = TextContent;
            Accordion = Container;
            _ODS = ObjectiveDataServant;
        };
		_Mapping = {
            [Container] = {"Size","AnchorPoint","Position","Visible","AutomaticSize","Expanded","Icon"},
            -- [TextContent] = {"Text"}
        };
	};
end;


return Objective
