local module = {}

module.ClassStructures = {};

function module:AddClassStructure(ClassName)
	if(not module.ClassStructures[ClassName]) then
		module.ClassStructures[ClassName] = {};
	end;
end;

--//
function module:AddComponentToClassStructure(ClassName, Component, ClassStructure)
	
	local class = ClassStructure or Component.ClassStructure;
	
	if(not class)then
		if(not ClassStructure)then
			print("Component Does Not Have  A Class Structure ID Property");
			return;
		else
			class = ClassStructure;
		end
	end;
	
	if(not module.ClassStructures[ClassName]) then
		module:AddClassStructure(ClassName);
	end;
	
	module.ClassStructures[ClassName][Component._dev.__id] = {
		Component = Component;
		ClassStructureID = class;
	};
end;
--//
function module:RemoveComponentFromClassStructure(ClassName, Component)
	local id = Component;

	if(typeof(Component) == "table")then id = Component._dev.__id;end;
	module.ClassStructures[ClassName][id] = nil;
	--module.ClassStructures[ClassName]
end

--//
function module:GetAllComponentsOfClass(ClassName, returnComponents)
	if(returnComponents)then
		local x = {};
		for _,g in pairs(module.ClassStructures[ClassName])do
			table.insert(x, g.Component);
		end;
		return x;
	end
	return module.ClassStructures[ClassName];
end

--//
function module:GetAllComponentsOfStructureID(ClassStructure, StructureID)
	if(not StructureID)then return end;
	local ClassStructure = module.ClassStructures[ClassStructure];
	--print(ClassStructure)
	local x = {};
	if(ClassStructure) then
		for _,v in pairs(ClassStructure) do
			if(v.ClassStructureID == StructureID)then
				table.insert(x,v.Component);
			end
		end
	end;
	return x;
end;

--//
function module:GetComponentClassFromRelativeID(Component)
	local id = Component;
	if(typeof(Component) == "table")then id = Component._dev.__id;end;
	
	for class,v in pairs(module.ClassStructures) do
		if(v[id])then
			return class,v[id].ClassStructureID
		end
	end
end


--//

return module
