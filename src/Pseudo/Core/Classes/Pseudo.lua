-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Tuesday, September 27 2022 @ 11:14:38

local App;
local SignalProvider = require(script.Parent.Parent.Parent.Parent.Core.Providers["SignalProvider"]);
local IsClient = game.Players.LocalPlayer and true or false;
local PseudoService = require(script.Parent.Parent.Parent.Parent.Core.Services.PseudoService);


local Pseudo = {
	Archivable = true;
	Name = "Pseudo";
	ClassName = "Pseudo";
	Parent = "**any";

	_referenceobjecttype = "Folder";
	_REPLICATEDTOCLIENTS = true;
	_SharedSignals = {};
	_cProps = {};
	__id = "pseudo-identifier";
	__PseudoBlocked = true;
};

--[=[
	@class Pseudo
]=]

--[=[
	@prop Name string
	@within Pseudo
]=]
--[=[
	@prop ClassName string
	@within Pseudo
	@readonly
]=]
--[=[
	@prop Parent any
	@within Pseudo
  
	:::warning
	If a Pseudo is Parented to another Pseudo, then .Parent will return the `Pseudo`, whereas if it's parented to an `Instance` you will get the ROBLOX Instance.
	:::
]=]

--[=[
	Creates a new replication token for the pseudo
]=]
function Pseudo:Replicate()
	local App = self:_GetAppModule();
	local ErrorService = App:GetService("ErrorService");
	if(IsClient)then
		return ErrorService.tossWarn("Only the server can replicate pseudo's.");
	end;
	if(not self._REPLICATEDTOCLIENTS)then
		ErrorService.tossWarn(("%s has _REPLICATEDTOCLIENTS as false, cannot :Replicate"):format(self.Name));
		return;
	end;
	-- local isReplicated = self._REPLICATEDTOCLIENTS
	local ReplicationService = App:GetService("ReplicationService");
	ReplicationService.newReplicationToken(self)
end;
--[=[]=]
function Pseudo:GetFullName():string
	return self:GetRef():GetFullName();
end;
--[=[
	@return Pseudo | Instance | nil
]=]
function Pseudo:WaitForChild(name:string,onlyPseudo:boolean,tries:number?):any?
	local c = self:FindFirstChild(name,false,onlyPseudo);
  
	if(not c)then
		tries = tries or 0;
		if(tries == 10)then
			self:_GetAppModule():GetService("ErrorService").tossWarn("Infinite Possible Yield On :"..self.Name..":WaitForChild(\""..name.."\")");
		end;
		task.wait(tries/7);
		return self:WaitForChild(name,onlyPseudo,tries+1)
	end;
	return c;
end;
--[=[
	This will call :FindFirstAncestor on it's parent, so if the parent is a ROBLOX Instance, it will then use FindFirstAncestor of `Instances` not `Pseudos`.
	@return Pseudo | Instance | nil
]=]
function Pseudo:FindFirstAncestor(name:string,level:number?)
	self:_GetAppModule():GetService("ErrorService").assert(name, "Argument 1 missing or nil");
	local Parent = self.Parent;
	if(not Parent)then return nil;end;
	level = level and level+1 or 1;
	if(self.Parent.Name == name)then
		return self.Parent,level;
	else
		return self.Parent:FindFirstAncestor(name,level);
	end
end;
--[=[
	@return Pseudo | Instance | nil
]=]
function Pseudo:FindFirstAncestorOfClass(name:string,level:number)
	self:_GetAppModule():GetService("ErrorService").assert(name, "Argument 1 missing or nil");
	local Parent = self.Parent;
	if(not Parent)then return nil;end;
	level = level and level+1 or 1;
	if(self.Parent.ClassName == name)then
		return self.Parent,level;
	else
		return self.Parent:FindFirstAncestorOfClass(name,level);
	end
end;

--[=[
	@return Pseudo | Instance | nil
]=]
function Pseudo:FindFirstAncestorWhichIsA(name:string,level:number)
	self:_GetAppModule():GetService("ErrorService").assert(name, "Argument 1 missing or nil");

	local Parent = self.Parent;
	if(not Parent)then return nil;end;
	level = level and level+1 or 1;
	if(self.Parent:IsA(name))then
		return self.Parent,level;
	else
		return self.Parent:FindFirstAncestorWhichIsA(name,level);
	end
