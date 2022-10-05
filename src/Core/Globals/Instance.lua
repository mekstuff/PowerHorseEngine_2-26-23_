local instance = {}

function instance.new(InstanceName:string,Parent:Instance,...)
	
	if(Parent and typeof(Parent) == "string")then
		if(Parent == "Instance")then
			return Instance.new(InstanceName,...);
		else
			return require(script.Parent.Pseudo).new(InstanceName,...);
		end
	end
	
	local PseudoRun,PseudoResults = pcall(function(...)
		return require(script.Parent.Pseudo).new(InstanceName,Parent,...);
	end);
	if(PseudoRun)then return PseudoResults;end;
	local InstanceRun,InstanceResults = pcall(function(...)
		return Instance.new(InstanceName,Parent,...);
	end);
	if(InstanceRun)then return InstanceResults;end;
	
	error(InstanceName.." is not a valid Pseudo or Instance. => Pseudo Error: "..PseudoResults.." || => Instance Error: "..InstanceResults);
end;

return instance
