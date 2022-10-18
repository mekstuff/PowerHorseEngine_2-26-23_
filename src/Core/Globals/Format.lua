--[=[
	@class Format
	@tag Global

	```lua
	format(1200):toNumberCommas():End() --> 1,200
	format(1000):toNumberAbbreviation():End() --> 1k
	format(1200):toNumberCommas():toNumberAbbreviation():End() --> 1.2k
	```
]=]



local Format = {}
local ErrorService = require(script.Parent.Parent.Services.ErrorService);

local months,weekdays = {'January',
	'February',
	'March',
	'April',
	'May',
	'June',
	'July',
	'August',
	'September',
	'October',
	'November',
	'December'},{
	'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'
};

--[=[
	@tag Chainable
	@return Format
]=]
function Format:concat(ConcatVal:any)
	self.Value = tostring(self.Value)..tostring(ConcatVal);
	
	return self;
end;
--[=[
	@tag Chainable
	@return Format
]=]
function Format:toNumber()
	self.Value = tonumber(self.Value);
	return self;
end
--[=[
	@tag Chainable
	@return Format
]=]
function Format:toString()
	self.Value = tostring(self.Value);
	return self;
end
--[=[
	@tag Chainable
	@return Format
]=]
function Format:atStart(State:any)
	if(not self._startstatements)then self._startstatements={};end;
	--local i = ( #self._startstatements+1);
	table.insert(self._startstatements, State);
	print(self._startstatements)
	return self;
end;
--[=[
	@tag Chainable
	@return Format
]=]
function Format:toTimeDifference(format:string)
	--format = format or ""
	if(format)then
		if(format == true)then
			format = "%02d:%02d:%02d:%02d:%02d:%02d:%02d"
		end;
	else
		--//default format
	end
	--assert(self.Values[1] and self.Values[2], "")
	local _x=true;
	if(not self.Values[1] or not self.Values[2])then
		_x=false;
		ErrorService.tossWarn("Missing argument 1 or 2 for ToTimeDifference. Format(os.time(), os.time()), Using first argument as time difference");
	end;
	
	local t = {
		{n = "seconds";d = nil;m = 60;};
		{n = "minutes";d = 60;m = 60;};
		{n = "hours";d = 3600;m = 24;};
		{n = "days";d = 86400;m = 7;};
		{n = "weeks";d = 604800;m = 5;};
		{n = "months";d = 2629743;m = 12;};
		{n = "years";d = 31556926;m = nil;};
	}
	
	local Difference = _x and self.Values[1]-self.Values[2] or self.Value;
	
	--self.Value = {};
	local s = Difference;
	--local 
	--print(s)
	local ts={};local proper = {};
	for _,v in pairs(t) do
		--local s = Difference;
		if(v.d)then
			--print(Difference,v.d)
			s = Difference/v.d;
		end;
		if(v.m)then
			s = s%v.m;
		end;
		local floor = math.floor(s);
		table.insert(proper,{
			v = floor;
			og = s;
			n = v.n;
		})
		ts[v.n]=floor;
		
		--s=math.floor(s);
		--self.Value[v.n]=s;
	end;
	self.Value = ts;
	return ts,proper;
	--return s;
end
--[=[]=]
function Format:toDateFormat(useString:boolean, shortenStrings:boolean, indicateDayAsNumber:boolean)
	if(shortenStrings == true)then shortenStrings = 3;end;
	if(not useString and shortenStrings)then
		shortenStrings = nil;
		warn("useString bool must be true to shorten strings. toDateFormat(useString, shortenStrings)");
	end

	
	assert(self._fromUnixStamp,"toDateFormat() requires format to be fromUnixStamp()\nformat(os.time()):fromUnixStamp():toDateFormat()");
	local Stamp = self._fromUnixStamp;
	
	--print(Stamp)
	local wday_ = Stamp.wday;
	local month_ = Stamp.month;
	local year_ = Stamp.year;
	local day_ = Stamp.day;
	local overrideday 
	--print(Stamp)
	
	if(useString)then
		wday_ =  shortenStrings and string.sub(weekdays[wday_],1,shortenStrings) or weekdays[wday_];
		month_ =  shortenStrings and string.sub(months[month_],1,shortenStrings) or months[month_];
	end;
	
	if(indicateDayAsNumber)then
		overrideday = "31st";
	end
	
	return useString and string.format("%s, %s %s",month_,overrideday and overrideday or wday_,year_) or string.format("%s/%s/%s",month_,wday_,year_);
	--print(wday_, month_, year_);
	
	--self.Value = string.format("%02d:%02d:%02d", Stamp.hour,Stamp.min,Stamp.sec);

	--return self.Value;	
end
--[=[]=]
function Format:toTimeFormat()
	assert(self._fromUnixStamp,"toTimeFormat() requires format to be fromUnixStamp(). format(os.time()):fromUnixStamp():toTimeFormat()");
	local Stamp = self._fromUnixStamp;
	--self.Value = string.format("%02d:%02d:%02d", Stamp.hour,Stamp.min,Stamp.sec);
	
	return string.format("%02d:%02d:%02d", Stamp.hour,Stamp.min,Stamp.sec)	
end
--[=[
	@tag Chainable
	@return Format
]=]
function Format:fromUnixStamp(is12Hour:boolean)
	local timeStamp = self.default;
	
	
	local date = os.date("*t", timeStamp);
	
	if(is12Hour)then
		date.hour = math.floor(date.hour%12);
	end
	
	self._fromUnixStamp = date;
	
	self.Value = date

	return self;
end;
--[=[
	@tag Chainable
	@return Format
]=]
function Format:atEnd(State:any)
	if(not self._endstatements)then self._endstatements={};end;
	
	table.insert(self._endstatements, State);
	
	return self;
end
--[=[
	@tag Chainable
	@return Format
]=]
function Format:toNumberCommas()
	local str = tostring(self.Value);
	
	local v = str:reverse():gsub("...","%0,",math.floor((#str-1)/3)):reverse();
	
	self.Value = v;
	return self;
end;
--[=[]=]
function Format:End()
	local val = self.Value;
	if(self._endstatements)then
		for _,statement in pairs(self._endstatements) do
			val = val..statement;
		end
	end;if(self._startstatements)then
		for i = #self._startstatements,1,-1 do
			local statement = self._startstatements[i];
			val = statement..val;
		end
	end;
	--print(val);
	setmetatable(self,{});self=nil;
	return val;
end
--[=[
	@tag Chainable
	@return Format
]=]
function Format:toNumberAbbreviation(...:any)
	local abvs = {
		"K","M","B","T","QA","QI","SX","SP","OC"
	};

	local s = tostring(math.floor(self.Value))
	
	local res = 0;
	
	if(#s < 4)then
		--print("Amount To Small To Abbrev");
		res = self.Value;
	else
		--print("Amount is being abbv");
		local val = string.sub (s,1, ((#s-1)%3)+1);
		local abvVal = math.floor((#s-1)/3);
		
		
		
		local abv = abvs[abvVal] or "?";
		
		--local ignores = typeof(...) == "table" and ... or {...};
		local ignores = {...}
		if(table.find(ignores, abv))then
			res = self.Value;
		else
			res = val..abv;
		end
		
	end
	
	self.Value = res;
return self;
end

local statements = {};

return function(...)
	local t = {};
	local proxy = {};
	proxy.Value = ...
	proxy.Values = {...};
	proxy.default = ...
	return setmetatable(t, {

		__newindex = function(t,k,v)
			proxy[k]=v;
		end,
		__tostring = function()
			return tostring(proxy.Value);
		end,
		__index = function(t,k) 
			--print("Indexed");
			
			if(not Format[k])then
				--print(k);
				if(proxy[k])then return proxy[k];end;
				--return proxy.Value;
			else
				return Format[k];
			end;
	end; });
end;