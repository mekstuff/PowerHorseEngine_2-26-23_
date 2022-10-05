local PHE = game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine");for _,v in pairs(script.Parent.Parent:GetChildren())do
	if(v:IsA("Script"))then v.Disabled=false;end;
end;script:Destroy();