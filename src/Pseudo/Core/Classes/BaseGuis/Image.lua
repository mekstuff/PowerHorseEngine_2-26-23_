local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

-- local matcher = "^ico%-(%w+)@(.+)";
-- local loadedpacks = {};

-- local Iconpack;
-- local AttemptedIconPack = false;

local Image = {
	Name = "Image";
	ClassName = "Image";
	
	BackgroundTransparency = 0;
	BackgroundColor3 = Theme.getCurrentTheme().Primary;
	
	Model = "**Instance";
	ModelAngle = Vector3.new(0);
	
	Image = "";
	--Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
	ImageColor3 = Theme.getCurrentTheme().Text;
	ImageRectOffset = Vector2.new(0);
	ImageRectSize = Vector2.new(0);
	ImageTransparecy = 0;
	ResampleMode = Enum.ResamplerMode.Default;
	ScaleType = Enum.ScaleType.Fit;
	SliceScale = 1;

};
Image.__inherits = {"BaseGui","Frame"}


function Image:_Render(App)
	
	local Container = App.new("Frame",self:GetRef());
	Container.StrokeTransparency = 1;
	local ImageProvider = App:GetProvider("ImageProvider");
	
	local ImageContent = Instance.new("ImageLabel", Container:GetGUIRef());
	ImageContent.Size = UDim2.fromScale(1,1);
	ImageContent.BackgroundTransparency = 1;
	ImageContent.ZIndex = self.ZIndex+1;

	self:AddEventListener("MouseEnter",true,Container.MouseEnter);
	self:AddEventListener("MouseLeave",true,Container.MouseLeave);
	self:AddEventListener("InputBegan",true,Container.InputBegan);
	self:AddEventListener("InputEnded",true,Container.InputEnded);
	self:AddEventListener("InputChanged",true,Container.InputChanged);
	-- self:AddEventListener("InputBegan",true,Container.InputBegan);
	
	local ModelContent;local ModelContentCamera;
	local function fetchModelContent()
		ModelContent = Instance.new("ViewportFrame",Container:GetGUIRef());
		ModelContent.BackgroundTransparency = 1;
		ModelContent.Size = UDim2.fromScale(1,1);
		ModelContentCamera = Instance.new("Camera",ModelContent);
		ModelContentCamera.CameraType  = Enum.CameraType.Scriptable;
		ModelContent.CurrentCamera = ModelContentCamera;
		--ModelContent.ZIndex = self.ZIndex+3;
	end

	local prevImagePromise;
	
	return {
		["Image"] = function(Value)
			if(prevImagePromise)then prevImagePromise:Destroy();prevImagePromise=nil;end;
			prevImagePromise = ImageProvider:RequestImageUri(Value):Then(function(results)
				ImageContent.Image = results;
			end):Catch(function(err)
				warn("Image Failure: ", err);
			end)
			-- ImageContent.Image = ImageProvider:GetImageUri(Value);
		end,
		["ModelAngle"] = function(Value)
			if(ModelContentCamera)then
				local Position = ModelContentCamera.CFrame.Position;
				print("Align")
				--ModelContentCamera.CFrame = ModelContentCamera.CFrame * CFrame.Angles(0,Value.Y,0) * CFrame.new(0,0,-self._distance);
				ModelContentCamera.CFrame = CFrame.new(Position)*CFrame.Angles(math.rad(Value.X),math.rad(Value.Y),math.rad(Value.Z))
				--ModelContentCamera.CFrame 
			end
		end,
		["Model"] = function(Value)
			if(Value)then
				if(not ModelContent)then
					fetchModelContent();
				end;
				local Cloned = Value:Clone();
				Cloned.Parent = ModelContent;
				local Primary = Cloned.PrimaryPart or Cloned:FindFirstChildWhichIsA("BasePart");
				local orientation,size = Cloned:GetBoundingBox();
				size = size + Vector3.new(2,2,2);
				
				local l = math.max(size.X,size.Y,size.Z);
				--self._distance = l;
				
				--local p = Instance.new("Part");
				--p.Anchored = true;
				
				--p.Parent = workspace;
				
				ModelContentCamera.CFrame = Primary.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0,0,-l))*CFrame.Angles(0,math.rad(180),0));
				
				--ModelContentCamera.CFrame = p.CFrame;
				--print(ModelContentCamera.CFrame);
				--print(l,size);
				
				--print(orientation,size);
					
			else
				if(ModelContent)then
					ModelContent:ClearAllChildren();
				end
			end
		end,
		_Components = {
			FatherComponent = Container:GetGUIRef();	
			Image = ImageContent;
		};
		_Mapping = {
			[Container] = {
				"AnchorPoint","Position","Visible","ZIndex","Size","BackgroundTransparency","BackgroundColor3","Roundness"
			};
			[ImageContent] = {
				"ScaleType",
				"ImageColor3",
				"ZIndex"
				--"Image"
			}
		};
	};
end;


return Image
