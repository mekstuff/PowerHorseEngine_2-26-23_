local module = {}

function module:GetWordsFromString(String,StartCapture,EndCapture)
	if(not StartCapture)then return String:split(" ");end;
	local Words = {};
	local toFormatBack = {};
	
	local Capture = StartCapture.."[%w%s%p]-"..EndCapture;

	for q in String:gmatch(Capture) do
		local subbed = q:gsub("%s","_"):gsub(StartCapture,""):gsub(EndCapture,"");
		local qforFormat = q:gsub(StartCapture,StartCapture):gsub(EndCapture,EndCapture);	
		String = String:gsub(qforFormat, subbed);
		table.insert(toFormatBack, subbed)
	end;
	for x in String:gmatch("[%p%w]+")do
		local find = table.find(toFormatBack,x);
		if(find)then
			x = x:gsub("_"," ");
		end;
		table.insert(Words, x);
	end;
	return Words
	--return Unpack and unpack(Words) or Words;
end

function module:GetWordAtPosition(String,i)
	local ns = String:find("%s",i) or #String+1;
	local fnsb = String:sub(1,ns-1);
	local fnsbr = fnsb:reverse();
	local nspr = fnsbr:find("%s") or #fnsbr+1;
	local nss = fnsbr:sub(1,nspr-1):reverse();
	return nss, (ns-nspr)+1, ns-1;
end

function module:GetTags(txt,returnWithNoTags)
	local res = {};
	
	--local pattern = "()<([%a]+)%s*([%w%p%s]*)>(%w*)</(%a+)>()";
	local pattern = "()<([%a]+)%s*(.-)>(.-)</(%a+)>()";
	
	for tagStart,tagType,tagProps,tagValue,tagClose,tagEnd in txt:gmatch(pattern) do
		local t = {};

		for a,b in tagProps:gmatch("(%w+)=*([%w%p]*)")do t[a]=b ~= "" and b or true;end;

		tagProps=t;
		--print(tagProps);
		tagEnd-=1
		table.insert(res, {
			type = tagType,
			props = tagProps,
			value = tagValue,
			close = tagClose,
			starts = tagStart,
			ends = tagEnd,
			capture = txt:sub(tagStart,tagEnd);
		})
		
	end;
	local notags;
	if(returnWithNoTags)then
		notags = txt;
		for _,v in pairs(res)do
			notags = notags:gsub(v.capture,"");
		end;
	end;
	--print(res)
return res,notags;
end;

return module
