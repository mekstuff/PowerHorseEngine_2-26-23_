local m = {
    Name = "ObjectiveGroup",
    ClassName = "ObjectiveGroup",
	Size = UDim2.fromOffset(300,300)
};
m.__inherits = {"BaseGui", "GUI"}

local TodoItemGroupClass = {
	Name = "TodoItemGroup";
	ClassName = "TodoItemGroup";
	Text = "Todo Group";
	-- AllowTextEdit = true;
	Color = Color3.fromRGB(255, 255, 255);
	Expanded = true;
	Completed = false;
};
--// Proxies for group
function TodoItemGroupClass:CreateObjectiveGroup(...)
    return self:CreateTodoGroup(...)
end
--
function TodoItemGroupClass:CreateObjective(...)
    return self:CreateTodoItem(...);
end;

--//
function TodoItemGroupClass:CreateTodoGroup(EditOnCreate)
	return self._self:CreateTodoGroup(EditOnCreate,self:GET("ContentContainer"))
end

function TodoItemGroupClass:CreateTodo(...)
	return self:CreateTodoItem(...);
end

function TodoItemGroupClass:CreateTodoItem(...)
	local Accordion = self:GET("Accordion");
	local ContentContainer = self:GET("ContentContainer");
	local Item,Accordion_ = self._self:CreateTodoItem(...,ContentContainer);
	-- Accordion.Expanded = true;
	return Item,Accordion_;
end

function TodoItemGroupClass:_Render()

	local App = self:_GetAppModule();
	local Theme = App:GetGlobal("Theme").getCurrentTheme();
	local Enumeration = App:GetGlobal("Enumeration");
	local Accordion = App.new("Accordion");

	local ContentContainer = App.new("ScrollingFrame",Accordion);
	ContentContainer.AnchorPoint = Vector2.new(.5,.5)
	ContentContainer.Position = UDim2.new(.5,0,.5,0);
	ContentContainer.Size = UDim2.new(1,-10,1,-10);
	ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	ContentContainer.BackgroundTransparency = 1;

	local UIList = Instance.new("UIListLayout",ContentContainer:GetGUIRef());
	UIList.Padding = UDim.new(0,5);
	UIList.SortOrder = Enum.SortOrder.Name;

	Accordion.SupportsRBXUIBase = true;
	--Accordion.BackgroundColor3 = Color3.fromRGB(255,255,255);
	Accordion.BackgroundTransparency = .85;
	--Accordion.TextSize = Accordion.TextSize + 5;
	Accordion.Size = UDim2.new(1,0,0,300);
	-- Accordion.Expanded = false;
	Accordion.Parent = self._mainScroller;

	local AccordionButton = Accordion:GetButton();
	AccordionButton.TextAdjustment = Enumeration.Adjustment.Left;
	AccordionButton.RichText = true;
	Accordion.Icon = "ico-keyboard_arrow_right"

