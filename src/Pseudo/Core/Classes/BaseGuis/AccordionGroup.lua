--[=[
	@class AccordionGroup
]=]
local AccordionGroup = {
	Name = "AccordionGroup";
	ClassName = "AccordionGroup";
	CellSize = UDim2.new(1,0,0,35);
	CellPadding = UDim2.new(0);
	HorizontalAlignment = Enum.HorizontalAlignment.Center;
	VerticalAlignment = Enum.VerticalAlignment.Top;
	FillDirection = Enum.FillDirection.Vertical;
	SortOrder = Enum.SortOrder.LayoutOrder;
	
	--StartCorner = Enum.StartCorner.TopLeft 
};
AccordionGroup.__inherits = {"BaseGui"}

--[=[
	@return Accordion
]=]
function AccordionGroup:AddAccordion(Text:string?,Icon:string?)
	local App = self:_GetAppModule();
	local RespectGrid = Instance.new("Frame",self:GetGUIRef());
	--RespectGrid.AutomaticSize = Enum.AutomaticSize.XY;
	--RespectGrid.Size = UDim2.new(0);
	
	local Accordion = App.new("Accordion",RespectGrid);
	Accordion.Size = UDim2.fromScale(1,1);
	local RandomFrame = App.new("Frame",Accordion);
	RandomFrame.Size = UDim2.new(1,0,0,70);
	RandomFrame.BackgroundColor3 = Color3.fromRGB(217, 255, 78);
	return Accordion
end;
--[=[]=]
function AccordionGroup:Add(...:any)
	return self:AddAccordion(...)
end
--//

function AccordionGroup:_Render(App)
	
	local Frame = Instance.new("Frame",self:GetRef());
	local UIGrid = Instance.new("UIGridLayout",Frame);

	return {
		["Property"] = function(Value)
			
		end,
		_Components = {
			FatherComponent = Frame;	
		};
		_Mapping = {
			[Frame] = {
				"Position","AnchorPoint","Size"
			};
			[UIGrid] = {
				"CellSize","CellPadding","HorizontalAlignment","VerticalAlignment","FillDirection","SortOrder",
				--"StartCorner"
			}	
		};
	};
end;


return AccordionGroup
