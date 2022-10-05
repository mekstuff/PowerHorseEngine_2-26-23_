local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");

local UIMaterial = {
	Name = "UIMaterial";
	ClassName = "UIMaterial";
	TileTextureId = "";--http://www.roblox.com/asset/?id=7772185415
	TileTextureInterval = 30;
	TileTextureTransparency = .75;
	TileTextureSpeed = 5;
	--TileTextureSpeed = 
};
UIMaterial.__inherits = {}


function UIMaterial:_Render(App)
	
	local MaterialContents = {};
	local TargetParent;
	local UIMaterialRender;
	
	--set the easing style and direction to what you like
	
	return {
		["*Parent"] = function(Value)
			if(not Value:IsA("BaseGui"))then
				warn("Tried to parent UIMaterial to non BaseGui/Compatible object. ["..Value.Name.."]");
			else
				TargetParent = Value:GetGUIRef();
				for _,v in pairs(MaterialContents) do
					Value.ClipsDescendants = true;
					v.Parent = Value:GetGUIRef();
				end;
				
			end
		end,
		["TileTextureTransparency"] = function(Value)
			if(MaterialContents["TileTexture"])then
				MaterialContents["TileTexture"].ImageTransparency = Value;
			end
		end,
		["TileTextureInterval"] = function(Value)
			if(MaterialContents["TileTexture"])then
				MaterialContents["TileTexture"].TileSize = UDim2.fromOffset(Value,Value);
			end
		end,
		["TileTextureId"] = function(Value)
			if(Value == "")then 
				if(MaterialContents["TileTexture"])then
					MaterialContents["TileTexture"]:Destroy();MaterialContents["TileTexture"]=nil;end;
				return;
			end;
			
			if(not MaterialContents["TileTexture"])then
				local Texture = Instance.new("ImageLabel");
				Texture.Name = "TileTexture_UIMaterial";
				Texture.Size = UDim2.fromScale(2,2);
				Texture.ScaleType = Enum.ScaleType.Tile;
				Texture.ImageTransparency = self.TileTextureTransparency;
				Texture.TileSize = UDim2.fromOffset(self.TileTextureInterval,self.TileTextureInterval);
				Texture.BackgroundTransparency = 1;
				MaterialContents["TileTexture"]=Texture;
				Texture.Parent = TargetParent;
			if(TargetParent)then TargetParent.ClipsDescendants = true;end;
				
			
				
				local Thread = coroutine.create(function()
					while true do
						Texture.Position = UDim2.fromScale(-1);
						local Anim = TweenService:Create(Texture, TweenInfo.new(self.TileTextureSpeed,Enum.EasingStyle.Linear),{Position = UDim2.fromScale(0,-1)});
						Anim:Play();
						Anim.Completed:Wait();
					end;
				end)coroutine.resume(Thread);
				
			end;
			
			MaterialContents["TileTexture"].Image = Value;
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return UIMaterial
