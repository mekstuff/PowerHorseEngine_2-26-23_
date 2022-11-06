--[=[
	@class PHePluginAppHandler
]=]
local PHePluginAppHandler = {};

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
function PHePluginAppHandler.addTool(App:table,ToolData:table,ManifestName:string,toolbar:PluginToolbar)
	local PHeModules = PHePluginAppHandler.getModulesfolder();

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
	end

	local data = ToolData.init();
	
	ErrorService.assert(data and data.id, "id missing from init function return, you are required to pass a unique identifier e.g return{ id = example-id-for-my-special-app}");
	data.id = ManifestName.."-"..data.id;
	data.name = data.name or data.id;
	if(data.toolboxbutton == nil)then data.toolboxbutton = true;end;

	local AppStorage = PHeModules:FindFirstChild(data.id);
	if(not AppStorage)then
		local s = Instance.new("Folder");
		s.Name = data.id;
		s.Parent = PHeModules;
		AppStorage = s;
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
	local PHePluginStudioTool = CustomClassService:Create(ToolData);
	PHePluginStudioTool.Parent = PHePluginAppHandler._container;

	local ToolClassButton;
    ToolClassButton = data.toolboxbutton and toolbar:CreateButton(data.id.."-"..tostring(math.random()),data.desc or "", ImageProvider:GetImageUri(data.icon) or ImageProvider:GetImageUri("ico-mdi@alert/error_outline"), data.name);
    PHePluginStudioTool._dev.button = ToolClassButton;
	PHePluginStudioTool._dev.info = data;
	PHePluginStudioTool._enabled = false;
	PHePluginStudioTool._storage = AppStorage;
	
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
    local App = require(script.Parent.Parent.Parent.Parent);
	-- local App = PHePluginAppHandler._app;
	local ErrorService = App:GetService("ErrorService");
	local CustomClassService = App:GetService("CustomClassService");
	
	local isProperyLibrary = PHePluginAppHandler.IsProperLibrary(LibraryFolder);
	if(isProperyLibrary.success)then
		local Manifest = require(LibraryFolder["$Manifest"]);
		
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

		function PHePluginLibraryObject:_Render()
			return {}
		end;

		--//Shipped with all tools

		--[=[
			@return PHePluginStudioTool
		]=]
		function PHePluginLibraryObject:CreateStudioTool(ClassInfo:table)
			ErrorService.assert(ClassInfo and typeof(ClassInfo) == "table", ("Table expected when calling :CreatetoolbarButton, got %s"):format(typeof(ClassInfo)));
			
			local classObject,toolbarButton = PHePluginAppHandler.addTool(App,ClassInfo, Manifest.Name, toolbar);
			classObject._App = self;
			classObject:initiated();
			if(classObject._mainWidget and classObject._mainWidget.Enabled)then
				classObject:launch();
				classObject.___phestudiotoollaunched=true;
			end
			
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
		function PHePluginLibraryObject:GetPluginData(key:any,value:any)
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
		
		local s,r = pcall(function()
			return require(isProperyLibrary.AppFile)(GeneratedClass);
		end);
		if(not s)then
			ErrorService.tossError("Failed to connect to $App module, make sure that the module is returning a function. RBX?: "..r)
		end
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
					PHeDocs.CreateDocumentation(LibraryFolder["$Docs"]).Parent = self._mainWidget;
					
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