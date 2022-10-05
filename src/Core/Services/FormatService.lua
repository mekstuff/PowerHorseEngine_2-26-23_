local Format = require(script.Parent.Parent.Globals.Format);

local module = {}

function module:toNumberAbbreviation(n,...)
	return Format(n):toNumberAbbreviation(...);
end
function module:toNumberCommas(n,...)
	return Format(n):toNumberCommas(...);
end

--
function module:toTimeFormat(timeStamp,is12Hour)
	return Format(timeStamp):fromUnixStamp(is12Hour):toTimeFormat();
end
function module:toDateFormat(timeStamp,useString,shortenString,indicateDayAsNumber)
	return Format(timeStamp):fromUnixStamp(true):toDateFormat(useString,shortenString,indicateDayAsNumber);
end
function module:toTimeDifference(t1,t2,...)
	return Format(t1,t2):toTimeDifference(...);
end


return module
