local consts = {}

function consts.readObjectValue(obj,val)
	if(obj.ClassName == "IntValue" or obj.ClassName == "NumberValue")then return tonumber(val);end;
	if(obj.ClassName == "String")then return tostring(val);end;
	if(obj.ClassName == "BoolValue")then
		if(val:lower() == "true")then return true else return false;end;
	end;
end;

function consts.getPlayerFromName(name)
	return game:GetService("Players"):FindFirstChild(name)
end;

return consts;
