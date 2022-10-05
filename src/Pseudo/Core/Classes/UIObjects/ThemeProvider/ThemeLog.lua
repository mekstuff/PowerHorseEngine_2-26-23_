return {
	["Primary"] = {
		["Checkbox"] = function(x,v)
			x.BackgroundColor3 = v;
		end,
		["Button"] = function(x,v)
			x.BackgroundColor3 = v;
		end,
		["Widget"] = function(x,val)
			x.WidgetColor = val;
		end,
		
	};
	["TextColor3"] = {
		["Text"] = function(x,val)
			x.TextColor3 = val;
		end,["Button"] = function(x,val)
			x.TextColor3 = val;
		end,--[[["Badge"] = function(x,val)
			x.TextColor3 = val;
		end,]]["CloseButton"] = function(x,val)
			x.Color = val;
		end,--[[["SubtitleText"] = function(x,val)
			x.TextColor3 = val;
		end,]]["Toast"] = function(x,val)
			x.HeaderTextColor3 = val;
			x.BodyTextColor3 = val;
		end,
	};
	["BackgroundColor3"] = {
		["Widget"] = function(x,v)
			x.BackgroundColor3=v;
		end,
		["ToolTip"] = function(x,v)
			x.BackgroundColor3=v;
		end,
		["Frame"] = function(x,v)
			x.BackgroundColor3 = v;
		end,
	}

	

}