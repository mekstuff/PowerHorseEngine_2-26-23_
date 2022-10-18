local Core = require(script.Parent.Parent.Parent);
local TweenService = game:GetService("TweenService");

local safeNumber = 0;

local Navigator = {
	Name = "Navigator";
	ClassName = "Navigator";
	NavigationSpeed = .45;
};

Navigator.__inherits = {"BaseGui"}

--[=[
	@class Navigator

	Inherits [BaseGui]
]=]
--[=[
	@prop NavigationSpeed number
	@within Navigator
]=]

--[=[]=]
function Navigator:Back()
	local NavigatedEvent = self:GetEventListener("Navigated");
	local currentIndex = self._dev.__nav.currentIndex;
	local currentPage, TargetPage = self._dev.__nav.pages[currentIndex],self._dev.__nav.pages[currentIndex-1];

	local targetpageid = TargetPage and TargetPage.id;

	currentPage,TargetPage = Core.getElementObject(currentPage and currentPage.page), Core.getElementObject(TargetPage and TargetPage.page);

	NavigatedEvent:Fire(targetpageid, TargetPage, "Back", currentIndex-1);

	if(currentPage)then
		local TweenPageOut = TweenService:Create(currentPage,TweenInfo.new(self.NavigationSpeed,Enum.EasingStyle.Quart),{Position = UDim2.new(1,0,0,0)});
		TweenPageOut:Play();
		TweenPageOut.Completed:Connect(function(typee)
			if(typee == Enum.PlaybackState.Completed)then
				currentPage.Visible = false;
				
			end
		end);
	end;

	self._dev.__nav.currentIndex-=1;

	if(TargetPage)then
		TargetPage.Visible = true;
		local TweenPageIn = TweenService:Create(TargetPage,TweenInfo.new(self.NavigationSpeed,Enum.EasingStyle.Quart),{Position = UDim2.new(0,0,0,0)});
		TweenPageIn:Play();
	end;

	return true;
end;
--[=[]=]
function Navigator:Next(initial:boolean?)
	local currentIndex = self._dev.__nav.currentIndex;
	local NavigatedEvent = self:GetEventListener("Navigated");

	local currentPage, TargetPage = self._dev.__nav.pages[currentIndex],self._dev.__nav.pages[currentIndex+1];

	local targetpageid = TargetPage and TargetPage.id;

	currentPage,TargetPage = Core.getElementObject(currentPage and currentPage.page), Core.getElementObject(TargetPage and TargetPage.page);
	
	if(not TargetPage)then 
		return false 
	end;
	
	if(not initial)then
		NavigatedEvent:Fire(targetpageid, TargetPage ,"Next",currentIndex+1);
	end;
	
	if(currentPage)then
		local TweenPageOut = TweenService:Create(currentPage,TweenInfo.new(self.NavigationSpeed,Enum.EasingStyle.Quart),{Position = UDim2.new(-1,0,0,0)});
		TweenPageOut:Play();

		TweenPageOut.Completed:Connect(function(typee)
			if(typee == Enum.PlaybackState.Completed)then
				currentPage.Visible = false;
			
			end
		end);

	end;

	if(TargetPage)then
		TargetPage.Visible = true;
		local TweenPageIn = TweenService:Create(TargetPage,TweenInfo.new(self.NavigationSpeed,Enum.EasingStyle.Quart),{Position = UDim2.new(0,0,0,0)});
		TweenPageIn:Play();
	else
	
	end;

	self._dev.__nav.currentIndex+=1;
	return true;
end;
--[=[]=]
function Navigator:NavigateTo(index:number|string,initial:boolean)
	if(typeof(index) ~= "number")then
		for _i,x in pairs(self._dev.__nav.pages) do
			if(x.id == index)then
				index = _i;
				break;
			end
		end
	end
	local targetDifference = index-self._dev.__nav.currentIndex;
	
	if(targetDifference == 0)then return end;

	if(targetDifference > 0)then
		for i = self._dev.__nav.currentIndex,index-1,1 do
			self:Next(initial);
		end;
	else

		for i = self._dev.__nav.currentIndex,index+1,-1 do
			self:Back();
		end;
	end;
end;
function Navigator:RemoveNavigation(id)
	for index,v in pairs(self._dev.__nav.pages)do
		if(v.id == id)then
		
			if(v.page)then v.page:Destroy();end;
			table.remove(self._dev.__nav.pages,index);
			if(self._dev.__nav.currentIndex == index)then
				if not (self:GoBack())then
					self:Next();
				end
			end
			break;
		end
	end
end;
--//
function Navigator:_getTableLength(t)
	t = t or self._dev.__nav.pages;
	local c = 0;
	for _,x in pairs(t) do
		c+=1;
	end;return c;
end
--[=[
	@param Page Instance | Pseudo
]=]
function Navigator:AddNavigation(Page:Instance, id:string|number, Number:number)
	Page = Core.getElementObject(Page);
	if(not Number)then Number = #self._dev.__nav.pages+1;end;

	table.insert(self._dev.__nav.pages, Number, {page = Page, id = id or Number});

	Page.Parent = self:GetGUIRef();
	Page.Position = UDim2.new(Number > 0 and 1 or -1);
	Page.Visible = false;

	if(self:_getTableLength() == 1)then
		self:NavigateTo(id,false);
	end;
end;


function Navigator:_Render(App)
	
	local NavigationContainer = Instance.new("Frame",self:GetRef());
	NavigationContainer.BackgroundTransparency = .95;
	NavigationContainer.ClipsDescendants = true;
	
	self._dev.__nav = {};
	self._dev.__nav.history = {};
	self._dev.__nav.pages = {};
	self._dev.__nav.currentIndex = safeNumber;
	
	self:AddEventListener("Navigated",true);
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {
			FatherComponent = NavigationContainer;	
		};
		_Mapping = {
			[NavigationContainer] = {
				"Position","AnchorPoint","Size","Visible";
			}	
		};
	};
end;


return Navigator
