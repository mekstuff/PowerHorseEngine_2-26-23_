
-- local PowerHorseEngine = game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine");
-- local _LFModule = require(PowerHorseEngine.Util.POST.LOCALFILES[".LF"]);
-- local App = require(PowerHorseEngine);
-- local SerializationService = App:GetService("SerializationService");

-- local warn = function(...)
-- 	local toWarn = {...};
-- 	table.insert(toWarn,"[PowerHorseEngine][.LF]");
	
-- end

-- for i,v in pairs(_LFModule)do
-- 	--local SerialInfo = "(PHE[%w%d]+PHe%.)";
-- 	local PHeStart = v:find("PHE");
-- 	if(not PHeStart)then
-- 		warn("Corrupt Serial File Failed To Compile At Index ", i);
-- 	else
-- 		local SerialContent = v:sub(PHeStart,#v);
-- 		local Deserialized = (SerializationService:DeserializeTable(SerialContent));
	
-- 		if(Deserialized)then
-- 			if Deserialized.Parent and (Deserialized.Parent:FindFirstChild(Deserialized.Name) == nil) or Deserialized.Parent ==nil then
-- 				warn("Serial File May No Longer Exist In Studio. Name: ", Deserialized.Name, "ClassName: ",Deserialized.ClassName," Parent", Deserialized.Parent, "Index : ",i);
-- 			else
-- 				local new = App.new(Deserialized.ClassName);
-- 				Deserialized.Parent:FindFirstChild(Deserialized.Name):Destroy();
-- 				new:DeserializePropsAsync(Deserialized,true);
-- 			end
-- 		else
-- 			warn("Corrupted Serial File Failed To Compile At Index ",i);
-- 		end
-- 	end
	
-- end

