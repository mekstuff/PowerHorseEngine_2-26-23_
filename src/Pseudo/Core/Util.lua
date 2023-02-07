-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Tuesday, September 27 2022 @ 09:51:21

--[=[
	@class LanzoCoreUtil
	@private
	Main Source For Controlling Pseudo Components.
]=]
local LanzoCoreUtil = {}
local App;
local Classes = script.Parent.Classes;
local Core = require(script.Parent)::any;
local ModuleFetcher = require(script.Parent.Parent.Parent.Core.Providers.Constants.ModuleFetcher)::any;
local Flags = require(script.Parent.Parent.Parent.Util.Flags);
-- local ReplicationService = ModuleFetcher("ReplicationService",script.Parent.Parent.Parent.Core.Services); --> We use :Replicate on Pseudo's now instead. Deprecated 11/27/2022
local SerializationService = ModuleFetcher("SerializationService",script.Parent.Parent.Parent.Core.Services);

local IsRunning = game:GetService("RunService"):IsRunning();
local IsServer = game:GetService("RunService"):IsServer();

local ErrorService = ModuleFetcher("ErrorService",script.Parent.Parent.Parent.Core.Services);
local warn,error,assert = ErrorService.tossWarn, ErrorService.tossError, ErrorService.assert;

local function getIsComponentOf(x)
	return x.Name:match("^%$l_") or x.name:match("$_%$l");
end

local PseudoModule;
local function getPseudo(...:any):any
	if(not PseudoModule)then 
		PseudoModule = require(script.Parent.Parent)::any;
	end;
	return PseudoModule.getPseudo(...);
end;

local readOnlyProperties = {"ClassName"};

-- Handles showing unknown datatypes as attributes
local function getStringValueOfUnknownDataType(Value:any,k:string):string|nil
	if(k and string.match(k, "^_"))then return nil;end;
	local str = typeof(Value) or "unknown";
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
local function _getParent(v:any):Instance|nil
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
	["Parent"] = function(Reference,v)
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
local function getModuleProps(Module:{},Sheet:any,force:boolean?):nil
	for property,value in pairs(Module)do	
		if(force)then
			Sheet[property] = value;
		else
			if(Sheet[property] == nil and not string.match(property, "^__%a"))then
				Sheet[property]=value;
			end
		end;
	end;
	
end

--> Main Rendering for :_Render


local function renderAsync(renderMap:table?,prop:string,value:any,_ReferenceInstance:Instance,QuickMap:table?, me:any):nil
	if(typeof(value) == "string" and value:match("^%*%*"))then
		return;
	end;

	--> handles _Mapping
	if(QuickMap)then
		for Instance_,Map in pairs(QuickMap) do
			if(typeof(Map) == "table")then
				for _,x in pairs(Map) do
					if(typeof(x) == "string")then
						if(x == prop)then
							local s,r = pcall(function()
								Instance_[prop] = value;
							end);
							if(not s)then
								warn(("[QuickMap] Failed Applying Property Value \"%s\" on Item \"%s\". ERROR: %s"):format(prop,tostring(Instance_),r));
							end;
						end;
					--[[
						for key,value mapping 
						["mycustomtextprop"] = "text"
					]]
					elseif(typeof(x) == "table")then
						if(x.mp == prop)then
							local s,r = pcall(function()
								Instance_[x.p] = value;
							end);
							if(not s)then
								warn(("[QuickMap] Failed Applying Property Value \"%s\" on Item \"%s\". ERROR: %s"):format(prop,tostring(Instance_),r));
							end;
						end
					else
						error(("Something is wrong with your mapping source! %s"):format(tostring(Instance_)));
					end
				end;
			end
		end
	end
	--[[
	if(QuickMap)then
		for Instance_,Map in pairs(QuickMap)do
			if(typeof(Map) == "table")then
				for _,x in pairs(Map) do
					if(typeof(x) == "table")then
						print("Found Table");
					end
				end
				if(table.find(QuickMap, prop))then
					local ran,error_ = pcall(function()
						Instance_[prop]=value;
					end);
					if(not ran)then
						warn("Mapping Failed: \""..prop.."\" Error?: "..error_);
					end
				end
			end
		end;
	end;
	]]

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
			if(not table.find(uids,x))then 
				str = x;
			end;
		elseif(typeof(x) == "table")then
			if(x.IsA and x:IsA("Pseudo"))then
				str = x.__id;
			else
				str = tostring(x);
			end
		end;
		if(str)then
			table.insert(uids,str);
		end;
	end;
	
	--> sorts the table so the string uid will be the same even if we list dependencies in different orders
	table.sort(uids, function(a,b)
		return a < b
	end)

	local str = table.concat(uids,"-");
	uids = nil;
	return str;
