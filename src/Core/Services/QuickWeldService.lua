local module = {}


function module:UnAnchorAll(Object,Ignore)
	for _,v in pairs(Object:GetChildren()) do
		if(v:IsA("BasePart"))then
		
			if Ignore and table.find(Ignore, v.Name)then
			else
				v.Anchored = false;
			end;
		elseif(v:IsA("Model"))then
			module:UnAnchorAll(v);
		end
	end
end
--//
function module:SetCanCollideAll(Object,State,Ignore)
	State = State or false;
	for _,v in pairs(Object:GetChildren()) do
		if(v:IsA("BasePart"))then
			if Ignore and table.find(Ignore, v.Name)then
			else
				v.CanCollide = State;
			end;
		elseif(v:IsA("Model"))then
			module:SetCanCollideAll(v,State);
		end
	end
end
--//
function module:AnchorAll(Object,Ignore)
	for _,v in pairs(Object:GetChildren()) do
		if(v:IsA("BasePart"))then
			if Ignore and table.find(Ignore, v.Name)then
			else
				v.Anchored = true;
			end;
		elseif(v:IsA("Model"))then
			module:UnAnchorAll(v);
		end
	end
end
--//
function module:WeldAll(Object, WeldTo, DontWeldDesc,_isDescendant)
	--local welds = {
		--direct = {};
		--descendants = {};
	--};
	
	local welds = {};
	
	if(not WeldTo)then
		WeldTo = Object:IsA("Model") and Object.PrimaryPart or Object:FindFirstChildWhichIsA("BasePart");
	end;
	
	if(Object:FindFirstChild("PHe->QuickWeld"))then return warn(Object.Name.." was already welded with quick weld") end;
	
	--local QuickWeldFolder = Instance.new("Folder",Object);
	--QuickWeldFolder.Name = "PHe->QuickWeld";
	
	for _,v in pairs(Object:GetChildren()) do
		if(v:IsA("BasePart"))then			
			local Weld = Instance.new("WeldConstraint");
			Weld.Name = v.Name.."->"..Object.Name..(_isDescendant and "->Descedant" or "");
			Weld.Part1 = v;
			Weld.Part0 = WeldTo;
			Weld.Parent = WeldTo;
			table.insert(_isDescendant or welds, Weld);
		else
			if(not DontWeldDesc)then
				if(v:IsA("Model"))then
					 module:WeldAll(v, v.PrimaryPart,DontWeldDesc,welds);
				end;
			end;
		end
	end;
	
	return welds;
	
end

return module
