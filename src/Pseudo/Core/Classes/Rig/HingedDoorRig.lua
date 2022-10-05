local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");


local HingedDoorRig = {
	Name = "HingedDoorRig";
	ClassName = "HingedDoorRig";
	RotationalDegress = 75;
};
HingedDoorRig.__inherits = {"DoorRig"}


function HingedDoorRig:_Render(App)
	
	self:_InitDoorRig()
	
	local HingeCache;
	local HingeCFValue;
	
	
	return {
		["RotationalDegress"] = function(Value)
			if(Value > 90)then
				delay(.1,function()
					self.RotationalDegress = 90;
				end)
			end
		end,
		["Activated"] = function(Value)
			if(IsClient)then return end;
			
			local Door = self.Parent;
			if(not Door)then return end;
			
			local DoorHinge = HingeCache or Door:FindFirstChild("Hinge") or Door:FindFirstChild("Hinge",true);
			if(DoorHinge and not HingeCache)then
			
				HingeCache = DoorHinge;
				HingeCFValue = Instance.new("CFrameValue", DoorHinge);
				--HingeCFValue.Value = DoorHinge.CFrame;
				HingeCFValue.Name = "CFrame->TweenServiceSupport";
				
				local x,y,z = DoorHinge.CFrame:ToOrientation();
			end;	
			if(not DoorHinge)then warn("Could not find a door hinge for hinged door. The hinge must be named \"Hinge\" ");return;end;
			
		
			
			if(Value == true)then
				
				--wait();
				
				local ValueBefore = HingeCFValue.Value;

				local _,yBefore = ValueBefore:ToEulerAnglesXYZ();

				yBefore = math.deg(yBefore);
				
				HingeCFValue.Value = DoorHinge.CFrame;
				local Tween = TweenService:Create(HingeCFValue, TweenInfo.new(self.AnimationSpeed), {Value = DoorHinge.CFrame * CFrame.Angles(0,math.rad(self.RotationalDegress+yBefore),0)});
				
				self._dev._ChangedSignalA = HingeCFValue:GetPropertyChangedSignal("Value"):Connect(function()
					DoorHinge.CFrame = HingeCFValue.Value;
				end)
				Tween:Play();
				
				do	
					Tween.Completed:Connect(function()
						self._dev._ChangedSignalA:Disconnect();
						self._dev._ChangedSignalA=nil;
					end)
				end;
				
				--DoorHinge.CFrame = );
			else
				
				--wait();
				
				local ValueBefore = HingeCFValue.Value;
				
				local _,yBefore = ValueBefore:ToEulerAnglesXYZ();
				
				yBefore = math.deg(yBefore);
				
				--print(yBefore);
				
				--if(yBefore >= 90)then
					
				--	yBefore = 180 - (yBefore);
				--else
				--	--yBefore = yBefore;
				--end
				
				
				--print(self.RotationalDegress + yBefore);
				
				HingeCFValue.Value = DoorHinge.CFrame;
				local Tween = TweenService:Create(HingeCFValue, TweenInfo.new(self.AnimationSpeed), {Value = DoorHinge.CFrame * CFrame.Angles(0,math.rad(yBefore),0)});

				self._dev._ChangedSignalB = HingeCFValue:GetPropertyChangedSignal("Value"):Connect(function()
					DoorHinge.CFrame = HingeCFValue.Value;
				end)
				Tween:Play();

				Tween.Completed:Connect(function()
					self._dev._ChangedSignalB:Disconnect();
					self._dev._ChangedSignalB=nil;
				end)
				
			end
		
		end,	
	};
	
end;


return HingedDoorRig
