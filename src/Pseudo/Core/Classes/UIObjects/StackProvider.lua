local PseudoService = require(script.Parent.Parent.Parent.Parent.Parent.Core.Services.PseudoService);

--[=[
	@class StackProvider
]=]

local StackProvider = {
	Name = "StackProvider";
	ClassName = "StackProvider";
	Filter = "";
	IgnoreOtherProviders = false;
	Stack = "**table";
	Enabled = true;
	Provider = "**any";
	DirectChildrenOnly = false;
	--Adornee = "**Instance";
};

--[=[
	@prop Filter string
	@within StackProvider
]=]
--[=[
	@prop IgnoreOtherProviders boolean
	@within StackProvider
]=]
--[=[
	@prop Stack table
	@within StackProvider
]=]
--[=[
	@prop Enabled boolean
	@within StackProvider
]=]
--[=[
	@prop Provider Pseudo | Instance
	@within StackProvider
]=]
--[=[
	@prop DirectChildrenOnly boolean
	@within StackProvider
]=]

StackProvider.__inherits = {}

--[=[
	@private
]=]
function StackProvider:fetchObjects(search:any,filter:table,ignoreOthers:boolean,prevTable:table,addedevent:any):table
	if(prevTable and self.DirectChildrenOnly)then return prevTable;end;
	prevTable = prevTable or {};
	search = search:GetChildren();
	for _,x in pairs(search)do
		if(x:IsA("Folder") and x:FindFirstChild("_pseudoid"))then
			x = PseudoService:GetPseudoFromId(x._pseudoid.Value);
		end;
		if(x:IsA("Pseudo"))then
			if(table.find(filter, x.ClassName))then
				if(not prevTable[x.ClassName])then prevTable[x.ClassName]={};end;
				if(not prevTable[x.ClassName][x.__id])then
					prevTable[x.ClassName][x.__id] = x;
					if(not self.Enabled)then return end;
					addedevent:Fire(x, x.ClassName);					
				end;
			end;
		end;
		
		self:fetchObjects(x,filter,ignoreOthers,prevTable,addedevent)
	end;
	return prevTable;
end

--[=[
	@private
]=]
function StackProvider:_tableFilter(f:table):table
	f = f or self.Filter;
	local t={};
	for x in f:gmatch("(%w+),*") do table.insert(t,x);end;
	return t;
end

--[=[
	@private
]=]
function StackProvider:_removeFromStackForce(id:any,className:string)
	if(not self.Stack[className])then return;end;
	self.Stack[className][id]=nil;
	if(not self.Enabled)then return end;
	self:GetEventListener("PseudoRemoved"):Fire(nil, className, id);
end;


function StackProvider:_Render(App)
	
	self._dev.tableFilter = {};
	
	local DescendantAddedEvent;
	local DescendantRemovingEvent;
	
	--[=[
		@prop PseudoAdded PHeSignal
		@tag Event
		@within StackProvider
	]=]
	local PseudoAdded = self:AddEventListener("PseudoAdded",true);
	--[=[
		@prop PseudoRemoved PHeSignal
		@tag Event
		@within StackProvider
	]=]
	local PseudoRemoved = self:AddEventListener("PseudoRemoved",true)
	
	local function disconnectEvents()
		if(DescendantAddedEvent)then DescendantAddedEvent:Disconnect();DescendantAddedEvent=nil;end
		if(DescendantRemovingEvent)then DescendantRemovingEvent:Disconnect();DescendantRemovingEvent=nil;end
	end;
	
	local function connectEvents()
		if(DescendantAddedEvent or DescendantRemovingEvent)then disconnectEvents();end;
		-- print(self.Provider.ChildAdded);
		local TargetEventConnection = self.DirectChildrenOnly and self.Provider.ChildAdded or self.Provider.DescendantAdded;
		DescendantAddedEvent = TargetEventConnection:Connect(function(child)
			-- print(child, "GOT EH")
			-- print("Added");
			if(child:IsA("Folder") and child:FindFirstChild("_pseudoid"))then
				
				child = PseudoService:GetPseudoFromId(child._pseudoid.Value);
			end;
			if not child:IsA("Pseudo")then return end;

			if not(table.find(self._dev.tableFilter, child.ClassName))then
				local inherits=false;
				for _,v in pairs(self._dev.tableFilter) do
					if(child:IsA(v))then 
						inherits = true;
						break;
					end;
				end
				if(not inherits)then return end;		
			end;
			if(not self.Stack[child.ClassName])then self.Stack[child.ClassName]={};end;

			if(self.Stack[child.ClassName][child.__id])then return end;
			self.Stack[child.ClassName][child.__id]=child;

			if(not child._usedByStackProvider)then
				child._usedByStackProvider = {};
				child._usedByStackProvider[self.__id] = true;
			end

			--print("Added ", child.Name, " to ", child.ClassName);
			if(not self.Enabled)then return end;
			-- print("Here");

			PseudoAdded:Fire(child, child.ClassName);
		end)
		local TargetEventConnection = self.DirectChildrenOnly and self.Provider.ChildRemoved or self.Provider.DescendantRemoving;
		DescendantRemovingEvent = TargetEventConnection:Connect(function(child)
			if(child:IsA("Folder") and child:FindFirstChild("_pseudoid"))then
				child = PseudoService:GetPseudoFromId(child._pseudoid.Value);
			end;
			if(not child)then return;end;	

			if not child:IsA("Pseudo")then return end;
			
			if(not self.Stack[child.ClassName])then return;end;
			self.Stack[child.ClassName][child.__id]=nil;
			if(child._usedByStackProvider)then
				child._usedByStackProvider[self.__id] = nil;
			end
			if(not self.Enabled)then return end;
			PseudoRemoved:Fire(child, child.ClassName);
		end)
	end;
	
	local _dcofr = true;
	
	return {
		["DirectChildrenOnly"] = function()
			if(_dcofr)then _dcofr = false;return;end;
			if(not self.Provider)then return end;
			disconnectEvents();
			local objects = self:fetchObjects(self.Provider,self._dev.tableFilter,self.IgnoreOtherProviders,{},PseudoAdded);
			self.Stack = objects;
			connectEvents();
			
		end;
		["Provider"] = function(Value)
			-- print(Value);
			self.Stack = {};
			-- print("Provided : ", Value)
			disconnectEvents();
			if(Value)then
				local objects = self:fetchObjects(Value,self._dev.tableFilter,self.IgnoreOtherProviders,{},PseudoAdded);
				self.Stack = objects;
			end;
			connectEvents();
		end;
		--[[
		["*Parent"] = function(Value)
			--if(not self.Enabled)then return end;
			self.Stack = {};
			disconnectEvents();
			if(Value)then
				local objects = self:fetchObjects(Value,self._dev.tableFilter,self.IgnoreOtherProviders,{},PseudoAdded);
				self.Stack = objects;
			end;
			connectEvents();
		end,]]
		["Filter"] = function(Value)
			local x = self:_tableFilter(Value);
			self._dev.tableFilter = x;
			if(self.Stack)then
				for class,v in pairs(self.Stack) do
					if(not table.find(x,class))then
						for id,obj in pairs(v)do
							PseudoRemoved:Fire(obj,class);
							v[id]=nil;
						end;
						self.Stack[class]=nil;
					end;
				end;
				
				for _,v in pairs(x)do
					if not(self.Stack[v])then
						self:fetchObjects(self.Provider,x,self.IgnoreOtherProviders,self.Stack,PseudoAdded);
						break;
					end
				end			
			end;
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return StackProvider
