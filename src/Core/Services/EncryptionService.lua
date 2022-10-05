local module = {};

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

function module:g256enc()
	return genkeyatlen(128);
end;

--local 

function module:Encrypt(str,enckey)
	enckey = enckey or module:g256enc();
	print(enckey)

	--[[
	enckey = enckey or module:g256enc();
	for i,char in ipairs(str:split("")) do
		
	end;
	]]
end;

function module:Decrypt(enc,key)
	
end;

return module;