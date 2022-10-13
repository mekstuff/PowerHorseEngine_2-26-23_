local module = {}

-- Util.__Pseudos = {};
-- local Total = 0;

local Util = require(script.Core:WaitForChild("Util"));

function module.new(Pseudo:string,Parent:Instance?,...:any)
	assert(typeof(Pseudo) == "string", ("String expectd for Pseudo name, got %s. {%s}"):format(typeof(Pseudo), tostring(Pseudo)));
	local name,type_ = unpack(Pseudo:split("@"));
	local Pseudo, id = Util.Produce(name,Parent,type_,...);
	
	if(Pseudo and id)then
		-- Pseudos[id]=Pseudo;
		-- Total+=1;
		
		pcall(function()
			if(Pseudo._init)then Pseudo:_init();end;
		end)
		
	end;

	if(name == "RInstance" and type_)then
		Pseudo.Instance = type_;
	end;
	
	return Pseudo
end;

function module._create(...)
	local Pseudo,id = Util.Create(...);
	if(Pseudo and id)then
		-- Pseudos[id]=Pseudo;
		-- Total+=1;
	end;
	return Pseudo
end

function module.getPseudos()
	return Util.__Pseudos;
end

function module.getPseudo(id)
	return Util.__Pseudos[id];
end;

function module:GetPseudoAmount()
	-- return Total;
end

function module.removePseudoTrace(id)
	-- task.delay(20, function() --> Delays by x seconds so that it can be reference within :Destroy for x seconds
		if(Util.__Pseudos[id])then
			Util.__Pseudos[id]=nil;
		end;
	-- end)
end

return module
