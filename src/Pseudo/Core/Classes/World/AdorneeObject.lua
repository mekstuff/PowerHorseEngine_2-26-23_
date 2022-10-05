local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local AdorneeObject = {
	Name = "AdorneeObject";
	ClassName = "AdorneeObject";
};
AdorneeObject.__inherits = {}

function AdorneeObject:GetAdornee(from)
	from = from or self.Parent;
	
	if(from)then
		local t;
		if(from:IsA("Model"))then
			t = from.PrimaryPart or from:FindFirstChildWhichIsA("BasePart",true);
		elseif(from:IsA("BasePart"))then
			t = from;
		end;
		return t;
	else
		print("No 'from'")
	end
end

function AdorneeObject:_Render(App)
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return AdorneeObject