end;

--[=[
	@return Pseudo | Instance | nil
]=]
function Pseudo:FindFirstChild(name:string,recursive:boolean?,onlyPseudo:boolean?):any?

	local children = self:GetChildren(onlyPseudo)
	for _,x in ipairs(children)do
		if(x.Name == name)then return x;end;
	end;
	if(recursive)then
		for _,x in ipairs(children) do
			local c = x:FindFirstChild(name,recursive,onlyPseudo);
			if(c)then return c;end;
		end
	end;
	return nil;
end;

--[=[
	@return Pseudo | Instance | nil
]=]
function Pseudo:FindFirstChildOfClass(name:string)

	for _,x in pairs(self:GetChildren())do
		if(x.ClassName == name)then return x;end;
	end
	return nil;
end;

--[=[
	@return Pseudo | Instance | nil
]=]
function Pseudo:FindFirstChildWhichIsA(name:string)

	for _,x in pairs(self:GetChildren())do	
		if(x:IsA(name))then return x;end;
	end;
	return nil;
end;
--//
function Pseudo:GetDescendants(onlyPseudo:boolean):table
	--[[
	local AllChildren = self:IsA("BaseGui") and self:GetGUIRef():GetDescendants() or self:GetRef():GetDescendants();

	local onlyPseudoElements = onlyPseudo and {} or nil;
	
	if(onlyPseudo)then
	for index,v in pairs(AllChildren)do
		if(v:IsA("Folder") and v:FindFirstChild("_pseudoid"))then
			local PseudoObject = PseudoService:GetPseudoFromId(v._pseudoid.Value);
			AllChildren[index]=PseudoObject;
				table.insert(onlyPseudoElements, PseudoObject)
			end
		end
	end;

	if(onlyPseudo)then
		return onlyPseudoElements, AllChildren;
	else
		return AllChildren;
	end
	]]
end;
--[=[]=]
function Pseudo:GetChildren(onlyPseudo:boolean):table
	local PseudoService = self:_GetAppModule():GetService("PseudoService");
	local Children = self:_GetCompRef():GetChildren();
	local ChildrenReturn = {};
	local onlyPseudoTable;

	for _,x in pairs(Children) do
		local isApartOfComponent = x.Name:match("^%$l_") or x.Name:match("$_%$l");
		if(not isApartOfComponent)then
			local isPseudo = (x:FindFirstChild("_pseudoid"));
			if(isPseudo)then
				local Comp = PseudoService:GetPseudoFromId(isPseudo);
				if(onlyPseudo)then
					if(not onlyPseudoTable)then onlyPseudoTable = {};end;
					table.insert(onlyPseudoTable, Comp)
				else
					if(not ChildrenReturn)then ChildrenReturn = {};end;
					table.insert(ChildrenReturn, Comp);
				end
			else
				if(not onlyPseudo)then
					if(not ChildrenReturn)then ChildrenReturn = {};end;
					table.insert(ChildrenReturn, x);
				end
			end
		end;
	end;

	return onlyPseudo and onlyPseudoTable or ChildrenReturn;
end;

--[=[
	@private
]=]
function Pseudo:_pseudoInit()

	self:AddEventListener("Destroying",true,self:GetPropertyChangedSignal("Destroying"));
	self:AddEventListener("Changed",true,self:GetPropertyChangedSignal());

	local Ref = self:GetRef();

	Ref.Destroying:Connect(function()
		self:_destroy();
	end);

	if (self.ClassName ~= "PHeSignal")then
		self:AddEventListener("ChildAdded",true,nil);
		self:AddEventListener("ChildRemoved",true,nil);
		self:AddEventListener("DescendantAdded",true,nil);
		self:AddEventListener("DescendantRemoving",true,nil);
		self:AddEventListener("AncestryChanged",true,nil);
	end;
	
	local t = self:IsA("BaseGui") and self:GetGUIRef() or self:GetRef();
	
	local function fireEvent(v,event)
		local e = self:GetEventListener(event);
		if(not e)then return end;
		local t = v;
		if(v:IsA("Folder") and v:FindFirstChild("_pseudoid"))then
			local PseudoObject = PseudoService:GetPseudoFromId(v._pseudoid.Value);
			if(PseudoObject)then
				t = PseudoObject;
			end
		end;
		e:Fire(t);
	end
	
	t.AncestryChanged:Connect(function(v)
		fireEvent(v,"AncestryChanged");
	end)

	t.ChildAdded:Connect(function(v)
		fireEvent(v,"ChildAdded");
	end);	
	t.ChildRemoved:Connect(function(v)
		fireEvent(v, "ChildRemoved")
	end);
