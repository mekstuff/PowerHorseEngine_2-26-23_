local Theme = require(script.Parent.Parent.Parent.Theme);

local Image = {
	Name = "Image";
	ClassName = "Image";
	BackgroundTransparency = 0;
	BackgroundColor3 = Theme.getCurrentTheme().Primary;
	Model = "**Instance";
	ModelAngle = Vector3.new(0);
	Image = "";
	ImageColor3 = Theme.getCurrentTheme().Text;
	ImageRectOffset = Vector2.new(0);
	ImageRectSize = Vector2.new(0);
	ImageTransparecy = 0;
	ResampleMode = Enum.ResamplerMode.Default;
	ScaleType = Enum.ScaleType.Fit;
	SliceScale = 1;
};

Image.__inherits = {"BaseGui","Frame"}

--[=[
	@class Image

	Inherits [BaseGui], [Frame]
]=]

--[=[
	@prop Model Instance | Pseudo
	@within Image
]=]
--[=[
	@prop ModelAngle Vector3
	@within Image
]=]
--[=[
	@prop Image string
	@within Image
]=]
--[=[
	@prop ImageColor3 Color3
	@within Image
]=]
--[=[
	@prop ImageRectOffset Vector2
	@within Image
]=]
--[=[
	@prop ImageRectSize Vector2
	@within Image
]=]
--[=[
	@prop ImageTransparecy number
	@within Image
]=]
--[=[
	@prop ResampleMode Enum.ResampleMode
	@within Image
]=]
--[=[
	@prop ScaleType Enum.ScaleType
	@within Image
]=]
--[=[
	@prop SliceScale number
	@within Image
]=]

function Image:_Render(App)
	
	local Container = App.new("Frame",self:GetRef());
	Container.StrokeTransparency = 1;
	local ImageProvider = App:GetProvider("ImageProvider");
	
	local ImageContent = Instance.new("ImageLabel", Container:GetGUIRef());
	ImageContent.Name = "$l_ImageLabel";
	ImageContent.Size = UDim2.fromScale(1,1);
	ImageContent.BackgroundTransparency = 1;
	ImageContent.ZIndex = self.ZIndex+1;

	--[=[
		@prop MouseEnter PHeSignal
		@within Image
	]=]
	self:AddEventListener("MouseEnter",true,Container.MouseEnter);
	--[=[
		@prop MouseLeave PHeSignal
		@within Image
	]=]
	self:AddEventListener("MouseLeave",true,Container.MouseLeave);
	--[=[
		@prop InputBegan PHeSignal
		@within Image
	]=]
	self:AddEventListener("InputBegan",true,Container.InputBegan);
	--[=[
		@prop InputEnded PHeSignal
		@within Image
	]=]
	self:AddEventListener("InputEnded",true,Container.InputEnded);
	--[=[
		@prop InputChanged PHeSignal
		@within Image
	]=]
	self:AddEventListener("InputChanged",true,Container.InputChanged);

	local ModelContent;local ModelContentCamera;
	local function fetchModelContent()
		if(ModelContent)then 
			ModelContent:ClearAllChildren();
		end;
		ModelContent = Instance.new("ViewportFrame",Container:GetGUIRef());
		ModelContent.BackgroundTransparency = 1;
		ModelContent.Size = UDim2.fromScale(1,1);
		ModelContentCamera = Instance.new("Camera",ModelContent);
		ModelContentCamera.CameraType  = Enum.CameraType.Scriptable;
		ModelContent.CurrentCamera = ModelContentCamera;
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
		end,
		["ModelAngle"] = function(Value)
			if(ModelContentCamera)then
				local Position = ModelContentCamera.CFrame.Position;
				ModelContentCamera.CFrame = CFrame.new(Position)*CFrame.Angles(math.rad(Value.X),math.rad(Value.Y),math.rad(Value.Z))
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
				local _,size = Cloned:GetBoundingBox();
				size = size + Vector3.new(2,2,2);
				local l = math.max(size.X,size.Y,size.Z);
				ModelContentCamera.CFrame = Primary.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0,0,-l))*CFrame.Angles(0,math.rad(180),0));
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
				"AnchorPoint","Position","Visible","ZIndex","Size","BackgroundTransparency","BackgroundColor3","Roundness","Rotation"
			};
			[ImageContent] = {
				"ScaleType",
				"ImageColor3",
				"ZIndex"
			}
		};
	};
end;


return Image
