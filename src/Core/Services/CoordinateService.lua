local IsClient = game:GetService("RunService"):IsClient();
local IsRunning = game:GetService("RunService"):IsRunning();
local Engine = require(script.Parent.Parent.Parent.Engine);
local CoordinateTeleporter = Engine:FetchStorageEvent("CoordinateTeleporter");
local CoordinateCommunicator = Engine:FetchStorageEvent("CoordinateCommunicator","RemoteFunctions");
local NotificationService = require(script.Parent.NotificationService);
local Coordinates = {};
local module = {}

local ErrorService = require(script.Parent.ErrorService);

local CooldownUsers = {}

local function handleTeleportServer(Player,Name,Category,IgnoreReserved)
	if(not Category)then
		ErrorService.tossWarn("No Category Provided For Teleporting "..Player.Name.." To "..Name..". Defaulted To The 'Unknown' Category");
		Category="Unknown";
	end;
	local isCategory = Coordinates[Category];
	if(not isCategory)then
		local e = Category.." is not a valid category or has not yet bin created."
		ErrorService.tossWarn(e);
		return {
			success = false;
			error = e
		};
	end;
	if(not isCategory[Name])then
		local e = Name.." is not a valid coordinate name for the \""..Category.."\" category."
		ErrorService.tossWarn(e);
		return {
			success = false;
			error = e;
		};
	end;
	
	local cate = isCategory[Name];
	
	if(cate.Reserved)then
		if(not IgnoreReserved)then
			if(not table.find(cate.Reserved, Player.UserId or Player.Name))then
				NotificationService:SendNotificationAsync(Player, {
					Header = "Teleportation Failed",
					Body = "Only select players can teleport to "..Name..".";
					CloseButtonVisible = true;
					LifeTime = 10;
				})
				return;
			end
		end
	end
	
	if(module.ProcessTeleportation)then
		local Process = module.ProcessTeleportation(Player,cate);
		if(not Process)then return end;
	end;
	local Character = Player and Player.Character or Player.CharacterAdded:Wait();
	if(Character)then
		local Root = Character:WaitForChild("HumanoidRootPart");
		local Human = Character:WaitForChild("Humanoid")
		if workspace.StreamingEnabled then
			--local player = pla:GetPlayerFromCharacter(character)
			Player:RequestStreamAroundAsync(cate.CFrameCoordinates);
		end
		Character:SetPrimaryPartCFrame(cate.CFrameCoordinates + Vector3.new(0, (Root.Size.Y*.5)+Human.HipHeight));
	end;
	return cate;
end

if(IsRunning and not IsClient)then
	local function handleInvoke(Player)
		local x = {};
		for Category,CategoryData in pairs(Coordinates)do
			x[Category] = {};
			for Coordinate,CoordinateData in pairs(CategoryData) do
				if(CoordinateData.Reserved)then
					if(table.find(CoordinateData.Reserved, Player.UserId or Player.Name))then
						table.insert(x[Category], CoordinateData.Name);
					--[[
						x[Category][Coordinate] = {
							Name = CoordinateData.Name;
							Category = CoordinateData.Category;
							Reserved = true;
						}
					]]
					end;
				else
					table.insert(x[Category], CoordinateData.Name);
					--[[
					x[Category][Coordinate] = {
						Name = CoordinateData.Name;
						Category = CoordinateData.Category;
					};
					]]
				end;
				
			end;		
		end;	
		return x;
	end
	
	CoordinateCommunicator.OnServerInvoke = handleInvoke;
	
	CoordinateTeleporter.OnServerEvent:Connect(function(Player,Name,Category)
		if(module.UserTeleportCooldown and CooldownUsers[Player.UserId])then
			NotificationService:SendNotificationAsync(Player, {
				Header = "Teleportation Failed",
				Body = "Slow down- Please wait"..tostring(module.UserTeleportCooldown).." (s) before trying to teleport again.";
				CloseButtonVisible = true;
				LifeTime = module.UserTeleportCooldown;
			})
			CoordinateTeleporter:FireClient(Player,{
				success = false;
				error = "cooldown";
			});
			return;
		end;
		local handle = handleTeleportServer(Player,Name,Category)
		
		CoordinateTeleporter:FireClient(Player,{
			success = handle.success or (handle.Category and true);
			contentName = handle.Name;
		})
		if(module.UserTeleportCooldown)then
			CooldownUsers[Player.UserId]=os.time();
			delay(module.UserTeleportCooldown,function()
				CooldownUsers[Player.UserId]=nil;
			end)
		end;
	end)
end;
--if(IsClient)then CoordinateTeleporter = script:WaitForChild("CoordinateTeleporter");end;

function module:AddCoordinate(CFrameCoor,Name,Category,CoordinateId,Reserved)
	assert(not IsClient, "AddCoordinate() can only be called by the server");
	Name = Name or "Coordinate "..tostring(CFrameCoor);
	Category = Category or "Unknown";
	if(not Coordinates[Category])then Coordinates[Category]={};end;
	
	CoordinateId = CoordinateId or Name;
	
	if(Coordinates[Category][CoordinateId])then ErrorService.tossError(CoordinateId.." is already an existing under the "..Category.." category.");return;end;
	
	Coordinates[Category][CoordinateId] = {
		Name = Name;
		Category = Category;
		Reserved = Reserved;
		CFrameCoordinates = CFrameCoor;
		Id = CoordinateId;
	}
	
end;

--//
function module:GetCoordinatesAsync(forTeleportService)
	local Player = game.Players.LocalPlayer;
	if(Player)then
		local fetch = CoordinateCommunicator:InvokeServer();
		if(forTeleportService)then
			local t = {};
			for name,coordinates in pairs(fetch)do
				table.insert(t,name);
				for _,x in pairs(coordinates) do
					table.insert(t,">"..x);
				end
			end;
			fetch=nil;
			return t;
		end;
		return fetch;
	else
		return Coordinates;
	end;
end;
--//
function module:TeleportAsync(Player,CoordinateName,CoordinateCategory,Transition,Notify,IgnoreReserved)
	if(IsClient)then
		if(Player ~= game.Players.LocalPlayer)then 
			Notify = Transition;
			Transition = CoordinateCategory;
			CoordinateCategory = CoordinateName;
			CoordinateName = Player;
			Player = game.Players.LocalPlayer;
		end;
		local transitioneffect;
		if(Transition)then
			transitioneffect = require(script.Parent.Parent.Parent.Pseudo).new("FadeTransition");
			transitioneffect.ShowIndicator=true;
			transitioneffect.Parent = Player:WaitForChild("PlayerGui");
		end;
		CoordinateTeleporter:FireServer(CoordinateName,CoordinateCategory);
		local catch = CoordinateTeleporter.OnClientEvent:Wait();
		if(transitioneffect)then transitioneffect:Destroy();end;
		print(catch.success, Notify)
		if(Notify and catch.success)then
			print(catch)
			require(script.Parent.NotificationBannerService):Notify(typeof(Notify) == "boolean" and "~"..catch.contentName.."~" or Notify);
		end
		return catch;
	else
		handleTeleportServer(Player,CoordinateName,CoordinateCategory,IgnoreReserved);
	end;
end;



return module
