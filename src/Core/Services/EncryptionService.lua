--[=[
	@class EncryptionService
]=]
local EncryptionService = {};

local ASCIICharsSupported = require(script.Parent.Parent.Parent.Pseudo.Core).ASCIICharsSupported;

local genCodeAtLen;

local function genkeyatlen(len)
	local t = {};
	for i = 1,len do
		local r=math.random(1,10);
		table.insert(t,r)
	end;
	return table.concat(t,"");
end

--[=[]=]
function EncryptionService:g256enc():string
	return genkeyatlen(128);
end;

--[=[]=]
function EncryptionService:Encrypt(str:any,enckey:any)
	enckey = enckey or EncryptionService:g256enc();
	print(enckey)

	--[[
	enckey = enckey or EncryptionService:g256enc();
	for i,char in ipairs(str:split("")) do
		
	end;
	]]
end;

--[=[]=]
function EncryptionService:Decrypt(enc:any,key:any)
	
end;

return EncryptionService;