
local ObjectiveGroup = {
	Name = "ObjectiveGroup";
	ClassName = "ObjectiveGroup";
    AutomaticSize = Enum.AutomaticSize.Y;
    Size = UDim2.new(0,400,0,0);
    GroupName = "Objective Group";
    GroupIcon = "";
    Expanded = true;

};
ObjectiveGroup.__inherits = {"BaseGui"}

function ObjectiveGroup:_Render(App)

    local ObjectivesServant = App.new("Servant");

    self._dev.__ObjectiveServant = ObjectivesServant;

    local Container = App.new("Accordion",self:GetRef());
    -- Container.Text = "Objective 1:"
    -- local Header = App.new("Text", Container);
    -- Header.Text = "Objectives:";
    -- Header.Size = UDim2.new(1,0,0,30);
    -- Header.TextScaled = true;

    local ContentContainer = App.new("NotificationGroup", Container);
    ContentContainer.SortOrderAdjustment = App:GetGlobal("Enumeration").Adjustment.Top;
    ContentContainer.Position = UDim2.new(0);
    ContentContainer.AnchorPoint = Vector2.new(0);
    ContentContainer:GetGUIRef().AutomaticSize = Enum.AutomaticSize.Y;
    ContentContainer.Size = UDim2.new(1,0,0,0);
    -- ContentContainer.AutomaticSize = Enum.AutomaticSize.Y;
    -- ContentContainer.BackgroundColor3 = Color3.fromRGB(0,0,0);
    -- ContentContainer.BackgroundTransparency = .5;

    -- local UIListLayout = Instance.new("UIListLayout", ContentContainer:GetGUIRef());

	
	return {
		["GroupName"] = function(Value)
			Container.Text = Value;
		end,
		["GroupIcon"] = function(Value)
			Container.Icon = Value;
		end,
		_Components = {
            FatherComponent = ContentContainer:GetGUIRef();
            ContentContainer = ContentContainer;
        };
		_Mapping = {
            [Container] = {"Size","AnchorPoint","Position","Visible","AutomaticSize","Expanded","BackgroundColor3"}
        };
	};
end;

function ObjectiveGroup:AddObjective(id,Text)
    local App = self:_GetAppModule();
    local newObject = App.new("Objective");if(Text)then newObject.Text = Text;end;
    local n = self:GET("ContentContainer"):SendNotification(newObject);
    newObject._activeNotifcationObject = n;
    self._dev.__ObjectiveServant:Keep(newObject);
    return newObject;
end;

function ObjectiveGroup:RemoveObjective()
    
end


return ObjectiveGroup
