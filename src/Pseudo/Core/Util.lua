-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Tuesday, September 27 2022 @ 09:51:21
-- Main Source For Controlling Pseudo Components.

local module = {}
local App;
local Classes = script.Parent.Classes;
local Core = require(script.Parent);
local ModuleFetcher = require(script.Parent.Parent.Parent.Core.Providers.Constants.ModuleFetcher);
local ReplicationService = ModuleFetcher("ReplicationService",script.Parent.Parent.Parent.Core.Services);
local SerializationService = ModuleFetcher("SerializationService",script.Parent.Parent.Parent.Core.Services);

local IsRunning = game:GetService("RunService"):IsRunning();
local IsServer = game:GetService("RunService"):IsServer();

local ErrorService = ModuleFetcher("ErrorService",script.Parent.Parent.Parent.Core.Services);
local warn,error,message,assert = ErrorService.tossWarn, ErrorService.tossError, ErrorService.tossMessage, ErrorService.assert;

local function getIsComponentOf(x)
	return x.Name:match("^%$l_") or x.name:match("$_%$l");
end

local PseudoModule;
local function getPseudo(...:any):table
	if(not PseudoModule)then PseudoModule = require(script.Parent.Parent);end;
	return PseudoModule.getPseudo(...);
end

local CurrentlySupportedDATATYPES = {
	"string","boolean","number","UDim","UDim2","BrickColor","Color3",
	"Vector2","Vector3","NumberSequence","ColorSequence","NumberRange","Rect"
};

local readOnlyProperties = {"ClassName"};

-- Handles showing unknown datatypes as attributes
local function getStringValueOfUnknownDataType(Value:any,k:string):string|nil
	if(k and string.match(k, "^_"))then return nil;end;
	local str = "unknown";
	if(typeof(Value) == "Instance")then
		str = Value.ClassName;
	elseif(typeof(Value) == "function")then
		return nil;
	elseif(typeof(Value) == "EnumItem")then
		str = Value.Name;
	elseif(typeof(Value) == "table")then
		if(Value.ClassName)then
			if(Value.ClassName == "State")then
				if(typeof(Value.State) ~= "EnumItem")then
					return (Value.State);
				else
					return "Stateful "..k.." : "..tostring(Value.State);
				end
			end
		end
		pcall(function() --< Check for EnumType in pcall because PseudoElements don't contain EnumTypes.
			if(Value.EnumType)then
				str = Value.Name;
			end
		end);
	end;
	return "**"..str.."**";
end

--//
local function _getParent(v:any):Instance
	if(not v)then return nil;end;
	if(typeof(v) == "string" and v:match("^%*%*")) then
		return nil;
	end
	if(v:IsA("Instance"))then
		return v;
	else
		if(v._Components._Appender)then 
			return _getParent(v._Components._Appender);
		end;
		if(v:IsA("BaseGui"))then
			if(v:GetGUIRef())then return _getParent(v:GetGUIRef());end;
		end;
		return _getParent(v:GetRef())
	end
end;

local DefaultPseudoPropResponses = {
	["Name"] = function(Reference,v)
		Reference.Name = v;
	end,
	["Parent"] = function(Reference,v,me)
		Reference.Parent = _getParent(v);
	end,
	["Archivable"] = function(Reference,v)
		Reference.Archivable = v;
	end,
}
--
local function getClassModule(Class:string):any
	return ModuleFetcher(Class,Classes,nil,true);
end;
--
local function getModuleProps(Module:table,Sheet:string):nil
	for property,value in pairs(Module)do		
		if(Sheet[property] == nil and not string.match(property, "^__%a"))then
			Sheet[property]=value;
		end
	end;
	
end

