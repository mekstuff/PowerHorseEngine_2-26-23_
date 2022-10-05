local ErrorService = require(script.Parent.Parent.Services.ErrorService);
local Pseudo = require(script.Parent.Parent.Parent.Pseudo);

local module = {}

local Keywords = {"Children","Class"};



function module.new(Component,Properties)
	
	if(typeof(Component) ~= "string")then return ErrorService.tossError("["..script.Name.."] Component expected to be a string")end;
	if(typeof(Properties) ~= "table")then return ErrorService.tossError("["..script.Name.."] Second argument expected to be an array")end;
	
	
	local newComponent = Pseudo.new(Component)
	
	for PropName,PropValue in pairs(Properties)do
		if PropName and not(table.find(Keywords, PropName))then
			if(typeof(PropValue) == "function")then
				--//Connect to event
				if(not newComponent._dev._StackConnections) then
					newComponent._dev._StackConnections = {};
				end
				newComponent._dev._StackConnections[PropName] = newComponent[PropName]:Connect(function(...)
					return PropValue(newComponent,...)
				end)
			else
				newComponent[PropName]=PropValue;
			end
			
		end;
	end

	if(Properties.Children)then
		for compName,prop in pairs(Properties.Children)do
			local comp = prop.Class;
			if(not prop.Parent)then prop.Parent = newComponent;end;
			if(not prop.Name)then prop.Name = compName;end;
			module.new(comp,prop);
		end
	end
	
	
	return newComponent;
	
end

return module
