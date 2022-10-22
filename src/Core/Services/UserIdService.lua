--[=[
	@class UserIdService
]=]
local UserIdService = {}
local Players = game:GetService("Players");
local ErrorService = require(script.Parent.ErrorService);

local cache = {
	id = {};
	name = {};
}

--[=[
	Safer method than .getUsername since this will return a promise
	@return Promise
]=]
function UserIdService:GetUsername(obj:Player|string|number):Instance
	local App = require(script.Parent.Parent.Parent);
	local Promise = App.new("Promise"):Try(function(resolve,reject)
		local res = UserIdService.getUsername(obj);
		resolve(res);
	end);
	
	return Promise;
end;
--[=[
	Safer method than .getUserId since this will return a promise
	@return Promise
]=]
function UserIdService:GetUserId(obj:Player|string|number):Instance
	local App = require(script.Parent.Parent.Parent);
	local Promise = App.new("Promise"):Try(function(resolve,reject)
		local res = self.getUserId(obj);
		if(res)then
			resolve(res);
		end
	end);
	return Promise;
end;
--[=[
	@yields
	@error HTTP Failure -- This function does not handle failing, use `:GetUserId` for a more safer route.
]=]
function UserIdService.getUserId(obj:Player|string|number):number?
	if(cache.id[obj])then
		return cache.id[obj];
	end
	local id;
	if(typeof(obj) == "Instance")then
		local s = game:GetService("Players"):FindFirstChild(obj.Name);
		if(s)then id = obj.UserId;end;
	elseif(typeof(obj) == "string") then
		local ran,results = pcall(function()
			return Players:GetUserIdFromNameAsync(obj);
		end);if(not ran)then ErrorService.tossError("UserIdService Internal Error -> "..results) 
		else
			id = results
		end;
		--id = results;
	elseif(typeof(obj) == "number")then
		if(UserIdService.getUsername(obj))then 
			id = obj; 
		end
	end;
	if(not id)then ErrorService.tossError("UserIdService failed to retrieve UserId from "..tostring(obj));
	else
		if(typeof(obj) ~= "Instance")then
			cache.id[obj]=id; --< Doesn't cache instances (garbage collection)
		end
	end;
	return id;
end;
--[=[
	@yields
	@error HTTP Failure -- This function does not handle failing, use `:GetUsername` for a more safer route.
]=]
function UserIdService.getUsername(obj:Player|string|number):string?
	if(cache.name[obj])then
		return cache.name[obj];
	end
	local name;
	if(typeof(obj) == "Instance")then
		name = game:GetService("Players"):FindFirstChild(obj.Name);
	elseif(typeof(obj) == "number") then
		local ran,results = pcall(function()
			return Players:GetNameFromUserIdAsync(obj);
		end);if(not ran)then ErrorService.tossError("UserIdService Internal Error -> "..results)
		else 
			name = results;
		end;
	
	elseif(typeof(obj) == "string")then
		if(UserIdService.getUserId(obj))then 
			name = obj; 
		end
	end;
	if(not name)then ErrorService.tossError("UserIdService failed to retrieve UserId from "..tostring(obj));
	else
		if(typeof(obj) ~= "Instance")then
			cache.name[obj]=name; --< Doesn't cache instances (garbage collection)
		end
	end;
	return name;
end

return UserIdService
