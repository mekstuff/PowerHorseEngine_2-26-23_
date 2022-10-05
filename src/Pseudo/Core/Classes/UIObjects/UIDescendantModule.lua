local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local UIDescendantModule = {
	__PseudoBlocked = true;
	Name = "UIDescendantModule";
	ClassName = "UIDescendantModule";

};

local function getProps(Obj)
	local props = nil;
		if(Obj:IsA("TextLabel") or Obj:IsA("TextButton"))then props= {
			"TextTransparency"
			}elseif(Obj:IsA("Frame"))then props = {
			"BackgroundTransparency"
			};elseif(Obj:IsA("ImageLabel"))then props = {
			"ImageTransparency"
			};
		end;
	return props
	
end

function UIDescendantModule:_StoreDescendants(Ref)
	Ref = Ref or self:GetRef();
	self._dev._desc = {};
	for _,v in pairs(Ref:GetDescendants()) do
		wait();
		local valid = getProps(v);
		if(valid)then
			self._dev._desc[v]=valid;
		end
	end
end

function UIDescendantModule:_GetDescendants(Ref)
	--Ref = Ref or self:GetRef();
	return self._dev._desc
end;

function UIDescendantModule:_Listen(Ref)
	Ref = Ref or self:GetRef();
	self._dev._DescendantAddedListener = Ref.DescendantAdded:Connect(function(descendant)
	
		local props = getProps(descendant);
		if(props and self._dev._desc)then
			print("added: ",descendant)
			self._dev._desc[descendant]=props;
		end
	end);
	self._dev._DescendantRemovingListener = Ref.DescendantRemoving:Connect(function(descendant)
		if(self._dev._desc and self._dev._desc[descendant])then
			print("removing: ",descendant)
			self._dev._desc[descendant]=nil;
		end
	end);
end;

return UIDescendantModule
