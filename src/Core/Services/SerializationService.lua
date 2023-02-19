
--[=[
	@class SerializationService
]=]
local SerializationService = {}
local ErrorService = require(script.Parent.ErrorService);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);


--//Introduce new string serialization method. 17/05/2022

local CacheIterations = {};
local iterations = {
	["v1"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/ !@#$%^&*()?.>,<;:']}[{}]_-\\|=5",
	--["v1"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/ !@#$%^&*()?.>,<;:'[{}]_-\\|=5",	
	--["v2"] = "@#$%^&*()?.>,<;:']astuvwxyz012345bcdefghijklmnopqr6789/ABCDEFGHIJKLMNOPQRSTUVWXYZ !}[{}]_-\\|=8",
	--["v1"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/ =5",
}


local function converIterationToTable(version_)
	if(CacheIterations[version_])then return CacheIterations[version_];end;
	
	local chars = {};
	for chars_loop_index = 1,#iterations[version_] do
		table.insert(chars, string.sub(iterations[version_],chars_loop_index,chars_loop_index)) ;
	end;
	CacheIterations[version_]=chars;
	return chars;
end

--//
local function deserializeString(String,steps,iterationtable)
	
	local s = "";
	for i = 1,#String do
		local Character = string.sub(String,i,i);
		local CharacterInIterationIndex = table.find(iterationtable,Character);
	
		local TargetIndex = CharacterInIterationIndex-steps;
		local TargetCharacter;
		
		if(TargetIndex < 0)then
			TargetCharacter = iterationtable[#iterationtable+TargetIndex];
		else
			TargetCharacter = iterationtable[TargetIndex];
		end
		s = s..TargetCharacter;
	end;
	return s;
end
--//
local function serializeString(String,steps,iterationtable)
	local s = "";
	for i = 1,#String do
		local Character = string.sub(String,i,i);
		
		local CharacterInIterationIndex = table.find(iterationtable,Character);
	
		local TargetIndex = CharacterInIterationIndex+steps;
		local TargetCharacter;
		if(TargetIndex > #iterationtable)then

			TargetCharacter = iterationtable[TargetIndex-#iterationtable]
		
			
		else
			TargetCharacter = iterationtable[TargetIndex];
		end

	s = s..TargetCharacter;
	end;
	return s;
end;
--//
local function getPropsString(Props)
	if(not Props)then return;end;
	local propsx = {};
	for key,value in pairs(Props) do
		local s = SerializationService:_ConvertToString(key).."=="..SerializationService:_ConvertToString(value);
	
		table.insert(propsx,s);
		
	end;
	
	return table.concat(propsx,"|");
end
--//
local function stringToTable(string_,isProps,capture)
	

	if(isProps)then

		string_ = string_:gsub("{",""):gsub("}","");
		
		local propsSplit = string_:split("|");
	
		
		local t = {};

		for _,v in pairs(propsSplit)do
			local propvalsplit = v:split("=="); 
			
			
			local prop = stringToTable(propvalsplit[1]);
			local value = stringToTable(propvalsplit[2]);
			table.insert(t,{
				key = prop,
				value = value;
			})
		end;
		return t;
	else
		capture = capture or "(%a+)\\=([%w%s%.%-|]%,%+)";
		local t = {};
		for prop,value in string.gmatch(string_,capture)do
			t[prop]=value;
		end;
		return t;
	end
end;

local function GetTableForm(String:string)

	local ObjectData,ObjectProps;

	local split = String:split("\\");
	ObjectData = split[1];ObjectProps = split[2];
	
	if(ObjectProps)then
		ObjectProps = ObjectProps:split("props={","")[2]
	end;
	
	ObjectData = stringToTable(ObjectData);
	ObjectProps = ObjectProps and stringToTable(ObjectProps,true);
	
	for _,v in pairs(ObjectProps)do
		for _,x in pairs(v) do
			for q,z in pairs(x)do
				x[q]=z:gsub("|",",");
			end
		end
	end;

	return {
		Data = ObjectData;
		Props = ObjectProps;
	}
	
end

--[=[
	@private
]=]
function SerializationService:_FromConvertedString(s:string)
	return GetTableForm(s)
end;

--[=[
	@private
]=]
function SerializationService:_ConvertToString(Object:any,Type:any,Properties:any,initiated:any):string

	Type = Type or typeof(Object);
	local ObjectType = typeof(Object);
	Properties = getPropsString(Properties);
	
	local vAsString = tostring(Object):gsub(",","|");
	
	if(Type == "table")then
		if not(vAsString:match("Enumeration"))then
			if(not initiated)then
				--local serialized = (SerializationService:SerializeTable(Object))
				
				--vAsString = "awesome capture!@#$%^&*()?.>,<;:"
				--print("got it")
				--vAsString = "!";
				--vAsString = serialized;
				--print(Object)
			end
		end
	end
	
	local s = "value={"..vAsString.."},type={"..Type.."},typeof={"..ObjectType.."}";

	if(ObjectType == "Instance")then		
		s = s..",fullname={"..Object:GetFullName().."}";
	end;
	
	if(Properties)then
		s = s.."\\props={"..Properties.."}";
	end;

	return s;
end


--[=[]=]
function SerializationService:SerializeAsync(ToSerialize:any,...:any):string
	--local t="unknownSRC"
	local src = "s-with:"
	if(typeof(ToSerialize) == "table")then
		local s = SerializationService:SerializeTable(ToSerialize);
		--print(s);
		s = src.."table-"..s;
		return s;
	end
end;

--[=[]=]
function SerializationService:DeserializeAsync(ToDeserialize:any,...:any):{[any]:any}
	local t,end_ = ToDeserialize:match("s-with:(%w+)()");
	local str = (ToDeserialize:sub(end_+1,#ToDeserialize));
	if(t == "table")then
		return SerializationService:DeserializeTable(str);		
	end
end;

--[=[]=]
function SerializationService:Serialize(...:any) return SerializationService:SerializeAsync(...);end;
--[=[]=]
function SerializationService:Deserialize(...:any) return SerializationService:DeserializeAsync(...);end;

--[=[]=]
function SerializationService:SerializeTable(Table:{[any]:any},...:any)	
	return SerializationService:SerializeTableNew(Table,...);
end;
--//
local floatMatch = "(%-*%d.*)";
local function determineObject(data)
	
	local transformedValue;
	
	if(data.type == "boolean")then
		if(data.value == "true")then transformedValue = true;else transformedValue=false;end;
	elseif(data.type == "string")then
		transformedValue = data.value;
	elseif(data.type == "number")then
		transformedValue = tonumber(data.value);
	elseif(data.type == "Color3")then
		--"(%d.*),(%d.*),(%d.*)");
		local r,g,b = data.value:gsub(" ",""):match(floatMatch..","..floatMatch..","..floatMatch)
	
		transformedValue = Color3.new(r,g,b)
	elseif(data.type == "Vector2")then
		--local x,y = data.value:gsub(" ",""):match("(%d.*),(%d.*)");
		local x,y =  data.value:gsub(" ",""):match(floatMatch..","..floatMatch);
		transformedValue = Vector2.new(x,y)
	elseif(data.type == "Vector3")then
		local x,y,z = data.value:gsub(" ",""):match(floatMatch..","..floatMatch..","..floatMatch)
		transformedValue = Vector3.new(x,y,z)
	elseif(data.type == "BrickColor")then
	
		--local x,y,z = data.value:gsub(" ",""):match(floatMatch..","..floatMatch..","..floatMatch)
		transformedValue = BrickColor.new(data.value)
	elseif(data.type == "CFrame")then
		transformedValue = CFrame.new(table.unpack(data.value:gsub(" ",""):split(",")));
		--local x,y,z = data.value:gsub(" ",""):match(floatMatch..","..floatMatch..","..floatMatch)
		--transformedValue = CFrame.new(Vector3.new(0))
	elseif(data.type == "UDim")then
		local x,y = data.value:gsub(" ",""):match(floatMatch..","..floatMatch);
		transformedValue = UDim.new(x,y)
	elseif(data.type == "UDim2")then
		local xs,xo,ys,yo = table.unpack(data.value:gsub("{",""):gsub("}",""):split(","))
		transformedValue = UDim2.new(xs,xo,ys,yo)
	elseif(data.type == "Instance")then	
		
		local isClient = game.Players.LocalPlayer and true;
		local Directories = data.value:split(".");
		
		if ((#Directories) == 1) then
			local s,r = pcall(function()
				transformedValue = isClient and game:WaitForChild(Directories[1]) or (game[Directories[1]]);
			end);
			if(not s)then ErrorService.tossWarn("Internal Error with Deserializing Directory... "..r);end;
		else
			local lastAncestry;
			for _,v in pairs(Directories)do
				if(lastAncestry)then
					lastAncestry = isClient and lastAncestry:WaitForChild(v,300) or lastAncestry:FindFirstChild(v);
					if(not lastAncestry)then
						ErrorService.tossWarn("Can't complete directory ["..data.fullname.."]. failed at "..v.." because it no longer exists in the dictories path.");
						break;
					end
				else
					--print(Directories, data)
					lastAncestry = game[Directories[1]];
				end;
			end;
			transformedValue = lastAncestry;
			if(data.isScript)then
				--//Handle script;
				if(require(script.Parent.PluginService):IsPluginMode())then
					if(transformedValue)then
						if not(transformedValue.ClassName == data.isScript)then
							transformedValue = Instance.new(data.isScript);
							--//Parent to path;
						end
					else
						transformedValue = Instance.new(data.isScript);
						--//Parent to path;
					end;
					transformedValue.Source = [[
						--PHe @ 25/07/2022 -->lanzo\n
					]].."\n\n"..data.scriptSrc;
				end
			end
		end;
	elseif(data.type == "EnumItem")then
		local s = data.value:split(".");
		transformedValue = Enum[s[2]][s[3]];
		--print(transformedValue)
	elseif(data.type == "table")then
		if(data.value:find("Enumeration"))then
			local split = data.value:split(".");
			local enumType,enumValue = split[2],split[3];
			transformedValue = Enumeration[enumType][enumValue];
			--local EnumType
			--local enumType = data.value:split(" ");
			--local enumType,
		else
			-->Decrypt
			transformedValue = SerializationService:DeserializeTable(data.value)
		end
	end;
	return transformedValue;
end
--//
function createObjectFromTableData(data)
	return determineObject(data.key),determineObject(data.value);
end;
--//
function createAllObjectsFromProps(props)
	local t = {}
	for index,v in pairs(props)do
	
		local key,value = createObjectFromTableData(v);
		t[key or index]=value;
	end;
	return t;
end

--[=[]=]
function SerializationService:DeserializeTable(...:any)
	return SerializationService:DeserializeTableNew(...);
end
--//
--function SerializationService:SerializeS
--//
function SerializationService:SerializeString(String:string,SerializationVersion:string?):string
	SerializationVersion = SerializationVersion or "v1";	
	local iterationSteps = string.sub(iterations[SerializationVersion],#iterations[SerializationVersion]);
	local iterationtable = converIterationToTable(SerializationVersion);
	
	local x = (serializeString(String,iterationSteps,iterationtable));
	local f = "PHE"..SerializationVersion.."PHE"..x;
	--f = SerializationService:ShrinkString(f);
	return f;
end;

function SerializationService:DeserializeString(String:string):string
	
	local versionType,versionNumber = string.match(String, "^PHE(%l+)(%d+)PHE");
	local version_ = versionType and versionNumber and versionType..tostring(versionNumber);

	--return
	if(not version_)then
		return ErrorService.tossWarn("Can't Deserialize String Because The Version Couldn't Be Determined.\n\n"..String);
	end
	
	local s = string.gsub(String, "PHE"..version_.."PHE","")
	local iterationSteps = string.sub(iterations[version_],#iterations[version_]);
	local iterationtable = converIterationToTable(version_);
	
	return(deserializeString(s,iterationSteps,iterationtable));

end;

--//New serialization Method

local function toSerialTable(t)
	local v = t;
	local _typeof = typeof(t);
	local isScript;
	local scriptSrc;
	
	if(typeof(t) ~= "string")then
		if(typeof(t) == "table")then
		
			if(t["_isEnumObject?_$"])then 
				v = tostring(t)
			else
				--return serialized version;
				local serialized = SerializationService:SerializeTableNew(t);
				v=serialized;
				--v = SerializationService:SerializeTableNew(t);
			end
		elseif(typeof(t) == "Instance")then
			v = t:GetFullName();
			
			if(t:IsA("ModuleScript") or t:IsA("Script") or t:IsA("LocalScript"))then
				local PluginService = require(script.Parent.PluginService);
				if(PluginService:IsPluginMode())then
					ErrorService.tossWarn( ("Attempting to serialize script '%s', this is an experimental feature."):format(t.Name));
					isScript = t.ClassName;
					scriptSrc = t.Source;
				else
					ErrorService.tossWarn(("Attempted to serialize script '%s', Serializing script source can only be done by plugins and command line (if the original script is removed, deserializing will fail, and a empty script may be added)"):format(t.Name))
				end
			end;
		else
			v = tostring(t);
		end
	end
	return {
		type = _typeof;
		value = v;
		isScript = isScript;
		scriptSrc = scriptSrc;
	}
end

local function fromTableToString(t)
	local contents = {};
	for key,value in pairs(t) do
		table.insert(contents, {
			key = toSerialTable(key);
			value = toSerialTable(value);
		})
	end;
	
	local function getAsText(table_)
		local str_ = "";
		local index=0;
		for key,value in pairs(table_)do
			local concat = key.."==="..value;
			str_ = str_.."!>"..concat.."<!";
		end;
		return str_;
	end
	
	local function fetchTargetTextOfCurrent(v)
		return getAsText(v.key).."===="..getAsText(v.value)

	end;
	
	local str="";
	for _,v in pairs(contents)do
		local string_ = fetchTargetTextOfCurrent(v);
		str = str.."[["..string_.."]]";
		
	end
	return str;
end;

local function fromStringToTable(str)
	local contentSplitCapture = "%[%[([%w%p%s]-)%]%]";
	local keyValueCapture = "!>(.-)===(.-)<!";
	local finalTable = {};
	for x in str:gmatch(contentSplitCapture) do
		local split = x:split("====");
		local key,value = split[1],split[2];
	
		
		local key_,value_ = {},{};
	
		
		for a,b in key:gmatch(keyValueCapture)do
			key_[a]=b;
		end;for a,b in value:gmatch(keyValueCapture)do
			value_[a]=b;
		end	;
		finalTable[determineObject(key_)] = determineObject(value_)
		--[[
		table.insert(finalTable,{
			key = determineObject(key_);
			value = determineObject(value_);
		})
		]]
	end;
	return finalTable;
end;

function SerializationService:SerializeTableNew(Table)
	return SerializationService:toBinary(fromTableToString(Table));
end;

function SerializationService:DeserializeTableNew(String)
	return fromStringToTable(SerializationService:fromBinary(String))
	--return SerializationService:fromBinary(fromStringToTable(String));
end;

--[=[]=]
function SerializationService:toBinary(str:string):string
	local binstr = {};
	for i,char in ipairs(str:split("")) do
		local asBinary = "";
		local asByte = char:byte();
		while(asByte > 0)do
		    asBinary = tostring(asByte%2)..asBinary;
			asByte = math.modf(asByte/2);
		end;
		table.insert(binstr, string.format("%.4d",asBinary))
	end;
	return table.concat(binstr," ")
end
--
function SerializationService:fromBinary(str:string):string
	local fstr = "";
	for i, Binary in ipairs(str:split(" ")) do
		local Byte = tonumber(Binary, 2);
		if(Byte)then
			fstr ..= string.char(Byte)
		end
	end;
	return fstr
end

return SerializationService
