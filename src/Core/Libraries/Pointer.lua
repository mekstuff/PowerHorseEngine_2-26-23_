-- local PseudoService = require(script.Parent.Parent.Services.PseudoService);
local App = require(script.Parent.Parent.Parent);
local Theme = App:GetGlobal("Theme");
local Enumeration = App:GetGlobal("Enumeration");

local qConverts = {
	["TextButton"] = "Button",
	["ImageButton"] = "Button",
	["TextLabel"] = "Text",
	["ImageLabel"] = "Image",
	["ScreenGui"] = "Portal",
};


local SpecialStringHandlers = {
	Theme = function(Value)
		return Theme.useTheme(Value);
	end,
	ThemeColor = function(Value)
		return Theme.getCurrentTheme()[Value]
	end,
	["ENUM"] = function(Value)
		local path = Value:split(".");
		local MyEnum = Enum;
		for _,x in pairs(path) do
			MyEnum = MyEnum[x];
		end;
		return MyEnum;
	end;
	["Enum"] = function(Value)
		local path = Value:split(".");
		local MyEnum = Enumeration;
		for _,x in pairs(path) do
			MyEnum = MyEnum[x];
		end;
		return MyEnum;
	end;
}


local function createComponent(class)
	return pcall(function()
		return App.new(class);
	end);
end;

return function(instance,Parent)
	local targetClassName = instance:GetAttribute("ClassName");
	if(not targetClassName)then
		targetClassName = qConverts[instance.Name] or qConverts[instance.ClassName] or instance.ClassName;
	end;

	if(instance:GetAttribute("_Native"))then targetClassName = "..." end;

	local success,obj = createComponent(targetClassName);
	local isROBLOXCloneInstance = false;

	if(not success)then
		obj = instance:Clone();
		isROBLOXCloneInstance = true;
	end;

	local runAttributes = true;
	if(isROBLOXCloneInstance and Parent)then
		local addOn = "";
		if(Parent.ClassName == "Text")then addOn = "Text";end;
		if(instance:IsA("UIStroke"))then	
			runAttributes = false;
			Parent[addOn.."StrokeColor3"] = instance.Color;
			Parent[addOn.."StrokeThickness"] = instance.Thickness;
			Parent[addOn.."StrokeTransparency"] = instance.Transparency;
			obj:Destroy();
		elseif(instance:IsA("UICorner"))then	
			runAttributes = false;
			Parent.Roundness = instance.CornerRadius;
			obj:Destroy();
		end;
	end
	

	if(not isROBLOXCloneInstance and runAttributes)then
		for propname in pairs(obj._getCurrentPropSheetState(true,true)) do
			if(propname ~= "Parent" and propname ~= "ClassName")then
				local propinInstance = instance:GetAttribute(propname);
				if(not propinInstance)then
					pcall(function()
						propinInstance = instance[propname];
					end);
				end;
				if(propinInstance ~= nil)then
					if(typeof(propinInstance) == "string")then
						local target,value = propinInstance:match("^%$(.*):(.*)");
						if(target and value)then
							local t = SpecialStringHandlers[target];
							if(not t)then
								error("Pointer failed to compile with special string handler \""..propinInstance.."\". \""..target.."\" is not a special string handler type.")
							end;
							propinInstance = t(value);
						end
					end
					local s,r = pcall(function()
						obj[propname] = propinInstance;
					end);
					if(not s)then
						warn("PointerError: Failed to apply property \""..propname.."\" to \""..obj..". Source :",r)
					end
				end
			end
		end;
	end;

	local children = instance:GetChildren();

	for _,x in pairs(children) do
		require(script)(x,obj);
	end

	if(Parent and runAttributes)then
		if(isROBLOXCloneInstance)then
			obj.Parent = Parent:IsA("Pseudo") and Parent:_GetCompRef() or Parent;
		else
			obj.Parent = Parent;
		end
	end;


	return obj;
end

--[[
return function(instance,noDestroy,parent)
	local noDestroyThis = noDestroy;
	local targetClassName = instance:GetAttribute("ClassName");
	if(not targetClassName)then
		targetClassName = qConverts[instance.Name] or qConverts[instance.ClassName] or instance.ClassName;
	end;
	if(instance:GetAttribute("_Native"))then targetClassName = "..." end;

	local UICorner = instance:FindFirstChildWhichIsA("UICorner");
	if(UICorner)then
		instance:SetAttribute("Roundness", UDim.new(UICorner.CornerRadius.Scale,UICorner.CornerRadius.Offset));
		UICorner:Destroy();
	end;
	local UIStroke = instance:FindFirstChildWhichIsA("UIStroke");
	if(UIStroke)then
		local concat = "";
		if(instance:IsA("TextLabel"))then
			concat = "Text";
		end
		instance:SetAttribute(concat.."StrokeThickness", UIStroke.Thickness);
		instance:SetAttribute(concat.."StrokeTransparency", UIStroke.Transparency);
		instance:SetAttribute(concat.."StrokeColor3", UIStroke.Color);
		UIStroke:Destroy();
	end;

	local successPseudoBuild,Pseudo = pcall(function() return App.new(targetClassName);end);
	Pseudo = successPseudoBuild and Pseudo or nil;
	if(successPseudoBuild)then
		local props = Pseudo._getCurrentPropSheetState(true,true);
		for propname,_ in pairs(props) do
			if(propname ~= "ClassName" and propname ~= "Parent")then
				local v = instance:GetAttribute(propname);
				if(v == nil)then
					local s,r = pcall(function()
						return instance[propname]
					end);
					if(s)then v = r;end;
				end
				if(v~=nil)then
					if(typeof(v) == "string")then
						local target,value = v:match("^%$(.*):(.*)");
						-- print(target,value,v);
						if(target and value)then
							local t = SpecialStringHandlers[target];
							if(not t)then
								error("Pointer failed to compile with special string handler \""..v.."\". \""..target.."\" is not a special string handler type.")
							end;
							v = t(value);
						end
					end
					Pseudo[propname] = v;
				end;
			end;
		end;
		Pseudo.Parent = parent or instance.Parent;
	else

		if(parent)then
			instance.Parent = parent:IsA("Pseudo") and (parent:GET("FatherComponent") or parent:GET("_Appender") or parent:GetRef()) or parent;
		end;
		noDestroyThis = true;
	end
	
	local Children = instance:GetChildren();
	for _,x in pairs(Children) do
		require(script)(x,noDestroy,Pseudo or instance)
	end;
	if(not noDestroyThis)then instance:Destroy();end;
	return Pseudo;
end;
]]