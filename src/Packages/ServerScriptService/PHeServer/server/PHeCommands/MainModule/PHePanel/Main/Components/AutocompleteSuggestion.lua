local App = _G.App;

return function(Header,Body,noLinebreak)
	local GridRespect = Instance.new("Frame");
	GridRespect.AutomaticSize = Enum.AutomaticSize.XY;
	GridRespect.BackgroundTransparency = 1;
	local Container = App.new("Frame",GridRespect);
	Container.BackgroundTransparency = 1;
	local Toast = App.new("Toast",Container);
	Toast.Header = Header;
	Toast.HeaderTextColor3 = Color3.fromRGB(255, 133, 124)
	Toast.Body = Body;
	Toast.Name = "AwesomeToast";
	Toast.xMax = 600;
	Toast.BackgroundTransparency = .1;
	if(not noLinebreak)then
		local Linebreak = App.new("LineBreak",GridRespect);
	end;
	
	local BodyText = Toast:GET("BodyText");
	local HeaderText = Toast:GET("HeaderText");
	
	BodyText.RichText=true;HeaderText.RichText=true;
	
	return GridRespect,Toast;

end