end;

local function _typecheck_check(_type:any,value:any,ClassesAreTypes:boolean?)
	--[[

	if(not targetValueHasIsA)then
		print(targetValue);
		-- print(typeof(targetValue) == typeof(x))
	else
		print("Target is an instance")
		print(x,targetValue);
		-- if(targetValue:IsA())
	end
	print(typeof(targetValue));
	if(typeof(targetValue) == x)then
		return true;
	end;
	if(ClassesAreTypes and targetValueHasIsA)then
		if(targetValue:IsA(x))then
			return true;
		end
	end;
	return false;
	]]
	local typeoftype,typeofvalue = typeof(_type),typeof(value);
	local typeIsInstanceObject,valueIsInstanceObject
	if(typeoftype == "Instance" or (typeoftype == "table" and _type._dev))then
		typeIsInstanceObject = true;
	end;
	if(typeofvalue == "Instance" or (typeofvalue == "table" and value._dev))then
		valueIsInstanceObject = true;
	end;
	if(not typeIsInstanceObject and not valueIsInstanceObject)then
		return typeoftype == typeofvalue
		-- return _type == typeofvalue
	else
		--> In the case where Instance = "Instance"
		if(typeof(_type) == typeof(value) and not valueIsInstanceObject)then
			return true;
		end
		-- print(typeIsInstanceObject,valueIsInstanceObject)
		if(typeIsInstanceObject)then
			if(_type:IsA(valueIsInstanceObject and value.ClassName or value))then
				return true;
			end
		else
			if(value:IsA(_type))then
				return true;
			end
		end
	end
end;

local function _typecheck(supportedtypes:{string|Instance|any},targetValue:any,ClassesAreTypes:boolean?)
	for _,x in ipairs(supportedtypes) do
		local check = _typecheck_check(x,targetValue,ClassesAreTypes);
		if(check)then
			return check;
		end
	end
	return false;
	--[[
	local targetValueHasIsA;
	if(ClassesAreTypes)then
		if(typeof(targetValue) == "Instance")then
			targetValueHasIsA = true;
		elseif(typeof(targetValue) == "table" and targetValue._dev)then
			targetValueHasIsA = true;
		end
	end
	if(typeof(supportedtypes) == "table")then
		for _,x in pairs(supportedtypes) do
			if(_typecheck_check(targetValue,x,targetValueHasIsA))then
				return true;
			end
		end;
	else
		print("Here");
		return _typecheck_check(targetValue,supportedtypes,targetValueHasIsA);
	end

	return false;
	]]
	-- table.find(Pseudo.__typecheckinglist[k], typeof(v))
end;

