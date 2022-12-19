--[=[
	@class PHePluginAppHandler
]=]
local PHePluginAppHandler = {};

local PluginApps = {};

--[=[]=]
function PHePluginAppHandler.IsProperLibrary(libFile:Folder):table
	local isFolder = typeof(libFile) == "Instance" and libFile:IsA("Folder");
	if(not isFolder)then 
		return {
			error = "Library file is expected to be a folder."
		}
	end;
	local function searchForFile(search,fileName,recursive)
		return search:FindFirstChild(fileName, recursive);
	end;
	
	local hasManifest = searchForFile(libFile,"$Manifest")
	local hasApp;
	
	for _,v in pairs(libFile:GetChildren()) do
		if(v.Name:match("^%$App"))then
			hasApp = v;break;
		end
	end
	
	if(not hasManifest)then return {error="$Manifest module is missing from your library file."};end;
	if(not hasApp)then return {error="$App module is missing from your library file. You can name your $App files $App-MainFile, Once $App is at the start it will be detected"};end;
	
	local manifestReq = require(hasManifest);
	
	if(not manifestReq.Name)then
		return {
			error="Name is required to be stated in your $Manifest."
		}
	end

	return {
		AppFile = hasApp;
		success = true;
	}
end;

local modulesFolder;
local prevModnames = {"lanzo_modules"}
local currModname = ".lanzoinc";

--[=[]=]
function PHePluginAppHandler.getModulesfolder()
	if(modulesFolder)then 
		return modulesFolder;
	end;
	local ss = game:GetService("ServerStorage");
	local q = ss:FindFirstChild(currModname);
	if(q)then
		modulesFolder = q;
		return q;
	end
	for _,x in pairs(prevModnames) do
		local t=  ss:FindFirstChild(x);
		if(t)then
			t.Name = currModname;
			modulesFolder = t;
			return t;
		end
	end;
	local folder = Instance.new("Folder");
	folder.Name = currModname;
	folder.Parent = game:GetService("ServerStorage");
	modulesFolder = folder;
	return folder;
end;

