local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Dialog = {
	Name = "Dialog";
	ClassName = "Dialog";
	--AnchorPoint = Vector2.new(.5,.5);
	--Position = UDim2.fromOffset(.5,.5);
	Image = "";
	Header = "";
	Body = "";
	AnchorPoint = Vector2.new(.5,1);
	Position = UDim2.new(.5,0,1,-20);
	Size = UDim2.new(0,550,0,120);
};
Dialog.__inherits = {"BaseGui"}


function Dialog:_Render(App)
	
	local Container = App.new("Frame",self:GetRef())
	--Container.Size = UDim2.new(0,550,0,200);
	--Container.Position = Vector2.new(.5,.5)
	
	local LeftContainer = App.new("Frame",Container);
	LeftContainer.Size = UDim2.new(.85,0,1,0);
	LeftContainer.BackgroundTransparency = 1;
	
	local LeftContainerPadding = Instance.new("UIPadding",LeftContainer:GetGUIRef());
	LeftContainerPadding.PaddingLeft = UDim.new(0,5);
	
	local Image = App.new("Image",LeftContainer);
	Image.Size = UDim2.new(0,60,1,0);
	Image.ScaleType = Enum.ScaleType.Fit;
	Image.BackgroundTransparency = 1;
	
	local HeaderSection = App.new("Text",LeftContainer);
	HeaderSection.Size = UDim2.new(1,0,0,30);
	HeaderSection.Text = "Header Goes Here...";
	HeaderSection.TextTruncate = Enum.TextTruncate.AtEnd;
	HeaderSection.TextXAlignment = Enum.TextXAlignment.Left;
	HeaderSection.BackgroundTransparency = 1;
	
	local BodySectionContainer = App.new("ScrollingFrame",LeftContainer);
	BodySectionContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	BodySectionContainer.Position = UDim2.new(0,0,0,HeaderSection.Size.Y.Offset);
	BodySectionContainer.Size = UDim2.new(1,0,1,-BodySectionContainer.Position.Y.Offset);
	BodySectionContainer.BackgroundTransparency = 1;
	
	local BodySection = App.new("Text",BodySectionContainer);
	BodySection.Size = UDim2.fromScale(1,1);
	BodySection.Text = "Body Goes Here";
	BodySection.TextWrapped = true;
	BodySection.TextXAlignment = Enum.TextXAlignment.Left;
	BodySection.TextYAlignment = Enum.TextYAlignment.Top;
	BodySection.BackgroundTransparency = 1;
	
	local RightContainer = App.new("Frame",Container);
	RightContainer.AnchorPoint = Vector2.new(1);
	RightContainer.Position = UDim2.new(1);
	RightContainer.Size = UDim2.new(.25,0,1,0);
	RightContainer.BackgroundTransparency = 1;
	
	local RightContainerButtons = App.new("ScrollingFrame",RightContainer);
	RightContainerButtons.Size = UDim2.new(1,-5,1,-5);
	RightContainerButtons.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	RightContainerButtons.AnchorPoint = Vector2.new(.5,.5);
	RightContainerButtons.Position = UDim2.fromScale(.5,.5);
	RightContainerButtons.BackgroundTransparency = 1;
	
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {};
		_Mapping = {
			[Container] = {"Size","AnchorPoint","Position"};
		};
	};
end;


return Dialog