--[[
	Accordion.ButtonPressed:Connect(function()
		Accordion.Expanded = not Accordion.Expanded;
		if(Accordion.Expanded)then
			--Accordion.BackgroundColor3 = self.Color;
			Accordion.Icon = "ico-keyboard_arrow_down";
		else
			Accordion.Icon = "ico-keyboard_arrow_right"
			--Accordion.BackgroundColor3 = Color3.fromRGB(255,255,255);
		end
	end);
]]

	local RightSideButtons = App.new("Frame",Accordion:GetButton())
	RightSideButtons.Name = "RightSideButtons";
	RightSideButtons.AnchorPoint = Vector2.new(1,.5);
	RightSideButtons.Position = UDim2.new(1,-5,.5);
	RightSideButtons.Size = UDim2.new(.85,0,1,-15);
	RightSideButtons.BackgroundTransparency = 1;

	local UIGrid = Instance.new("UIGridLayout",RightSideButtons:GetGUIRef());
	UIGrid.CellSize = UDim2.fromOffset(30,30);
	--UIGrid.CellSize = UDim2.new(0,RightSideButtons:GetGUIRef().AbsoluteSize.Y,1,0);
	UIGrid.VerticalAlignment = Enum.VerticalAlignment.Center;
	UIGrid.StartCorner = Enum.StartCorner.TopRight;
	UIGrid.HorizontalAlignment = Enum.HorizontalAlignment.Right;
	UIGrid.CellPadding = UDim2.new(0,1);


	local CreateTodoInGroupButton = App.new("Button", RightSideButtons);
	CreateTodoInGroupButton.SupportsRBXUIBase = true;
	CreateTodoInGroupButton.BackgroundTransparency = 1;
	CreateTodoInGroupButton.Icon = "ico-add_circle";
	CreateTodoInGroupButton.IconAdjustment = Enumeration.Adjustment.Center;
	CreateTodoInGroupButton.Text = "";
	--CreateTodoInGroupButton.BackgroundTranspare
	
	CreateTodoInGroupButton.MouseButton1Down:Connect(function()
		self:CreateTodoItem(ContentContainer);
	end)

	local CheckAllInGroupButton = App.new("Button", RightSideButtons);
	CheckAllInGroupButton.Name = "CheckAllInGroup";
	CheckAllInGroupButton.SupportsRBXUIBase = true;
	CheckAllInGroupButton.BackgroundTransparency = 1;
	CheckAllInGroupButton.IconAdjustment = Enumeration.Adjustment.Center;
	local CheckAllInGroupButton_IconImage = CheckAllInGroupButton:GET("Icon"):GET("Image");
	CheckAllInGroupButton.Icon = "ico-library_add_check";
	CheckAllInGroupButton.Text = "";
	--CheckAllInGroupButton_IconImage.ImageColor3 = Theme.Text;

	CheckAllInGroupButton.MouseButton1Down:Connect(function()
		self.Completed = not self.Completed;
	end);

	return{
		["Color"] = function(v)
			Accordion.BackgroundColor3 = v;
		end,
		["Text"] = function(v)
			Accordion.Text = v;
		end,
		["Completed"] = function(Value)
			if not(Value)then
				CheckAllInGroupButton_IconImage.ImageColor3 = Theme.Text;
				Accordion.Name = "A_TodoGroup";
				AccordionButton.Text = self.Text;
				--AccordionButton.Icon = "";
			else
				CheckAllInGroupButton_IconImage.ImageColor3 = Theme.Primary;
				Accordion.Name = "B_TodoGroup";
				AccordionButton.Text = "<s>"..self.Text.."</s>";
				--AccordionButton.Icon = "ico-check";
			end;
			for _,v in pairs(ContentContainer:GetChildren(true))do
				if(v:IsA("Accordion"))then
					local Checkbox = (v:GetButton():FindFirstChild("Checkbox"))
					
					if(Checkbox)then 
						Checkbox.Toggle = Value;
					else
						local A = v:FindFirstChild("A",nil,true);
						local RightSideButton = A:FindFirstChild("RightSideButtons",nil,true);
						local CheckAllInGroup_Btn = RightSideButtons:FindFirstChild("CheckAllInGroup",nil,true);
						
						--print(CheckAllInGroup_Btn.MouseButton1Down:Fire())
						--CheckAllInGroup:GetEventListener("MouseButton1Down"):Fire(true);
					end
				end
			end
		end,

		_Components = {
			Accordion = Accordion;
			ContentContainer = ContentContainer;
		}
	}
end
--//
local TodoItemClass = {
	Name = "TodoItem";
	ClassName = "TodoItem";
	Text = "Todo";
	-- Information = "Information...";
	Color = Color3.fromRGB(255,255,255);
	AllowTextEdit = true;
	AllowInfoEdit = true;
	Expanded = true;
	Completed = false;
};

function TodoItemClass:_Render()
	local App = self:_GetAppModule();
	-- local Theme = App:GetGlobal("Theme");
	local Frame = App.new("Frame");

	local Accordion = App.new("Accordion",self:GetRef());
	-- Accordion.Expanded = false;
	Accordion.Size = UDim2.new(1,0,0,0)
	Accordion.AutomaticSize = Enum.AutomaticSize.Y;
	Accordion.SupportsRBXUIBase = true;
