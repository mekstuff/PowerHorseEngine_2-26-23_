local module = {
	Name = "Name";
	ClassName = "ClassName";
};

--module.__

--//
function module:_Render()
	return {
		["Property"] = function(v)
			
		end,
		_Components = {};
		_Mapping = {};
	}
end


function module.new(service)
	local CustomClass = service:Create(module);
	return CustomClass;
end;

return module