end;

--//
function Pseudo:_RenderOnStep(func)
	delay(.1,function()
		return func();
	end)
end

--//
local function disconnSignals(t)
	for i,v in pairs(t)do
		if(typeof(v) == "RBXScriptConnection" and v.Disconnect)then
			v:Disconnect();
		end
	end
end;

--//
local function des(f)
	for _,v in pairs(f)do
		if (typeof(v) == "RBXScriptConnection")then
			if(v.Connected)then
				v:Disconnect();
			end
		elseif(typeof(v) == "thread")then
			coroutine.close(v);
		elseif(typeof(v) == "Instance")then
			v:Destroy();
		elseif(typeof(v) == "table")then
			if(v._dev)then
				v:Destroy();
			else
				des(v);
			end
		end
	end;
end

--//
function Pseudo:_destroy()
	if(not self._dev)then return end; -->Most likely already destroyed;

	if(self._usedByStackProvider)then
		local PseudoService = self:_GetAppModule():GetService("PseudoService");
		for id,_ in pairs(self._usedByStackProvider) do
			local obj = PseudoService:GetPseudoFromId(id)
			if(obj)then
				obj:_removeFromStackForce(self._dev.__id,self.ClassName);
			end
		end;
	end

	if(self._onDestroyed)then
		self._onDestroyed();	
	end;
	
	local event = self._ChangedSignals["Destroying"];
	if(event)then
		event:Fire(self._dev.__id);
	end

	self._dev.args = nil;

	local dev = self["_dev"];
	local signals = self["_Signals"];
	local components = self["_Components"];
	local changedSignals = self["_ChangedSignals"];
	
	des(dev);
	disconnSignals(signals);disconnSignals(changedSignals);
	if(components)then
		for _,v in pairs(components)do
			local s,f = pcall(function()
				v:Destroy();
			end)
		end
	end
	
	local App = self:_GetAppModule();
	if(game:GetService("RunService"):IsServer())then
		if(self._REPLICATED)then
			local ReplicationService = App:GetService("ReplicationService");
			ReplicationService.destroyReplicationToken(self._dev.__id);
		end;
	end;
	local PseudoModule = App:GetGlobal("Pseudo");
	if(not PseudoModule)then return end;

	self["_dev"]=nil;
	
	--> Pseudo's are stored in memory for 10 seconds until removed (memory being Util for __getPseudo)
	task.delay(10,function()
		PseudoModule.removePseudoTrace(self.__id);
		setmetatable(self, {_mode="kv"});
	end)
end;
--[=[]=]
function Pseudo:SerializePropsAsync()
	local SerializationService = self:_GetAppModule():GetService("SerializationService");
	local propSheet = (self._getCurrentPropSheetState(true,true));
	return  (SerializationService:SerializeTable(propSheet));
end;
--[=[]=]
function Pseudo:DeserializePropsAsync(Serialized:string,Apply:boolean):table
	assert(Serialized, "DeserializeSelfPropsAsync requires a serialized key to deserialize");
	local SerializationService = self:_GetAppModule():GetService("SerializationService");
	local t = typeof(Serialized) == "table" and Serialized or SerializationService:DeserializeTable(Serialized);
	if(Apply)then
		for a,b in pairs(t) do
			self[a]=b;
		end
	end
	return t;
end
--[=[]=]
function Pseudo:GET(Comp:string):any?
	return self._Components[Comp];
