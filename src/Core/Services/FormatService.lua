local Format = require(script.Parent.Parent.Globals.Format);

--[=[
	@class FormatService
	@tag Service
	Uses the Format Global.
]=]


local FormatService = {}

--[=[]=]
function FormatService:toNumberAbbreviation(n:number,...:any):string
	return Format(n):toNumberAbbreviation(...):End();
end;
--[=[]=]
function FormatService:toNumberCommas(n:number,...:any):string
	return Format(n):toNumberCommas(...):End();
end
--[=[]=]
function FormatService:toTimeFormat(timeStamp:number,is12Hour:boolean?):string
	return Format(timeStamp):fromUnixStamp(is12Hour):toTimeFormat():End();
end;
--[=[]=]
function FormatService:toDateFormat(timeStamp:number,useString:boolean?,shortenString:boolean?,indicateDayAsNumber:boolean?):string
	return Format(timeStamp):fromUnixStamp(true):toDateFormat(useString,shortenString,indicateDayAsNumber):End();
end;
--[=[]=]
function FormatService:toTimeDifference(t1:number,t2:number,...:any):string
	return Format(t1,t2):toTimeDifference(...):End();
end


return FormatService