--[=[
	@param App PowerHorseEngine

	@return PHePluginStudioTool
]=]
function PHePluginAppHandler.addTool(App:table,ToolData:table,ManifestName:string,toolbar:PluginToolbar,AppStorage:Folder,PluginLibraryObject:PHePluginLibraryObject)

	local ImageProvider = App:GetProvider("ImageProvider");
	local ErrorService = App:GetService("ErrorService");
	local CustomClassService = App:GetService("CustomClassService");
	
	ToolData._Render = function()
		return{};
	end;
	
	ErrorService.assert(ToolData.init, "init function missing from tool data, the init function is responsible for returning a table containing the tool data, such as id,name,description etc...");
	ErrorService.assert(ToolData.open, "missing open method from tool data, the open method is triggered whenever the button is pressed and self._enabled = false. you should set self._enabled to true so our system knows that it was opened");
	ErrorService.assert(ToolData.close, "missing close method from tool data, the closed method is triggered whenever the button is pressed and self._enabled = true. you should set self._enabled to false so our system knows that it was closed");
	ErrorService.assert(ToolData.initiated, "missing initiated method from tool data, this is triggered whenever the tool was initiated from tool.init");
	
	if(not ToolData.launch)then
		ToolData.launch = ToolData.open;
	end;

	local data = ToolData.init();
	
	ErrorService.assert(data and data.id, "id missing from init function return, you are required to pass a unique identifier e.g return{ id = example-id-for-my-special-app}");
	-- data.id = ManifestName.."-"..data.id;
	-- data.id = data
	data.name = data.name or data.id;
	if(data.toolboxbutton == nil)then data.toolboxbutton = true;end;

	local TargetStorage = AppStorage:FindFirstChild(data.name);
	if(not TargetStorage)then
		local s = Instance.new("Folder");
		s.Name = data.name;
		s.Parent = AppStorage;
		TargetStorage = s;
	end;
	
	ToolData.ClassName = ToolData.ClassName or data.name;
	
	--[=[
		@class PHePluginStudioTool
	]=]

	--[=[
		@function init
		@within PHePluginStudioTool
	]=]
	--[=[
		@method initiated
		@within PHePluginStudioTool
	]=]
	--[=[
		@method launch
		@within PHePluginStudioTool
	]=]
	--[=[
		@method open
		@within PHePluginStudioTool
	]=]
	--[=[
		@method close
		@within PHePluginStudioTool
	]=]

	--[=[
		@method ProvideAPI
		@within PHePluginStudioTool
		@param APIKEY string?
	]=]
	function ToolData:ProvideAPI(APIKEY:string?)
		if(PluginLibraryObject._StudioTools[ToolData.id])then
			ErrorService.tossError(ToolData.id.." is already occupied an API Space, "..ToolData.name.." -> "..PluginLibraryObject.Name);
		end;
		PluginLibraryObject._StudioTools[data.id] = self;
	end;

	local PHePluginStudioTool = CustomClassService:Create(ToolData);
	if(data.api)then
		PHePluginStudioTool:ProvideAPI(typeof(data.api) == "string" and data.api or "$lanzo-open-api");
	end;

	PHePluginStudioTool.Parent = PHePluginAppHandler._container;

	local ToolClassButton;
    ToolClassButton = data.toolboxbutton and toolbar:CreateButton(data.id.."-"..tostring(math.random()),data.desc or "", ImageProvider:GetImageUri(data.icon) or ImageProvider:GetImageUri("ico-mdi@alert/error_outline"), data.name);
    PHePluginStudioTool._dev.button = ToolClassButton;
	PHePluginStudioTool._dev.info = data;
	PHePluginStudioTool._enabled = false;
	PHePluginStudioTool._storage = TargetStorage;
	
	if(data.toolboxbutton)then
		ToolClassButton.Click:Connect(function()
			if(not PHePluginStudioTool.___phestudiotoollaunched)then
				PHePluginStudioTool.___phestudiotoollaunched=true;
				PHePluginStudioTool:launch();
				if(PHePluginStudioTool._mainWidget)then
					PHePluginStudioTool._mainWidget:BindToClose(function()
						PHePluginStudioTool:close();
					end)
				end
				return;
			end;
			if(PHePluginStudioTool._enabled)then
				PHePluginStudioTool:close();
			else
				PHePluginStudioTool:open();
			end
		end)
	end
	return PHePluginStudioTool, ToolClassButton;
end;

