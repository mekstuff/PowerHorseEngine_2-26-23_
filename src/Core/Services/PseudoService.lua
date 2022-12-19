--[=[
	@class PseudoService
]=]
local PseudoService = {}
local Pseudo = script.Parent.Parent.Parent.Pseudo;
local ErrorService = require(script.Parent.ErrorService);

local Conversions = {
	["ScreenGui"] = "Portal";
	["TextLabel"] = "Text";
	["TextButton"] = "Button";
}

--[=[]=]
function PseudoService:FromROBLOXObject(Instance:Instance,dontdeleteInstance:boolean?,p:Instance?):(Instance,{[any]:any})
	local InstanceClass = Instance.ClassName;
	local x={};
	if(Conversions[InstanceClass])then
		InstanceClass=Conversions[InstanceClass];
	end;
	local PseudoClasses = script.Parent.Parent.Parent.Pseudo.Core.Classes;
	local ClassSearch = PseudoClasses:FindFirstChild(Instance.Name, true);
	
	if(not ClassSearch)then
		ClassSearch = PseudoClasses:FindFirstChild(InstanceClass,true);
	end;
	
	InstanceClass = ClassSearch.Name;
	if(not p)then p = Instance.Parent;end;
	
	local parent;
	if(ClassSearch)then
		local Pseudo = require(script.Parent.Parent.Parent.Pseudo);
		local new = Pseudo.new(Instance:GetAttribute("Class") or InstanceClass);
		new.Parent = p;
		parent = new;
		
		if(new:IsA("BaseGui") and Instance:IsA("GuiObject"))then
			new.AnchorPoint = Instance.AnchorPoint;new.Position = Instance.Position;new.Size = Instance.Size;new.Visible = Instance.Visible;
		end;
		
		local Attr = Instance:GetAttributes();
		for a,b in pairs(Attr)do
			local s,e = pcall(function()
				new[a]=b;
			end);
			if(not s and a ~= "Class")then
				ErrorService.tossWarn("PseudoService:FromROBLOXOjbect("..Instance.Name..") cannot apply attr property \""..a.."\" to pseudo "..new.ClassName..". Are you sure you spelt the attribute properly? (properties are case sensitive)\n")
			end
		end
		
	end;
	for _,v in pairs(Instance:GetChildren()) do
		local r = PseudoService:FromROBLOXObject(v,dontdeleteInstance,parent);
		table.insert(x,r);
	end;
	if(not dontdeleteInstance)then
		Instance:Destroy();
	end;
	return parent, x;
end;
--[=[]=]
function PseudoService:GetPseudoFromId(id:Instance|StringValue|string):any
	if(typeof(id) == "Instance")then
		if(id.ClassName == "StringValue")then
			id = id.Value;
		else
			local ps = id:FindFirstChild("_pseudoid");
			if(ps)then id = ps.Value;end;
		end
	end
	return require(Pseudo).getPseudo(id);
end;

local PseudoCache;
--[=[]=]
function PseudoService:GetPseudoObjects(Specific:{[number]:string}?):{[any]:any}
	local Classes = Pseudo.Core.Classes:GetChildren();
	if(not PseudoCache )then
		PseudoCache = {};
		for _,v in pairs(Classes)do
			if(v:IsA("Folder"))then
				local n = v.Name:gsub("*","")
				PseudoCache[n] = {};
				for _,class in pairs(v:GetChildren())do
					table.insert(PseudoCache[n],class.Name);
				end;
			end
		end;
	end;
	return Specific and PseudoCache[Specific] or PseudoCache;
end;

function PseudoService:GetPseudoModule(name:string)
	return Pseudo.Core.Classes:FindFirstChild(name,true);
end;


return PseudoService
