local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local ViewportRespectiveFrame = {
	Name = "Name";
	ClassName = "ClassName";

};
ViewportRespectiveFrame.__inherits = {"GUI","BaseGui","Frame"};


function ViewportRespectiveFrame:_Render(App)
	
	local Frame = App.new("Frame");
	
	return {
		["Position"] = function(Value)
			
		end,
		_Components = {
			FahterComponent = Frame;
			
		};
		_Mapping = {
			[Frame]={
				"Size","AnchorPoint","BackgroundTransparency","BackgroundColor3",
				"ZIndex","Visible","AutomaticSize","BorderSizePixel";
			}	
		};
	};
end;


return ViewportRespectiveFrame