--[=[
	@return PHePluginLibraryObject
]=]
function PHePluginAppHandler.CreatePHeLibraryObject(LibraryFolder:Folder,toolbar:PluginToolbar,plugin:Plugin)
    local App:PHeApp = require(script.Parent.Parent.Parent.Parent)::any;
	local Theme = App:GetGlobal("Theme");
	local ErrorService = App:GetService("ErrorService");
	local CustomClassService = App:GetService("CustomClassService");

	local isProperyLibrary = PHePluginAppHandler.IsProperLibrary(LibraryFolder);
	if(isProperyLibrary.success)then
		local Manifest = require(LibraryFolder:FindFirstChild("$Manifest"));
		local PHeModules = PHePluginAppHandler.getModulesfolder();
		local AppStorage = PHeModules:FindFirstChild(Manifest.Name);
		if(not AppStorage)then
			local s = Instance.new("Folder");
			s.Name = Manifest.Name;
			s.Parent = PHeModules;
			AppStorage = s;
		end;
		--[=[
			@class PHePluginLibraryObject
		]=]
        local PHePluginLibraryObject = {};
		PHePluginLibraryObject.Name = Manifest.Name;
		PHePluginLibraryObject.ClassName = PHePluginLibraryObject.ClassName or "PHePluginLibraryObject";

		--[=[
			@prop onReady function
			@within PHePluginLibraryObject
		]=]
		PHePluginLibraryObject.onReady = "**function";
		--[=[
			@prop onInstall function
			@within PHePluginLibraryObject
		]=]
		PHePluginLibraryObject.onInstall = "**function";
		--[=[
			@prop onUninstall function
			@within PHePluginLibraryObject
		]=]
		PHePluginLibraryObject.onUninstall = "**function";
		--[=[
			@prop onUpdate function
			@within PHePluginLibraryObject
		]=]
		PHePluginLibraryObject.onUpdate = "**function";
		

		function PHePluginLibraryObject:_Render()
			return function(Hooks)
				self._PHeAppPseudoHooks = Hooks;	
			end
		end;

		--//Shipped with all tools

		--> We should make PluginApps have a shared property.
		if(PluginApps[Manifest.Name])then
			App:GetService("ErrorService").tossWarn(("PluginApp Manifest Name used twice. \"%s\""):format(Manifest.Name))
		end
		PluginApps[Manifest.Name] = PHePluginLibraryObject;

		--[=[
			Gets the current version of the plugin install on the client
			Your plugin must be published for this to take effect, until then, it will always return version 0.1.0
		]=]
		function PHePluginLibraryObject:GetLocalPluginVersion()
			return "0.1.0";
		end;
		--[=[
			Gets the current version of the plugin on the ROBLOX server
			Your plugin must be published for this to take effect, until then, it will always return version 0.1.0
		]=]
		function PHePluginLibraryObject:GetCloudPluginVersion()
			return "0.1.0";
		end;
		--[=[]=]
		function PHePluginLibraryObject:RequestVersionUpdateAsync(Append:any?,UpdateRequired:boolean?,HeadsupText:string?)
			HeadsupText = HeadsupText or "A new update "..self:GetCloudPluginVersion().." is available, "..self:GetLocalPluginVersion().." is no longer the latest, "..(UpdateRequired and "this update is required." or "Please update.");
			local Prompt = App.new("Prompt");
			if(not Append)then
				Append = Instance.new("ScreenGui");
				Append.Name = "%Temp-Lanzo%~=RequestVersionUpdateAsync@"..self.Name;
				Append.Parent = game:GetService("CoreGui");
				table.insert(Prompt._dev, Append); --> So it will be cleaned up
			end;
			Prompt.Header = "Update "..self.Name;
			Prompt.Size = UDim2.fromOffset(250);
			Prompt.Highlighted = true;
			Prompt.HeaderIconSize = UDim2.fromOffset(30,30);
			Prompt.HeaderIcon = UpdateRequired and "ico-mdi@alert/error" or "ico-mdi@alert/warning";
			Prompt.HeaderIconAdaptsHeaderTextColor = false;
			Prompt.HeaderIconColor3 = UpdateRequired and Theme.useTheme("Danger") or Theme.useTheme("Warning");
			Prompt.HeaderAdjustment = App.Enumeration.Adjustment.Left;
			Prompt.ZIndex = 10;
			Prompt.Body = HeadsupText;
			Prompt.BackgroundColor3 = Theme.useTheme("Background");
			Prompt.HeaderTextColor3 = Theme.useTheme("Text");
			Prompt:GET("Modal"):GET("Body").TextColor3 = Theme.useTheme("Text");
			Prompt:GET("Modal"):GET("Body").ZIndex = Prompt.ZIndex+1;
			local CancelButton = Prompt:AddButton("Cancel", {
				TextColor3 = Theme.useTheme("Text");
				BackgroundColor3 = Theme.useTheme("Secondary");
				ButtonFlexSizing = true;
				Disabled = UpdateRequired;
			},"close");
			local UpdateButton = Prompt:AddButton("Update", {
				TextColor3 = Theme.useTheme("Text");
				BackgroundColor3 = Theme.useTheme("Primary");
				ButtonFlexSizing = true;
			},"update");
			Prompt.Parent = Append;
			local _,btnid = Prompt.ButtonClicked:Wait();
			if(btnid == "update")then
				CancelButton.Disabled = true;
				UpdateButton.Disabled = true;
				Prompt.Header = "Updating...";
				return true;
			else
				Prompt:Destroy();
				return false;
			end
		end;
		--[=[
			@return PHePluginLibraryObject
		]=]
		function PHePluginLibraryObject:HasPluginApp(PluginAppName:string):boolean
			ErrorService.assert(typeof(PluginAppName) == "string", ("string expected for PluginAppName on :HasPluginApp, got %s. %s"):format(tostring(PluginAppName),self.Name));
			if(PluginApps[PluginAppName])then
				return true;
			else
				return false;
			end
		end
		--[=[
			@return PHePluginLibraryObject
		]=]
		function PHePluginLibraryObject:WaitForPluginApp(PluginAppName:string, TRIES:number?)
			ErrorService.assert(typeof(PluginAppName) == "string", ("string expected for PluginAppName on :WaitForPluginApp, got %s. %s"):format(tostring(PluginAppName),self.Name));
			local HasApp = self:HasPluginApp(PluginAppName);
			if(not HasApp)then
				TRIES = TRIES or 1;
				task.wait(TRIES/7);
				if(TRIES == 10)then
					ErrorService.tossWarn((":WaitForPluginApp is taking longer than usual for \"%s\""):format(PluginAppName));
				end;
				return self:WaitForPluginApp(PluginAppName,TRIES);
			else
				return PluginApps[PluginAppName];
			end
		end;
		--[=[
			@return PHePluginLibraryObject
		]=]
		function PHePluginLibraryObject:GetPluginApp(PluginAppName:string)
			ErrorService.assert(typeof(PluginAppName) == "string", ("string expected for PluginAppName on :GetPluginApp, got %s. %s"):format(tostring(PluginAppName),self.Name));
		end;
		--[=[]=]
		function PHePluginLibraryObject:HasStudioTool(StudioToolId:string):boolean
			ErrorService.assert(typeof(StudioToolId) == "string", ("string expected for StudioToolId on :HasStudioTool, got %s. %s"):format(tostring(StudioToolId),self.Name));
			if(self._StudioTools[StudioToolId])then
				return true;
			else
				return false;
			end
		end;
		--[=[
			@return PHePluginStudioTool
		]=]
		function PHePluginLibraryObject:WaitForStudioTool(StudioToolId:string, TRIES:number?)
			ErrorService.assert(typeof(StudioToolId) == "string", ("string expected for StudioToolId on :WaitForStudioTool, got %s. %s"):format(tostring(StudioToolId),self.Name));
			local HasApp = self:HasStudioTool(StudioToolId);
			if(not HasApp)then
				TRIES = TRIES and TRIES+1 or 1;
				task.wait(TRIES/7);
				if(TRIES == 10)then
					ErrorService.tossWarn((":WaitForStudioTool is taking longer than usual for \"%s\". Make sure that you are calling :ProvideAPI() on the given studio tool, you can also pass a .api='key or boolean' in the init() return to automatically ProvideAPI."):format(StudioToolId));
				end;
				return self:WaitForStudioTool(StudioToolId,TRIES);
			else
				return self._StudioTools[StudioToolId];
			end
		end;
		--[=[
			@return PHePluginStudioTool
		]=]
		function PHePluginLibraryObject:GetStudioTool(StudioToolId:string)
			return self:WaitForStudioTool(StudioToolId);
		end;
		--[=[
			@return PHePluginStudioTool
		]=]
		function PHePluginLibraryObject:CreateStudioTool(ClassInfo:table)
			ErrorService.assert(ClassInfo and typeof(ClassInfo) == "table", ("Table expected when calling :CreatetoolbarButton, got %s"):format(typeof(ClassInfo)));
			local classObject,toolbarButton = PHePluginAppHandler.addTool(App,ClassInfo, Manifest.Name, toolbar, AppStorage, self);
			classObject._App = self;
			task.spawn(function() --> initiated is executed on a different thread, this helps with :WaitForStudioTool
				classObject:initiated(self._PHeAppPseudoHooks);
				self._PHeAppPseudoHooks = nil;
				if(classObject._mainWidget and classObject._mainWidget.Enabled)then
					classObject:launch();
					classObject.___phestudiotoollaunched=true;
				end;
			end)
			return classObject;
		end;
		--[=[]=]
		function PHePluginLibraryObject:CreateDockWidgetPluginGui(WidgetName:string,WidgetInfo:DockWidgetPluginGuiInfo):DockWidgetPluginGui
            return plugin:CreateDockWidgetPluginGui(WidgetName,WidgetInfo);
		end;
		--[=[]=]
		function PHePluginLibraryObject:CreatePluginMenu(id:any,name:string?):PluginMenu
            return plugin:CreatePluginMenu(id,name);
		end;
		--[=[]=]
		function PHePluginLibraryObject:SavePluginData(key:any,value:any)
			key = key.."-"..Manifest.Name;
			return PHePluginAppHandler._plugin:SetSetting(key,value);
		end;
		--[=[]=]
		function PHePluginLibraryObject:GetPluginData(key:any)
			key = key.."-"..Manifest.Name;
			return PHePluginAppHandler._plugin:GetSetting(key);
		end;
		--[=[]=]
		function PHePluginLibraryObject:SendNotification(t:any)
			ErrorService.assert(t and typeof(t) == "table", "Table expected when sending notification, got "..typeof(t))
			
			t.Header = t.Header and (t.Header.." - <b>"..Manifest.Name.."</b>") or "Notification - <b>"..Manifest.Name.."</b>"
			return PHePluginAppHandler._sync:SendNotification(t)
		end;
		--//Shipped with all tools
		
		local GeneratedClass = CustomClassService:Create(PHePluginLibraryObject);
		GeneratedClass.Name = Manifest.Name;
		GeneratedClass:_lockProperty("Name");
		GeneratedClass._StudioTools = {};
		
		local s,r = pcall(function()
			return require(isProperyLibrary.AppFile)(GeneratedClass);
		end);
		if(not s)then
			ErrorService.tossError("Failed to connect to $App module, make sure that the module is returning a function. RBX?: "..r)
		end;

		if(GeneratedClass.onReady)then
			GeneratedClass.onReady();
		end;
		
		if(LibraryFolder:FindFirstChild("$Docs"))then
			local _DocsStudioTool = {}
			function _DocsStudioTool.init()
				return {
					id = "auto-generated-$docs-"..Manifest.Name;
					name = Manifest.Name.." Docs";
					description = "Documentation for "..Manifest.Name;
				}
			end;
			function _DocsStudioTool:initiated()
				local App = self:_GetAppModule();

				local widgetInfo = DockWidgetPluginGuiInfo.new(
					Enum.InitialDockState.Float,
					false,   -- Widget will be initially enabled
					true,  -- Don't override the previous enabled state
					300,    -- Default width of the floating window
					300,    -- Default height of the floating window
					300,    -- Minimum width of the floating window
					300     -- Minimum height of the floating window
				);
				local mainWidget= self._App:CreateDockWidgetPluginGui("$AutoGenDocs_PHeDocs", widgetInfo);
				mainWidget.Title = Manifest.Name.." Docs"
				self._mainWidget = mainWidget;

				local Background = App.new("Frame",self._mainWidget);
				Background.BackgroundColor3 = App:GetGlobal("Theme").getCurrentTheme().Background;
				Background.Size = UDim2.fromScale(1,1);	
				
				self._enabled = false;
			end;
				function _DocsStudioTool:launch()
					--local DocPage 
					if(not GeneratedClass:HasAPI("PHeDocs"))then
						ErrorService.tossWarn("Could not build documentation from $Docs because the PHeDocs was not found.");
						return;
					end
					
					local PHeDocs = GeneratedClass:GetAPI("PHeDocs");
					PHeDocs.CreateDocumentation(LibraryFolder:FindFirstChild("$Docs")).Parent = self._mainWidget;
					
				self._mainWidget.Enabled = true;
				self._enabled = true;
			end;
			function _DocsStudioTool:open()
				self._mainWidget.Enabled = true;
				self._enabled = true;	
			end;
			function _DocsStudioTool:close()
				self._mainWidget.Enabled = false;
				self._enabled = false;	
			end;
			GeneratedClass:CreateStudioTool(_DocsStudioTool)
		end
	return GeneratedClass;
	else
		ErrorService.tossError("failed to create studio tool : "..isProperyLibrary.error)
	end
	
end

return PHePluginAppHandler;