--> Main Rendering for :_Render
local function renderAsync(renderMap:table,prop:string,value:any,_ReferenceInstance:Instance,QuickMap:table?, me:any):nil
	if(typeof(value) == "string" and value:match("^%*%*"))then
		return;
	end;

	--> handles _Mapping
	if(QuickMap)then
		for Instance_,Map in pairs(QuickMap)do
			if(typeof(Map) == "table" and table.find(Map, prop))then
				local ran,error_ = pcall(function()
					Instance_[prop]=value;
				end);if(not ran)then
					warn("Mapping Failed: \""..prop.."\" Error?: "..error_);

				end
			end
		end;
	end;

	--> main render
	if(renderMap and renderMap[prop])then
		if(string.match(prop, "^_"))then return end;
		renderMap[prop](value,prop);
	else
		if(DefaultPseudoPropResponses[prop])then
			DefaultPseudoPropResponses[prop](_ReferenceInstance,value,me);
		end;
		if(renderMap)then 
			local stringed = "*"..prop;
			if(renderMap[stringed])then
				renderMap[stringed](value,prop);
			end
		end;
	end;
end;

local CachedObjectProps = {};

local function _organizeuseEffectHookDependencies(self,dependencies)
	return {
		[self] = dependencies;
	}
end;

local function _getDependencyUID(dependencytable)
	if(#dependencytable <= 0)then return "uid-all";end;
	-- local index = 0;
	local uids = {};
	for _,x in pairs(dependencytable) do
		local str;
		if(typeof(x) == "string")then
			if(not table.find(uids,x))then str = x;end;
		elseif(typeof(x) == "table")then
			if(x.IsA and x:IsA("Pseudo"))then
				str = x.__id;
			else
				str = tostring(x);
			end
		end;
		if(str)then table.insert(uids,str);end;
	end;
	
	--> sorts the table so the string uid will be the same even if we list dependencies in different orders
	table.sort(uids, function(a,b)
		return a < b
	end)

	local str = table.concat(uids,"-");
	uids = nil;
	return str;
end;

local function createPseudoObject(Object:table, DirectParent:Instance?, DirectProps:table?,...:any?):any
	local Pseudo = {};	
	local propSheet = {};	
	local attributelocked = {};
	
	if(CachedObjectProps[Object.ClassName])then
		for a,b in pairs(CachedObjectProps[Object.ClassName])do
			propSheet[a]=b;
		end
	else
		getModuleProps(Object, propSheet);
	end
	
	if(Object.__inherits)then
		table.insert(Object.__inherits, "Pseudo");
	else
		Object.__inherits = {"Pseudo"}
	end;
	
	local ClassNamesContainer = {};

	--> Inheritance
	for _,v in pairs(Object.__inherits)do
		local _mod = getClassModule(v);
		if(not table.find(ClassNamesContainer, _mod.ClassName))then
			table.insert(ClassNamesContainer, _mod.ClassName);
		end;
		if(_mod)then getModuleProps(_mod, propSheet);end;
	end;


	if(DirectProps)then
		getModuleProps(DirectProps,propSheet)
	end;
	
	
	local renderMap;
	local quickMap;

	--<Direct Overhaul Arguments
	if(DirectParent)then
		propSheet["Parent"]=DirectParent;
	end;

	--> Creates a Reference for class, should use Folders.	
	local _ReferenceInstance = Instance.new(propSheet["_referenceobjecttype"]);

	--> Generates a unique id for every component
	local id = propSheet["ClassName"]..(Core.generateRanCod(6));

	--> _pseudoid inside reference to identify folder as Pseudo
	local idString = Instance.new("StringValue",_ReferenceInstance);
	idString.Name = "_pseudoid";
	idString.Value = id;

	--> Core properties and functions of Util. Can be considered properties and functions of "Pseudo" but hidden.
	propSheet["_classes"] = ClassNamesContainer; --<Support IsA()
	propSheet["_referenceInstance"] = _ReferenceInstance;
	propSheet["_dev"] = {};
	propSheet["__id"] = id;
	propSheet["_dev"]["__id"] = id;
	propSheet["_dev"]["args"]= ...;
	propSheet["_Signals"]={};
	propSheet["_Components"] = {};
	propSheet["_ChangedSignals"] = {};
	propSheet["_children"] = {};
	propSheet["__lockedProperties"] = {};
	propSheet["_stateControlledProperties"] = {};
	propSheet["_getCurrentPropSheetState"] = function(ignoreFunctions:boolean?,ignoreHiddenProps:boolean?,serializeUnsupportedROBLOXProps:boolean?,onlykeys:boolean?):table
		local x = {};
		for a,b in pairs(propSheet)do
			if not( (ignoreHiddenProps and string.match(a,"^_")) or (ignoreFunctions and typeof(b) == "function"))then
				local v;
				if(serializeUnsupportedROBLOXProps and not onlykeys)then
					if(typeof(b) == "table")then
						if(b["_isEnumObject?_$"])then
							local Serialized = SerializationService:SerializeTable({b});
							v = "pheSerialized-"..Serialized
						elseif(b._dev and b._dev.__id)then
							local Serialized = SerializationService:SerializeTable({b});
							v = "pheSerialized-"..Serialized
						else
							v = Pseudo[a]
						end;
						else v = Pseudo[a]
					end
				else
					v = Pseudo[a];
				end;
				if(onlykeys)then
					 table.insert(x,a)
				else
					x[a]=v;
				end;
			end
		end;
		return x;
	end;

	--> Replication initiaition
	local ReplicationStatus = {ReplicateObject = false;ReplicateProperties = false;};
	if(propSheet["_REPLICATEDTOCLIENTS"] and IsRunning and IsServer and propSheet["_CONSTRCUTED__BY___CREATE____FUNC"] ~= true)then
		ReplicationStatus.ReplicateObject = true;
		ReplicationStatus.ReplicateProperties = true;
	end;
	if(ReplicationStatus.ReplicateObject)then propSheet["_REPLICATED"] = id;end;

	local _allowPassForAny = {};
	local _renderCausedByState = false;

	--> Core metatable
	setmetatable(Pseudo, {
		__tostring = function(...)
			if(propSheet.__metamethods and propSheet.__metamethods["__tostring"])then
				return propSheet.__metamethods["__tostring"](...)
			end;
			return propSheet.Name;
		end,
		__call = function(...)
			if(propSheet.__metamethods and propSheet.__metamethods["__call"])then
				return propSheet.__metamethods["__call"](...)
			end;
			return _ReferenceInstance;
		end,
		__concat = function(value,table)
			if(propSheet.__metamethods and propSheet.__metamethods["__concat"])then
				return propSheet.__metamethods["__concat"](value,table)
			end;
			return value..tostring(Pseudo);
		end,
		__eq = function(a,b)
			if(propSheet.__metamethods and propSheet.__metamethods["__eq"])then
				return propSheet.__metamethods["__eq"](a,b)
			end;
			if(typeof(a) == "table" and a.IsA and a:IsA("Pseudo") and typeof(b) == "table" and b.IsA and b:IsA("Pseudo"))then
				if(a:IsA("State") and b:IsA("State"))then
					return a.State == b.State;
				else
					return a._dev.__id == b._dev.__id;
				end
			elseif(typeof(a) == "table" and a.IsA and a:IsA("State"))then
				return a.State == b;
			elseif(typeof(b) == "table" and b.IsA and b:IsA("State"))then
				return b.State == a;
			end;
			return a == b;
		end,
		
		__index = function(t,k)
		--> Parent indexed
			if(k == "Parent")then
				local ReferenceInstanceParent = _ReferenceInstance.Parent;
				if(ReferenceInstanceParent)then
					if(getIsComponentOf(ReferenceInstanceParent))then
						ReferenceInstanceParent = ReferenceInstanceParent.Parent;
					end;

					if(ReferenceInstanceParent and ReferenceInstanceParent:FindFirstChild("_pseudoid"))then
						ReferenceInstanceParent = getPseudo(ReferenceInstanceParent["_pseudoid"].Value);
					end;
				end
				return ReferenceInstanceParent;
		--> Archivable indexed
			elseif(k == "Archivable")then
				return _ReferenceInstance.Archivable
			end;

		--> If index is a State Pseudo, it will return the actual State of the State, not the State Pseudo. Expection is if the variable is hidden with _	
			if(propSheet["_stateControlledProperties"][k])then
				local state = propSheet["_stateControlledProperties"][k].state;
				if(k:match("^_"))then
					return state;
				else
					return state();
				end
			end
			
			--> If the property is not yet set, for example it's still in an "**any" state, it will return nil
			if(propSheet[k] ~= nil)then
				if(typeof(propSheet[k]) == "string" and propSheet[k]:match("^%*%*"))then return nil;end;
				return propSheet[k];
			end;
		
			--> Checks if the Pseudo has a signal of index 
			if(propSheet._Signals[k])then
				return propSheet._Signals[k];
			end;

			--> Checks if the Pseudo has a shared signal of index (no longer used, will remove)
			if(propSheet._SharedSignals[k])then
				return propSheet._SharedSignals[k];
			end;

			--> RInstance index
			if(propSheet.ClassName == "RInstance")then
				if(not propSheet[k])then
					if(propSheet._InstanceObject)then
						return propSheet._InstanceObject[k];
					end
				end
			end

			--> Checks for if there's a child component named index (only check for Pseudo's)
			local _ffc = Pseudo:FindFirstChild(k,nil,true);
			if(_ffc)then
				return _ffc;
			end

			--> If it's a hidden property, then just return the value that's set
			if(string.match(k,"^_"))then return propSheet[k];end;
		
			--> Errors if the index is not a member
			error(tostring(k).." is not a valid memmber of "..tostring(propSheet.ClassName).." / "..tostring(propSheet.Name))
		end,

		
		__newindex = function(t,k,v)

		--> Handles if the value is a state, uses it's effect if it is
			if(typeof(v) == "table" and v.IsA and v:IsA("State"))then
				if(propSheet["_stateControlledProperties"][k])then
					if(propSheet["_stateControlledProperties"][k].con)then
						propSheet["_stateControlledProperties"][k].con:Destroy();
					end;
					propSheet["_stateControlledProperties"][k] = nil;
				end;
				propSheet["_stateControlledProperties"][k] = {state = v};
				local con = v:useEffect(function(n)
					_renderCausedByState = true;
					Pseudo[k] = n; 
				end);
				propSheet["_stateControlledProperties"][k].con = con;
				_renderCausedByState = true;
				v = v();
			end
			
		--> Handles if Pseudo IsA RInstance, will apply changes to its instance object instead
			if(Pseudo.ClassName == "RInstance")then
				if(not propSheet[k])then
					if(Pseudo._InstanceObject)then
						Pseudo._InstanceObject[k]=v;
						return;
					end
				end
			end;

		--> If there was a previous state affect Pseudo, Destroy its use effect
			if(not _renderCausedByState and propSheet["_stateControlledProperties"][k])then
				if(propSheet["_stateControlledProperties"][k].con)then
					propSheet["_stateControlledProperties"][k].con:Destroy();
				end;
				propSheet["_stateControlledProperties"][k] = nil;
			end
			_renderCausedByState = false;

		--> If the value is the same then don't proceed		
			if(propSheet[k] == v)then
				return;
			end;
			
		
		--> For locked properties
			if(propSheet.__lockedProperties[k])then
				return warn(k.." is locked and cannot be modified at this time.");
			end
	
		--> Attempting to assign signal
			if(propSheet._Signals[k])then
				warn("PHESignals Cannot Be Assigned. Try AddEventListener(str Listener, bool Creating, signal BindingTo)")
				return;	
			end;
			
		--> If it's a hidden property then set it with no checks.
			if(string.match(k, "^_"))then
				propSheet[k]=v;
				return;
			end;

			--> Parents are rendered outside checks.
			if(k == "Parent")then
				renderAsync(renderMap,k,v,_ReferenceInstance,quickMap,Pseudo);
				return;
			end
			
			--> main new index
			if(propSheet[k] ~= nil)then
				
				--> Prevent assigning global readOnly properties
				if(table.find(readOnlyProperties, k))then warn(k.." cannot be assigned to.") return end;
				
				if (typeof(propSheet[k]) ~= typeof(v) and k ~= "Parent" or (typeof(propSheet[k]) == "string" and propSheet[k]:match("^%*%*")))then
					local allowpass = false;
					local _afterStr =  ", got "..typeof(v).." ["..tostring(k).."] "..tostring(propSheet.ClassName).." / "..tostring(propSheet.Name);
					if(typeof(propSheet[k]) == "string" and propSheet[k]:match("^%*%*"))then
						local type_ = propSheet[k]:gsub("**","");
						if(typeof(v) == type_ or type_ == "any")then
							_allowPassForAny[k] = true;
							allowpass = true;
						else
							if(typeof(v) == "table" and v.ClassName)then
								if(v.ClassName == type_)then
									allowpass = true;
								end
							end
						end
					end
				if(not allowpass and not _allowPassForAny[k])then
					local typeexpected = typeof(propSheet[k]);
					if(typeexpected == "string")then
						if(propSheet[k]:match("^%*%*"))then
							typeexpected = propSheet[k]:gsub("**","");
						end
					end
					error(typeexpected.." expected".._afterStr);
					return;
					end;
				end;

				--> Updates propsheet
				propSheet[k]=v;
			
				--> Triggers render
				renderAsync(renderMap,k,v,_ReferenceInstance, quickMap, Pseudo,propSheet);

				--> Replicate Change
				if(game:GetService("RunService"):IsServer()  and ReplicationStatus.ReplicateProperties)then
					--> Do not replicate hidden properties
					if(not string.match(k,"^_"))then
						ReplicationService.ReplicatePseudo(Pseudo);
					end;
				end;
				
				--> Updating the attribute
				if(not attributelocked[k])then
					if(propSheet[k])then --<Make sure property exists
						attributelocked[k]=true;
						if(table.find(CurrentlySupportedDATATYPES, typeof(v)))then
							_ReferenceInstance:SetAttribute(k,v);
						else
							_ReferenceInstance:SetAttribute(k, getStringValueOfUnknownDataType(v,k))
						end
						attributelocked[k]=nil;
					end;
				end;

			--> Property does not exist, cannot assign 
			else
				error(tostring(k).." is not a valid memmber of !! "..tostring(propSheet.ClassName).." / "..tostring(propSheet.Name))
			end;
			
			--> Fire Any Signal Property Events;
			if(propSheet._ChangedSignals["all"])then
				propSheet._ChangedSignals["all"]:Fire(k,v);
			end
			if(propSheet._ChangedSignals[k])then
				propSheet._ChangedSignals[k]:Fire(v);
			end;
			
		end,
	});

	
	--> Initializing
	module.__Pseudos[id]=Pseudo; --> Stores the Pseudo so .getPseudo works
	if(not App)then
		App = require(script.Parent.Parent.Parent);
	end;

	if(Pseudo._Render)then
		local renderResults = Pseudo:_Render(App)
		ErrorService.assert(typeof(renderResults) == "table" or typeof(renderResults) == "function","table or function expected from :_Render method, got "..typeof(renderMap))
			--> Static Rendering or table Rendering
			if(typeof(renderResults) == "table")then
				renderMap = renderResults;
				--< Passing QuickMapping
				if(renderMap._Mapping)then quickMap = renderMap._Mapping;end;
				--< Passing _Components;
				if(renderMap._Components)then Pseudo._Components = renderMap._Components;end;
				
				if(renderMap._AfterRender)then --after renders are ran on a different thread
					local septhread = coroutine.create(function()
						renderMap._AfterRender();
					end)coroutine.resume(septhread);
				end;
				--< Initial Property Rendering (map)
				for prop,v in pairs(propSheet) do
					if(typeof(v) == "table" and v.IsA and v:IsA("State"))then
						Pseudo[prop]=v;
					else
						renderAsync(renderMap,prop,v,_ReferenceInstance,quickMap,Pseudo);	
					end
				end;
				if(renderMap["_All"])then
					renderMap["_All"]();
				end;

			elseif(typeof(renderResults) == "function")then
				--> Functional Render
				renderMap = nil;
				renderAsync(nil,"Name",Pseudo.Name,_ReferenceInstance,quickMap,Pseudo);	
				renderAsync(nil,"Parent",Pseudo.Parent,_ReferenceInstance,quickMap,Pseudo);	
				local StateLibrary = App:Import("State");
				local hooks = {};
				--> useEffect hook
				hooks.useEffect = function(callback:any,dependencies:table?)
					if(not Pseudo._dev._useEffectState)then 
						Pseudo._dev._useEffectState = StateLibrary("nil");
					end;
					dependencies = _organizeuseEffectHookDependencies(Pseudo,dependencies or Pseudo._getCurrentPropSheetState(true,true,nil,true))
					return Pseudo._dev._useEffectState:useEffect(callback,dependencies)
				end;
				--> useMapping hook
				hooks.useMapping = function(props:table,dependencies:table):nil
					if(not quickMap)then
						quickMap = {};
						for _,dependency in pairs(dependencies) do
							if(not quickMap[dependency])then
								quickMap[dependency] = {};
							end;
						end
					end;
					
					for _,g in pairs(props) do
						for dep,x in pairs(quickMap) do
							if(not table.find(x,g))then
								table.insert(x,g);
								renderAsync(nil,g,Pseudo[g],_ReferenceInstance,quickMap,Pseudo)
							else
								warn(debug.traceback(("Double call on useMapping hook dependency: %s || %s"):format(dep.Name,g),2))
							end
						end
					end;

					-- print(quickMap);
					-- assert(res and typeof(res) == "table", ("table expected from useMapping hook, got %s"):format(typeof(res)));
					
				end;
				--> returning a nested function will use the useEffect hook so this function is called whenever any component is changed
				local nestedRenderResults = renderResults(hooks);
				if(typeof(nestedRenderResults) == "function")then
					hooks.useEffect(nestedRenderResults,nil)
				end
			end;
			
	end;
	
	--> Creating Prop Attributes;
	for prop,val in pairs(propSheet) do
		if(not string.match(prop, "^_")) then
			if(prop == "Parent" or prop == "Archivable")then
			else
				if(table.find(CurrentlySupportedDATATYPES, typeof(val)) )then
					_ReferenceInstance:SetAttribute(prop,val);
				else
					_ReferenceInstance:SetAttribute(prop, getStringValueOfUnknownDataType(val,prop))
				end
			end	
		end;
	end;
	
	--> Updating Property for Pseudo if Attribute was changed without __newindex 
	_ReferenceInstance.AttributeChanged:Connect(function(Attribute,x)
		if(attributelocked[Attribute])then  return; end;
		attributelocked[Attribute]=true;
		Pseudo[Attribute] = _ReferenceInstance:GetAttribute(Attribute);
		attributelocked[Attribute]=nil;
	end);
	
	--> Initiates the Pseudo Class
	Pseudo:_pseudoInit();
	
	--> Creates ReplicationToken for Pseudo
	if(IsServer and ReplicationStatus.ReplicateObject)then	
		ReplicationService.newReplicationToken(Pseudo);
	end;

	return Pseudo,id;