end;
--[=[
	Clones the `Pseudo`. It also will clone Instances inside the Pseudo that wasn't created by the Pseudo itself. Pseudo's must follow
	a naming convention to properly support cloning.

	@return Pseudo
]=]
function Pseudo:Clone()
	local App = self:_GetAppModule();
	local ErrorService = App:GetService("ErrorService");
	local new;
	local ran,res = pcall(function()
		return App.new(self.ClassName);
	end);
	if(ran)then new=res;
		else ErrorService.tossWarn("Can't Clone "..self.Name.." because the "..self.ClassName.." doesn't allow cloning");
		return;	
	end;

	local propSheet = (self._getCurrentPropSheetState(true,true));
	for a,b in pairs(propSheet)do
		if(a~="Parent")then
			new[a]=b;
		end
	end;

	local Children = self:GetChildren();
	for _,x in pairs(Children) do
		local Cloned = x:Clone();
		Cloned.Parent = new:IsA("Pseudo") and new:_GetCompRef() or new;
	end

	return new;
end;

--[=[
	Destroys the Reference, You can overwrite this by creating your own :Destroy method but make sure to include:
	```lua
	self:GetRef():Destroy()
	```
]=]
function Pseudo:Destroy()
	self:GetRef():Destroy();
end
local ROBLOXPropChangedSignals = {"Name","Parent"};

--[=[
	@return PHeSignal
]=]
function Pseudo:GetPropertyChangedSignal(Prop:string)
	if(not self._ChangedSignals)then self._ChangedSignals = {};end;
	
	local e = table.find(ROBLOXPropChangedSignals, Prop);
	if(e)then
		return self:GetRef():GetPropertyChangedSignal(Prop);
	end;
	
	local TargetProp;

	if(Prop == "Destroying")then
		TargetProp = "Destroying";
	elseif(Prop == nil)then
		TargetProp = "all";
	else
		TargetProp = self[Prop]; --< Errors if the property doesn't exists.
		TargetProp = Prop;
	end

	local signal = self._ChangedSignals[TargetProp];
	if(not signal)then
		local App = self:_GetAppModule();
		signal = SignalProvider.new("SignalChanged "..TargetProp);
		self._ChangedSignals[TargetProp]=signal;
	end;
	return signal;
end

--[=[]=]
function Pseudo:IsA(Class:string):boolean
	if(self.ClassName == Class)then return true;end;
	if(table.find(self._classes,Class))then
		return true;
	end
	local ran,res = pcall(function()
		return self._RBXClassName == Class;
	end);
	return res;
end
--[=[
	@return PowerHorseEngine
]=]
function Pseudo:_GetAppModule()
	if(App)then return App 
	else 
		App = require(script.Parent.Parent.Parent.Parent);
		return App;
	end;
end;

--[=[
	Some Pseudo's may have `_Appender` Instances or `FatherComponent`'s :_GetCompRef will return those. If they don't exist then
	it return the Ref.
]=]
function Pseudo:_GetCompRef():any
	return self:GET("_Appender") or self:GET("FatherComponent") or self:GetRef();
end;
--[=[
	Returns the Reference Instance of the Pseudo, this will most likely be a `Folder` containing the attributes. Whenever this Ref is destroyed, the Pseudo is destroyed aswell.
]=]
function Pseudo:GetRef():Folder|any
	return self._referenceInstance
end

--[=[
	@return PHeSignal
]=]
function Pseudo:AddEventListener(EventName:string, CreatingEvent:boolean?, BindCreateToEvent:BindableEvent?, SharedSignal:boolean?):BindableEvent
	SharedSignal = SharedSignal and "_SharedSignals" or "_Signals";

	--if(not self._Signals)then self._Signals = {};end;
	if(self[SharedSignal][EventName])then
		if(CreatingEvent and SharedSignal ~= "_SharedSignals")then warn("Event: "..tostring(EventName).." Already Exists");end;
		return self[SharedSignal][EventName];
	end;

	if(CreatingEvent)then
		local sig;
		if(BindCreateToEvent)then
			sig = BindCreateToEvent;
		else
			--local App = self:_GetAppModule();

			local newSignal = SignalProvider.new(EventName);
			--newSignal.Name = newSignal.Name.." "..EventName
			sig = newSignal;
			self._Signals[EventName]=newSignal;
		end;
		self[SharedSignal][EventName]=sig;
		return sig;
	end;

