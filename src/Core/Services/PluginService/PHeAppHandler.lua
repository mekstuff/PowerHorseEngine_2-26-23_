local m = {};

function m.IsProperLibrary(libFile)
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
function m.getModulesfolder()
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
	local m = Instance.new("Folder");
	m.Name = currModname;
	m.Parent = game:GetService("ServerStorage");
	modulesFolder = m;
	return m;
end;

function m.addTool(App,ToolData,ManifestName,toolbar)
	-- local App = m._app;
	local PHeModules = m.getModulesfolder();
	-- if(not PHeModules)then
	-- 	local m = Instance.new("Folder");
	-- 	m.Name = ".lanzoinc";
	-- 	m.Parent = game:GetService("ServerStorage");
	-- 	PHeModules = m;
	-- end;


	local ImageProvider = App:GetProvider("ImageProvider");
	local ErrorService = App:GetService("ErrorService");
	local CustomClassService = App:GetService("CustomClassService");
	
	ToolData._Render = function()
		return{};
	end
	
	ErrorService.assert(ToolData.init, "init function missing from tool data, the init function is responsible for returning a table containing the tool data, such as id,name,description etc...");
	--ErrorService.assert(ToolData._Render, "missing _Render method from tool data, a render method must be passed");
	-- ErrorService.assert(ToolData.launch, "missing launch method from tool data, tool:launch is called whenever the button for the tool is first clicked, you should set self._enabled = true here also (:open method is not called during launch)");

	
	ErrorService.assert(ToolData.open, "missing open method from tool data, the open method is triggered whenever the button is pressed and self._enabled = false. you should set self._enabled to true so our system knows that it was opened");
	ErrorService.assert(ToolData.close, "missing close method from tool data, the closed method is triggered whenever the button is pressed and self._enabled = true. you should set self._enabled to false so our system knows that it was closed");
	ErrorService.assert(ToolData.initiated, "missing initiated method from tool data, this is triggered whenever the tool was initiated from tool.init");
	
	
	if(not ToolData.launch)then
		ToolData.launch = ToolData.open;
	end
	--ErrorService.assert(ToolData.start, "missing start method from tool data, this is triggered whenever the tool has started");
	
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

	

	-- local toolbar = m._toolbar;
	
	ToolData.ClassName = ToolData.ClassName or data.name;
	
	local ToolClass = CustomClassService:Create(ToolData);
	ToolClass.Parent = m._container;

	
	local ToolClassButton;
	--local MoreButtonExists=false;

	--[[
	if(data.toolboxbutton)then
		if(TotalButtons >= MaxVisibleButtons and not ToolsIgnoreLimit)then
	
			if(not MoreButtonsContainer)then
				MoreButtonsContainer = m.CreatePHeLibraryObject(script:FindFirstChildWhichIsA("Folder"),nil,true);
			end;
			
			local API = MoreButtonsContainer:GetAPI(MoreButtonsContainer.Name);
			ToolClassButton = API:CreateButton(data);
	
			--//Remove when we creaate click for buttons
			ToolClassButton:AddEventListener("Click",true,ToolClassButton.MouseButton2Down);
			TotalButtons+=1;
		else
			 TotalButtons+=1;
			 ToolClassButton = data.toolboxbutton and toolbar:CreateButton(data.id.."-"..tostring(math.random()),data.desc or "", ImageProvider:GetImageUri(data.icon) or ImageProvider:GetImageUri("ico-mdi@alert/error_outline"), data.name);
			 ToolClass._dev.button = ToolClassButton;
		end;
	
	end
	]]

	-- print(toolbar:GetChildren())
    ToolClassButton = data.toolboxbutton and toolbar:CreateButton(data.id.."-"..tostring(math.random()),data.desc or "", ImageProvider:GetImageUri(data.icon) or ImageProvider:GetImageUri("ico-mdi@alert/error_outline"), data.name);
    ToolClass._dev.button = ToolClassButton;
	
	
	--if(ToolClassButton)then ToolClass+=1;end;
	
	--ToolClass._dev.plugin = IsCore and m._plugin;
	--ToolClass._dev.sync = IsCore and m._sync;
	ToolClass._dev.info = data;
	ToolClass._enabled = false;
	ToolClass._storage = AppStorage;
	

	-- m.createToolStorages(data.id,ToolClass);
	
	--ToolClass:initiated();

	--local launched=false;
	if(data.toolboxbutton)then
		ToolClassButton.Click:Connect(function()
			if(not ToolClass.___phestudiotoollaunched)then
				ToolClass.___phestudiotoollaunched=true;
				ToolClass:launch();
				if(ToolClass._mainWidget)then
					ToolClass._mainWidget:BindToClose(function()
						ToolClass:close();
					end)
				end
				return;
			end;
			if(ToolClass._enabled)then
				ToolClass:close();
			else
				ToolClass:open();
			end
		end)
	end
	return ToolClass, ToolClassButton;