end;

--> Store Pseudos in a weak table
module.__Pseudos = {};
setmetatable(module.__Pseudos, {__mode="kv"})

--> For creating custom classes
function module.Create(Class:table,Parent:any?,...:any?):any
	assert(Class.ClassName, "Tried to create class without a ClassName.");
	assert(Class._Render or Class.Render, "Tried To Create Class with no form of rendering. All Components require a :_Render method");
	--[[
	if(getClassModule(Class.ClassName))then
		error("Cannot 'Create' Class With ClassName Of "..Class.ClassName.." Because This Class Is A CoreClass");
		return;
	end;
	]]
	local Pseudo, returnedID = createPseudoObject(Class,Parent,{
		_CONSTRCUTED__BY___CREATE____FUNC = true;
	},...);
	return Pseudo, returnedID;
end;
--//
local function handleClassDoesntExist(ClassName:string):nil
	error("Unable to create Pseudo \""..ClassName.."\". \""..ClassName.."\" is not a valid Pseudo Class");
end;
local function handleClassBlocked(ClassName:string):nil
	error("\""..ClassName.."\" cannot be created but only read or inherited.");
end;

-- Used by .new Constructor
function module.Produce(n:string,Parent:Instance?,...:any?):any
	local ClassModule = getClassModule(n);
	
	if(not ClassModule)then handleClassDoesntExist(n);return end;
	if(ClassModule.__PseudoBlocked)then handleClassBlocked(n);return end;

	local Pseudo, returnedID = createPseudoObject(ClassModule,Parent,nil,...);
	
	return Pseudo, returnedID;
end;


return module;