--[[
	local Information = App.new("Text",Accordion);
	Information.Size = UDim2.new(1);
	Information.AutomaticSize = Enum.AutomaticSize.Y;
	-- Information.TextColor3 = Theme
	Information.TextWrapped = true;

]]

	local AccordionButton = Accordion:GetButton();

	AccordionButton.RichText = true;
	--AccordionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	--AccordionButton.BackgroundTransparency = .9;	

	local Checkbox = App.new("Checkbox",AccordionButton);
	Checkbox.AutoToggle = false;
	Checkbox.AnchorPoint = Vector2.new(1,.5);
	Checkbox.Position = UDim2.new(1,-5,.5);
	Checkbox.Size = UDim2.fromOffset(AccordionButton:GetGUIRef().AbsoluteSize.Y-15,AccordionButton:GetGUIRef().AbsoluteSize.Y-15);
	Checkbox.Toggle = self.Completed;
	Accordion.BackgroundTransparency = .85;
	Checkbox.Toggled:Connect(function(state)
		--self.Completed = state;
		if(state)then
			Accordion.Name = "B_Accordion";
			Accordion.BackgroundTransparency = .93;	
			AccordionButton.Text = "<s>"..self.Text.."</s>";
			AccordionButton.Icon = "ico-check";
		else
			Accordion.Name = "A_Accordion";
			Accordion.BackgroundTransparency = .85;	
			AccordionButton.Text = self.Text.." ";
			AccordionButton.Icon = "";
		end
	end);
--[[
	Accordion.ButtonPressed:Connect(function()
		Accordion.Expanded = not Accordion.Expanded
	end)
]]
	return {
		["Expanded"] = function(v)
			Accordion.Expanded = v;
		end,
    --[[
		["Information"] = function(v)
			Information.Text = v;
		end,
    ]]
		["Color"] = function(v)
			Accordion.BackgroundColor3 = v;
		end,
		["Text"] = function(v)

			Accordion.Text = v;
		end,
		["Completed"] = function(v)
			Checkbox.Toggle = v;
			--self.
		end,
		_Components = {
			Accordion = Accordion;
			-- Information = Information;
			_Appender = Accordion;
		}
	};
end
--//
function m:CreateTodoGroup(EditOnCreate,Parent)
	local App = self:_GetAppModule();
	local CustomClassService = App:GetService("CustomClassService");

	local TodoGroupItem = CustomClassService:Create(TodoItemGroupClass)
	TodoGroupItem._self = self;
	TodoGroupItem.Text = "Todo Group"

	local Accordion = TodoGroupItem:GET("Accordion");

	TodoItemClass.Parent = self:GetRef();
	Parent = Parent or self._mainScroller;
	Accordion.Parent = Parent;
	return TodoGroupItem,Accordion;
end
--//
function m:CreateObjective(...)
    return self:CreateTodoItem(...);
end
--//
function m:CreateObjectiveGroup(...)
    return self:CreateTodoGroup(...);
end
--//
function m:CreateTodoItem(EditOnCreate,Parent)
	local App = self:_GetAppModule();
	local CustomClassService = App:GetService("CustomClassService");

	local TodoItem = CustomClassService:Create(TodoItemClass)
	TodoItem.Text = "Todo Item";

	local Accordion = TodoItem:GET("Accordion");

	TodoItem.Parent = self:GetRef();
	Parent = Parent or self._mainScroller;
	Accordion.Parent = Parent;

	return TodoItem,Accordion;
end;

function m:_Render()
	local App = self:_GetAppModule();
	-- local Background = App.new("Frame",self:GetRef());
	-- Background.BackgroundColor3 = App:GetGlobal("Theme").getCurrentTheme().Background;
	-- Background.Size = UDim2.fromScale(1,1);

	local Scroller = App.new("ScrollingFrame",self:GetRef())
	Scroller.BackgroundTransparency = 1;
	Scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	local UIList = Instance.new("UIListLayout",Scroller:GetGUIRef());
	UIList.Padding = UDim.new(0,5)
	self._mainScroller = Scroller;

		
	-- Scroller.Size = UDim2.new(1,0,1,0);
	-- self._Background = Background;
    return {
		_Mapping = {
			[Scroller] = {"AutomaticSize","Visible","Position","AnchorPoint","Size","Rotation","BackgroundColor3","BackgroundTransparency"}
		},
		_Components = {
			FatherCOmponent = Scroller;
		}
    }
end;


return m;