end;
--[=[]=]
function Pseudo:RemoveEventListener(...:any):nil
	local Events = {...};
	local Signals = self._Signals
	--local Signals = self.__dev.Signals;
	for _,Event in pairs(Events)do
		if(Signals[Event])then
			if(Event.Destroy)then
				Event:Destroy();
			end	
		end
	end;
end;
--[=[]=]
function Pseudo:RemoveEventListeners():nil
	local Signals = self._Signals;
	for _,Signal in pairs(Signals)do
		Signal:Destroy();Signal=nil;
	end
end;

--[=[
	@return PHeSignal
]=]
function Pseudo:GetEventListener(Listener:string):Instance
	return self._Signals[Listener]
end
--[=[
	@private
]=]
function Pseudo:_lockProperty(propertyName:string,propertyCallback:string?)
	--[[
	local CoreGuiService = self:_GetAppModule():GetService("CoreGuiService");
	if not(CoreGuiService:GetIsCoreScript())then
		self:_GetAppModule():GetService("ErrorService").tossError("_lockProperty can only be performed by select script sources.");
		return;	
	end;
	]]
	local Prop = self[propertyName];
	self.__lockedProperties[propertyName]= propertyCallback or "\""..propertyName.."\" property is locked for "..self.Name;
end;
--[=[
	@private
]=]
function Pseudo:_lockProperties(...:any)
	for _,v in pairs({...}) do
		self:_lockProperty(v);
	end;
end;
--[=[
	@private
]=]
function Pseudo:_unlockProperty(...:any)
	--[[
	local CoreGuiService = self:_GetAppModule():GetService();
	if not(CoreGuiService:GetIsCoreScript())then
		self:_GetAppModule():GetService("ErrorService").tossError("_unlockProperty can only be performed by select script sources.");
		return;	
	end;
	]]
	for _,v in pairs({...}) do
		self.__lockedProperties[v]=nil;
	end;
end;
--//

--[=[
	@deprecated v0.2.0 -- This Method was deprecated early in development, but still accessible. We really do not recommend using it.
	Value that is stored on both the server and the client, sharedValues can only be set on the server
]=]
function Pseudo:ShareValue(Key:string,Value:any)
	local App = self:_GetAppModule();
	local ErrorService = App:GetService("ErrorService");
	ErrorService.assert(typeof(Key) == "string", "String expected as share value key");
	if(IsClient)then return ErrorService.tossWarn("Sharing a value can only be done by the server...");end;
	local PHe_RS = App:GetGlobal("Engine"):FetchReplicatedStorage();
	local PHe_RS_SharedKeyValues = PHe_RS:FindFirstChild("PHe_RS_SharedKeyValues");
	if(not PHe_RS_SharedKeyValues)then
		PHe_RS_SharedKeyValues = Instance.new("Folder",PHe_RS);
		PHe_RS_SharedKeyValues.Name = "PHe_RS_SharedKeyValues";
	end;
	local SerializationService = App:GetService("SerializationService");
	
	local ExistingKey = PHe_RS_SharedKeyValues:FindFirstChild(Key);
	if(not ExistingKey)then 
		ExistingKey = Instance.new("StringValue");
		ExistingKey.Name = Key;
	end;
	local Serialized = SerializationService:SerializeTable({
		Value = Value; 
	});
	ExistingKey.Value = Serialized;	
end
--[=[
	@deprecated v0.2.0 -- This Method was deprecated early in development, but still accessible. We really do not recommend using it.
]=]
function Pseudo:UseVar(Variable:string, newValue:any):nil
	local hasVar = self[Variable];
	if(self._activeStateController)then
		self._activeStateController:Terminate(self,Variable,"UseState")
		self._activeStateController:Terminate(self,Variable,"ExtenderState");
		self._activeStateController = nil;
	end
	self[Variable] = newValue;
end;
--[=[
	@deprecated v0.2.0 -- This Method was deprecated early in development, but still accessible. We really do not recommend using it.
]=]
function Pseudo:_usenestvar(Variable:string,newValue:any)
	local hasVar = self[Variable];
	if(self._activeStateController)then
		self._activeStateController:Terminate(self,Variable,"UseState")
		self._activeStateController = nil;
	end
	self[Variable] = newValue;
end;

return Pseudo
