local Theme = _G.Theme.getCurrentTheme();

local module = {
	Name = "TestButton";
	ClassName = "TestButton";
	BackgroundColor3 = Theme.Primary;
	Size = UDim2.fromOffset(120,60);
};


--//
function module:_Render()
	local App = self:_GetAppModule();
	local Button = App.new("Button",self:GetRef());

	
	return {
		["Property"] = function(v)
			
		end,
		_Components = {};
		_Mapping = {
			[Button] = {
				"Size","BackgroundColor3"
			}	
		};
	}
end


function module.new(service)
	local CustomClass = service:Create(module);
	return CustomClass;
end;

return module
