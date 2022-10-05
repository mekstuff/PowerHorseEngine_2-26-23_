local Math = {}

function Math.quadbez(t,p0,p1,p2)
	t = t or 0;p0=p0 or 0;p1=p1 or 0;p2 = p2 or 0;
	return (1-t)^2*p0+2*(1-t)*t*p1+t^2*p2;
end;

--//Default internal math functions
function Math.floor(...)
	return math.floor(...)
end;

return Math