end;

function m.CreatePHeLibraryObject(LibraryFolder,toolbar,plugin)
    local App = require(script.Parent.Parent.Parent.Parent);
	-- local App = m._app;
	local ErrorService = App:GetService("ErrorService");
	local CustomClassService = App:GetService("CustomClassService");
	
	local isProperyLibrary = m.IsProperLibrary(LibraryFolder);
	if(isProperyLibrary.success)then
		local Manifest = require(LibraryFolder["$Manifest"]);
		-- ErrorService.assert(InstalledStudioTools[Manifest.Name] == nil, Manifest.Name.." was already registered/installed as an existing PHe App. if you tried installing with PHePM, run \"PHePM uninstall "..Manifest.Name.."\" then reinstall it.");
		-- ErrorService.assert(Manifest.Name == LibraryFolder.Name, ("Manifest name mismatch, the name provided in your manifest is different from the library folder name. Manifest's name : %s || Folder's name : %s"):format(Manifest.Name, LibraryFolder.Name))
		--//
		-- InstalledStudioTools[Manifest.Name]=Manifest;
		-- ClassHandler = ClassHandler or {};
        local ClassHandler = {};
		
		--local GeneratedClassData = {
		ClassHandler.Name = Manifest.Name;
		ClassHandler.ClassName = ClassHandler.ClassName or "PHePluginLibraryObject";
		ClassHandler.onReady = "**function";
		
		--};

		function ClassHandler:_Render()
			return {}
		end;

		--//Shipped with all tools
		function ClassHandler:CreateStudioTool(ClassInfo)
			ErrorService.assert(ClassInfo and typeof(ClassInfo) == "table", ("Table expected when calling :CreatetoolbarButton, got %s"):format(typeof(ClassInfo)));
			
			
			local classObject,toolbarButton = m.addTool(App,ClassInfo, Manifest.Name, toolbar);
			classObject._App = self;
			classObject:initiated();
			if(classObject._mainWidget and classObject._mainWidget.Enabled)then
				classObject:launch();
				classObject.___phestudiotoollaunched=true;
			end
			
			return classObject;
		end;

		function ClassHandler:CreateDockWidgetPluginGui(WidgetName,WidgetInfo)
            return plugin:CreateDockWidgetPluginGui(WidgetName,WidgetInfo)
			-- return m.CreateDockWidgetPluginGui("pluginWidget"..Manifest.Name.."-"..WidgetName,WidgetInfo,plugin);
		end;
		function ClassHandler:CreatePluginMenu(id,name)
            return plugin:CreatePluginMenu(id,name);
			-- return m._plugin:CreatePluginMenu(tostring(id)..Manifest.Name,name,plugin);	
		end;
		function ClassHandler:SavePluginData(key,value)
			key = key.."-"..Manifest.Name;
			return m._plugin:SetSetting(key,value);
		end;
		function ClassHandler:GetPluginData(key,value)
			key = key.."-"..Manifest.Name;
			return m._plugin:GetSetting(key);
		end;
	--[[
		function ClassHandler:UpdatePluginData(key,value,secKey)
			local dataExists = self:GetPluginData(key);
			
			if(not dataExists)then self:SavePluginData(key,value);end;
			
			local isTable = typeof(dataExists) == "table";
			if(isTable)then
				print("updating table")
			else
				self:SavePluginData(key,value);
			end
			
			--key = key.."-"
		end
		]]
		
		function ClassHandler:SendNotification(t)
			ErrorService.assert(t and typeof(t) == "table", "Table expected when sending notification, got "..typeof(t))
			
			t.Header = t.Header and (t.Header.." - <b>"..Manifest.Name.."</b>") or "Notification - <b>"..Manifest.Name.."</b>"
			return m._sync:SendNotification(t)
		end;