local function createPseudoObject(Object:{[any]:any}, DirectParent:Instance?, DirectProps:{[any]:any}?,...:any?):any
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

	--> force Direct props
	if(DirectProps)then
		getModuleProps(DirectProps,propSheet,true)
	end;

	--> Inheritance
	for _,v in pairs(Object.__inherits)do
		local _mod = getClassModule(v);
		if(not table.find(ClassNamesContainer, _mod.ClassName))then
			table.insert(ClassNamesContainer, _mod.ClassName);
		end;
		if(_mod)then
			getModuleProps(_mod, propSheet);
		end;
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
	local idString = Instance.new("StringValue");
	idString.Name = "_pseudoid";
	idString.Value = id;
	idString.Parent = _ReferenceInstance;

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
	propSheet["_getCurrentPropSheetState"] = function(ignoreFunctions:boolean?,ignoreHiddenProps:boolean?,serializeUnsupportedROBLOXProps:boolean?,onlykeys:boolean?):{}
		local x = {};
		for a,b in pairs(propSheet)do
			if not( (ignoreHiddenProps and string.match(a,"^_")) or (ignoreFunctions and typeof(b) == "function"))then
				local v;
				if(serializeUnsupportedROBLOXProps and not onlykeys)then
					if(typeof(b) == "table")then
						if(b["_isEnumObject?_$"] or (b._dev and b.__dev.__id))then
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
	if(ReplicationStatus.ReplicateObject)then 
		propSheet["_REPLICATED"] = id;
	end;
	
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
		
		__index = function(_,k)
		--> Parent indexed
			if(k == "Parent")then
				local ReferenceInstanceParent = _ReferenceInstance.Parent;
				if(ReferenceInstanceParent)then
					if(getIsComponentOf(ReferenceInstanceParent))then
						ReferenceInstanceParent = ReferenceInstanceParent.Parent;
					end;
					if(ReferenceInstanceParent and ReferenceInstanceParent:FindFirstChild("_pseudoid"))then
						local _pseudoid:StringValue = ReferenceInstanceParent:FindFirstChild("_pseudoid");
						ReferenceInstanceParent = getPseudo(_pseudoid.Value);
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
				if(typeof(propSheet[k]) == "string" and propSheet[k]:match("^%*%*"))then
					return;
				end;
				return propSheet[k];
			end;

			--> Same like above but supports **boolean|number
			if(not propSheet[k] and propSheet.__typecheckinglist and propSheet.__typecheckinglist[k])then
				return;
			end
		
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
			error(tostring(k).." is not a valid member of "..tostring(propSheet.ClassName).." / "..tostring(propSheet.Name).."\n\n"..debug.traceback())
		end,

		
		__newindex = function(_,k,v)

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
				return warn("\""..k.."\" is locked. "..propSheet.__lockedProperties[k]);
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

		--> useRawsets
			if(propSheet.____useRawsets)then
				if(propSheet.____useRawsets[k])then
					for _,x in pairs(propSheet.____useRawsets[k]) do
						local res = x(v);
						if(res)then
							Pseudo[k] = res;
							return;
						end;
					end
				end
			end

			--> Parents are rendered outside checks.
			if(k == "Parent")then
				renderAsync(renderMap,k,v,_ReferenceInstance,quickMap,Pseudo);
				return;
			end
			
			--> main new index
			--> Checks for nil because items can support nil properties, if the item does not exist then the indexer should error.
			local _t = Pseudo[k]; --> Does check to make sure k is a valid member
			-- if(Pseudo[k] or Pseudo[k] == nil)then
				
				--> Prevent assigning global readOnly properties
				if(table.find(readOnlyProperties, k))then 
					warn(k.." cannot be assigned to.") 
					return 
				end;
				
				--> Check for typechecking x = "**boolean"
				local hasTypeCheckStr = typeof(propSheet[k]) == "string" and propSheet[k]:match("^%*%*")
				if(hasTypeCheckStr)then
					local searchtypecheckinglist = Pseudo.__typecheckinglist;
					if(not searchtypecheckinglist)then
						Pseudo.__typecheckinglist = {};
					end;
					Pseudo.__typecheckinglist[k] = propSheet[k]:gsub("**",""):split("|");
				end;

				--> Validate type
				local isValidType = false;
				if(Pseudo.__typecheckinglist and Pseudo.__typecheckinglist[k])then
					if(table.find(Pseudo.__typecheckinglist[k],"any"))then
						isValidType = true;
					else
						if(_typecheck(Pseudo.__typecheckinglist[k],v,true))then
							isValidType = true;
						end
					end;
				else
					local t = {propSheet[k]}
					if(_typecheck(t,v,true))then
						isValidType = true
					end;
					t=nil;
				end;

				if(not isValidType)then
					error(("%s expected for \"%s\", got %s(%s). %s / %s"):format((Pseudo.__typecheckinglist and Pseudo.__typecheckinglist[k] and table.concat(Pseudo.__typecheckinglist[k],"|") or typeof(propSheet[k])),k,tostring(v),typeof(v),Pseudo.Name,Pseudo.ClassName).."\n\n"..debug.traceback())
				end;


				--> Updates propsheet
				propSheet[k]=v;
			
				--> Triggers render
				renderAsync(renderMap,k,v,_ReferenceInstance, quickMap, Pseudo);
				--[[
				--> Replicate Change
				if(game:GetService("RunService"):IsServer()  and ReplicationStatus.ReplicateProperties)then
					--> Do not replicate hidden properties
					if(not string.match(k,"^_"))then
						ReplicationService.ReplicatePseudo(Pseudo);
					end;
				end;
				]]
				--> Updating the attribute
				if(not attributelocked[k])then
					if(propSheet[k])then --<Make sure property exists
						attributelocked[k]=true;
						local AttributeTypeSupported = pcall(function()
							_ReferenceInstance:SetAttribute(k,v);
						end);
						if(not AttributeTypeSupported)then
							_ReferenceInstance:SetAttribute(k, getStringValueOfUnknownDataType(v,k))
						end
						attributelocked[k]=nil;
					end;
				end;

			-- end;
			
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
	LanzoCoreUtil.__Pseudos[id]=Pseudo; --> Stores the Pseudo so .getPseudo works
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
				if(renderMap._Mapping)then
					quickMap = renderMap._Mapping;
				end;
				--< Passing _Components;
				if(renderMap._Components)then 
					Pseudo._Components = renderMap._Components;
				end;
				
				if(renderMap._AfterRender)then --after renders are ran on a different thread
					local septhread = coroutine.create(function()
						renderMap._AfterRender();
					end);
					coroutine.resume(septhread);
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
				--> useComponents hook
				--[=[
					@class useComponents
				]=]
				--[=[
					@function useComponents
					@within useComponents
					@param components table
				]=]
				hooks.useComponents = function(components:table)
					assert(typeof(components) == "table", ("table expected from useComponents hook, got %s"):format(typeof(components)));
					for name,value in pairs(components) do
						if Pseudo._Components[name] then 
							warn(("useComponents effect caught overwrite on \"%s\". %s / %s"):format(name,Pseudo.Name,Pseudo.ClassName));
						end;
						Pseudo._Components[name] = value;
					end;
				end;
				--> useEffect hook

				--[=[
					@class useEffect

					useEffect is a hook that is use by functional [Pseudo]'s.
				]=]
				--[=[
					@function useEffect
					@within useEffect
					@param callback function -- A function that is called whenever the useEffect is triggered
					@param dependencies table? -- An optional list of items that can trigger this useEffect

					@return Servant

					```lua
					--> useEffect with a state depedency
					useEffect(function()
						print("This is only called when the state is changed")
					end,{AwesomeState});

					--> useEffect with property depedency
					useEffect(function()
						print("This is only called when \"OtherProperty\" and \"TextColor3\" are changed")
					end,{"OtherProperty","TextColor3"})

					useEffect(function()
						local doCleanupOnPreviousLoop = false;
						for i = 1,AwesomeState,1 do
							if(doCleanupOnPreviousLoop)then break;end;
							print("Running at index : ",i);
							wait(1);
						end;
						return function ()
							--//This will cause the previous for loop if still running to end whenever this useEffect hook is called
							doCleanupOnPreviousLoop = true; 
						end;
						
					end,{AwesomeState})


					return function ()
						print("This is called whenever any property of the component is changed");
					end;
					```
				]=]
				hooks.useEffect = function(callback:any,dependencies:table?)
					assert(typeof(callback) == "function", ("got %s on useEffect callback expected function"):format(typeof(dependencies)));
					if(not Pseudo._dev._useEffectState)then 
						Pseudo._dev._useEffectState = StateLibrary("nil");
					end;
					dependencies = _organizeuseEffectHookDependencies(Pseudo,dependencies or Pseudo._getCurrentPropSheetState(true,true,nil,true))
					return Pseudo._dev._useEffectState:useEffect(callback,dependencies)
				end;
				--> useRawset
				--[=[
					@class useRawset
				]=]
				--[=[
					@function useRawset
					@within useRawset
					@param callback ()
					@param dependency string

					Whenever a pseudo property is set to change, given the dependency your handler will be called.
					You will be given the parameter of the given value, if you return nil, then the pseudo property
					will be updated as usual, returning a value will cause a sort of a "rerender" on the pseudo.
					This might be useful incases where you want to check that the given property value is supported
					or locking properties, though, there's already a __lockproperties method for pseudo's.
				]=]
				hooks.useRawset = function(callback:any,dependency:string)
					assert(typeof(callback) == "function", ("got %s on useRawset callback expected function"):format(typeof(callback)));
					assert(typeof(dependency) == "string", ("got %s on useRawset dependency expected string"):format(typeof(dependency)));
					if(not propSheet.____useRawsets)then
						propSheet.____useRawsets = {};
					end;
					if(propSheet.____useRawsets[dependency])then
						warn("Using \"useRawset\" on "..Pseudo.Name.." with dependency \""..dependency.."\" multiple times, this may cause unwanted effects.")
					end;
					propSheet.____useRawsets[dependency] = propSheet.____useRawsets[dependency] or {};
					table.insert(propSheet.____useRawsets[dependency], callback);
				end;
				--> useRender
				--[=[
					@class useRender
				]=]
				--[=[
					@function useRender
					@within useRender
					@param props table
					@param dependencies table

					@return Servant

					A useEffect hook wrapper that only runs your callback after the first useEffect call.
				]=]
				hooks.useRender = function(callback:any,dependencies:table?)
					assert(typeof(callback) == "function", ("got %s on useRender callback expected function"):format(typeof(callback)));
					local usedEffect = false;
					return hooks.useEffect(function(...:any)
						if(usedEffect)then
							callback(...);
						else
							usedEffect = true;
						end;
					end, dependencies)
				end;
				--> useMapping hook
				--[=[
					@class useMapping
				]=]
				--[=[
					@function useMapping
					@within useMapping
					@param props {[string|number]:string
					@param dependencies {any}
					@param trackMap boolean -- if true, returns a servant which when destroyed will undo the mapping.

					As of >= v1.12.2 you can define the prop name and convert it to the required props that is being mapped
					["UniqueBackground3PropertyName"] = "BackgroundColor3"
					

					@return Servant?
				]=]
				hooks.useMapping = function(props:{[string|number]:string},dependencies:{any},trackMap:boolean?)
					assert(typeof(props) == "table", ("got %s on useMapping props expected table"):format(typeof(props)));
					assert(typeof(dependencies) == "table", ("got %s on useMapping dependencies expected table"):format(typeof(dependencies)));
					if(not quickMap)then
						quickMap = {};
					end;
					for _,dependency in pairs(dependencies) do
						if(not quickMap[dependency])then
							quickMap[dependency] = {};
						end;
						for index,prop in pairs(props) do
							if(table.find(quickMap[dependency],prop))then
								warn(debug.traceback(("Double call on useMapping hook dependency: %s || %s"):format(dependency.Name,prop),2))
							else
								--[[
									adds to quick map, 
									if [1] = "property" then add property
									but if ["myproperty"] = "property" then add table
								]]
								local isIndexNotNumber = typeof(index) ~= "number";
								table.insert(quickMap[dependency],isIndexNotNumber and {mp=index,p=prop} or prop);
								renderAsync(nil,isIndexNotNumber and index or prop ,Pseudo[isIndexNotNumber and index or prop],_ReferenceInstance,quickMap,Pseudo)
							end;
						end;
					end;
					if(trackMap)then
						local MappedServant = App.new("Servant");
						MappedServant.Destroying:Connect(function()
							local Array = App:Import("Array");
							for _,dependency in pairs(dependencies) do
								if(quickMap and quickMap[dependency])then
									Array.detach(quickMap[dependency], function(_,value)
										--> for detecting dynamic maps
										if(typeof(value) == "table")then
											for q,x in pairs(props) do
												if(typeof(q) ~= "number" and q == value.mp and x == value.p)then
													return true;
												end
											end;
											return false;
										end;
										--> for normal maps
										local find = table.find(props,value);
										if(find)then
											return true;
										end;
									end)
								end
							end
						end)
						return MappedServant;
					end
					--[[ OLD VERSION 11/6/2022 : Had DoubleCall errors and did not map properly || new version may need to be optimized using this concept.
					for _,dependency in pairs(dependencies) do
						if(not quickMap[dependency])then
							quickMap[dependency] = {};
						end;
					end
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
					]]
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
			if not (prop == "Parent" or prop == "Archivable")then
				local AttributeTypeSupported = pcall(function()
					_ReferenceInstance:SetAttribute(prop,val);
				end);
				if(not AttributeTypeSupported)then
					_ReferenceInstance:SetAttribute(prop, getStringValueOfUnknownDataType(val,prop))
				end
			end	
		end;
	end;
	
	--> Updating Property for Pseudo if Attribute was changed without __newindex 
	_ReferenceInstance.AttributeChanged:Connect(function(Attribute)
		if(attributelocked[Attribute])then  return; end;
		attributelocked[Attribute]=true;
		Pseudo[Attribute] = _ReferenceInstance:GetAttribute(Attribute);
		attributelocked[Attribute]=nil;
	end);
	
	--> Initiates the Pseudo Class
	Pseudo:_pseudoInit();

	--> _init, mostly for basegui
	pcall(function()
		if(Pseudo._init)then Pseudo:_init();end;
	end)

	--> Creates ReplicationToken for Pseudo
	if(IsServer and ReplicationStatus.ReplicateObject)then	
		if(Flags:GetFlag("pseudo-replication"))then
			Pseudo:Replicate();
		end
	end;

	return Pseudo,id;
end;

--> Store Pseudos in a weak table
LanzoCoreUtil.__Pseudos = {};
setmetatable(LanzoCoreUtil.__Pseudos, {__mode="kv"})

--> For creating custom classes
--[=[
	@ignore
]=]
function LanzoCoreUtil.Create(Class:table,Parent:any?,Args:any?,DirectProps:{[any]:any}?):any
	assert(Class.ClassName, "Tried to create class without a ClassName.");
	assert(Class._Render or Class.Render, "Tried To Create Class with no form of rendering. All Components require a :_Render method");
	if(DirectProps)then
		assert(typeof(DirectProps) == "table", ("DirectProps must be a table, got %s"):format(typeof(DirectProps)));
		DirectProps["_CONSTRCUTED__BY___CREATE____FUNC"] = true
	else
		DirectProps = {
			_CONSTRCUTED__BY___CREATE____FUNC = true;
		}
	end;
	--[[
	if(getClassModule(Class.ClassName))then
		error("Cannot 'Create' Class With ClassName Of "..Class.ClassName.." Because This Class Is A CoreClass");
		return;
	end;
	]]
	local Pseudo, returnedID = createPseudoObject(Class,Parent,DirectProps,Args);
	return Pseudo, returnedID;
end;
--//
local function handleClassDoesntExist(ClassName:string):nil
	error("Unable to create Pseudo \""..ClassName.."\". \""..ClassName.."\" is not a valid Pseudo Class $-"..debug.traceback());
end;
local function handleClassBlocked(ClassName:string):nil
	error("\""..ClassName.."\" cannot be created but only read or inherited.");
end;

-- Used by .new Constructor
--[=[
	@ignore
]=]
function LanzoCoreUtil.Produce(n:string,Parent:Instance?,...:any?):any
	local ClassModule = getClassModule(n);
	
	if(not ClassModule)then
		handleClassDoesntExist(n);
		return
	end;
	if(ClassModule.__PseudoBlocked)then 
		handleClassBlocked(n);
		return;
	end;

	local Pseudo, returnedID = createPseudoObject(ClassModule,Parent,nil,...);
	
	return Pseudo, returnedID;
end;


return LanzoCoreUtil;