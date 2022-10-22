--[=[
	@class ErrorService
	@tag Service
]=]

local ErrorService = {}
local TestService = game:GetService("TestService");

local tossEW = {
	{error = "Failed To Create Element <t1>. \"<t1> Is Not A Valid Vanilla Element\"",short = "ftc",};
	{error = "Failed To Mount <t1>. \"<t2> Is Not A Valid Vanilla Element Or It Cannot Be Mounted To.\"",short = "fta",};
	{error = "Failed To Complete Render Because The Component Is Missing.",short = "ftcr",};
	{error = "Tried To Assign \"<t1>\" But The Property Is Readonly/Locked/Can Only Be Edited Initially.",short = "tpiro",};
	{error = "Cannot Import Type \"<t1>\", It Must Be A <t2>.",short = "cit",};
	{error = "[SendNotification] Failed. SendNotification(GuiObject: Element, Enumeration: NotificatioGroupPriority, Float: Lifetime)",short = "__sendnotificationfailed__",};
}


local function getErrorFromDataAndTranslate(errorshort:string, ...:any):string
	local Strings = {...}
	for _,x in pairs(tossEW)do
		if(x.short == errorshort)then
			local newText = x.error
			if(#Strings > 0)then
				for index,value in pairs(Strings) do
					local tElement = "<t"..tostring(index)..">";
					newText = string.gsub(newText, tElement, tostring(Strings[index]), 2);
				end
			end
			--
			return "[PowerHorseEngine][ErrorService] "..newText;
		end
	end;
	return "[PowerHorseEngine][ErrorService] "..errorshort;
end;
--//
local function sendOwnerErrorDebugMessage(n,c)
	local NotificationService = require(script.Parent.NotificationService);
	if(game.Players.LocalPlayer)then
		NotificationService:SendNotificationAsync({
			Header = "Client";
			Body = n;
			BackgroundColor3 = c;
			CloseButtonVisible = true;
		})
	else
		--[[
		NotificationService:SendNotificationAsync(game.Players:WaitForChild("MightTea"),{
			Header = "Server";
			Body = n;
			BackgroundColor3 = c;
			CloseButtonVisible = true;
		})
	]]
	end
end;

--[=[]=]
function ErrorService.tossError(errorshort:string, ...:any):nil
	--error(getErrorFromDataAndTranslate(errorshort, ...));
	local e = getErrorFromDataAndTranslate(errorshort,...);
	--sendOwnerErrorDebugMessage(e, Color3.fromRGB(241, 40, 40));
	error(e,0);
end;
--[=[]=]
function ErrorService.tossWarn(errorshort:string, ...:any):nil
	--warn(getErrorFromDataAndTranslate(errorshort,...));
	local e = getErrorFromDataAndTranslate(errorshort,...);
	--sendOwnerErrorDebugMessage(e, Color3.fromRGB(241, 182, 32))
	warn(e)
end;
--[=[]=]
function ErrorService.tossMessage(errorshort:string, ...:any):nil
	--TestService:Message(getErrorFromDataAndTranslate(errorshort,...));
	local e = getErrorFromDataAndTranslate(errorshort,...);
	--sendOwnerErrorDebugMessage(e, Color3.fromRGB(65, 174, 241))
	TestService:Message(e);
end;
--[=[]=]
function ErrorService.assert(condition:any, errorshort:string,...:any):nil
	if(not condition)then
		local e = getErrorFromDataAndTranslate(errorshort,...);
		error(e);
	end
end

return ErrorService