--[[
		function ClassHandler:RegisterAPI(ApiFile)
			ErrorService.assert(ApiFile and typeof(ApiFile) == "table", ("table expected for api file, got %s"):format(typeof(ApiFile)));
			local ApiAlreadyRegistered = APIs[Manifest.Name];
			if(ApiAlreadyRegistered)then
				return ErrorService.tossError(("API '%s' was already registered as an api."):format(Manifest.Name))
			end;
	
			APIs[Manifest.Name]=ApiFile;
			return self:GetAPI(Manifest.Name);
		end;
		
		function ClassHandler:WaitForAPI(APIName,Time)
			if(APIs[APIName])then return self:GetAPI(APIName);end;
			local timeSpent = 1;
			Time = Time or 10;
			--local API;
			repeat 
				timeSpent+=1;
				wait(1);
			until APIs[APIName] or timeSpent >= Time;
			
			return (self:GetAPI(APIName));
		end
		
		function ClassHandler:HasAPI(ApiName)
			--ApiName = ApiName or Manifest.Name;
			return APIs[ApiName];
		end
		
		function ClassHandler:GetAPI(ApiName)
			local API = APIs[ApiName];
			ErrorService.assert(API, ("'%s' has not been registered as a api, this may be due to the fact that the library is not installed, make sure to add the library to your $Dependencies module"):format(ApiName));
			
			--return API
			
			UniqueAPIs[Manifest.Name] = UniqueAPIs[Manifest.Name] or {};
			local SpecialAPIClass = UniqueAPIs[Manifest.Name][ApiName]
			
			if(not SpecialAPIClass) then
				local c = {
					Name = "APIObject"..ApiName;
					ClassName = "APIObject"..ApiName;
				};
				--c.__registeredFor = Manifest.Name;
				function c:_Render()
					return {};
				end;
			--//
				for name,object in pairs(API) do
					if(name ~= "ClassName" or name ~= "_Render")then
						c[name]=object;
					end
				end;
				
				
				function c:_getIsOwner()
					if("APIObject"..Manifest.Name == self.ClassName)then
						return true
					else
						return false;
					end;
				end
				function c:GetCurrentAppUsingAPI(APIPseudo)
					-- print(APIPseudo)
					ErrorService.assert(APIPseudo and typeof(APIPseudo) == "table", ("Expected Pseudo API Object When Calling :GetCurrentAppUsingAPI, got %s"):format(typeof(APIPseudo)));
					if(not self:_getIsOwner())then return ErrorService.tossWarn("GetCurrentAppUsingAPI can only be called by the API which created it");end; 
					return APIPseudo.__registeredFor;
				end
				local _class = CustomClassService:Create(c);
				_class.__registeredFor = Manifest.Name;
				
				UniqueAPIs[Manifest.Name][ApiName] = _class;
			end;
	
			return UniqueAPIs[Manifest.Name][ApiName]
			
		end
		]]
		--//Shipped with all tools
		
		
		local GeneratedClass = CustomClassService:Create(ClassHandler);	
		
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
		--end)coroutine.resume(thread);
		end
	return GeneratedClass;
	else
		ErrorService.tossError("failed to create studio tool : "..isProperyLibrary.error)
	end
	
end

return m;