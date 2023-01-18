--[=[
	@class SmartTextService
]=]
local SmartTextService = {}
local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local ServiceProvider = require(script.Parent.Parent.Providers.ServiceProvider);
local TextService = ServiceProvider:LoadServiceAsync("TextService");
local ErrorService = ServiceProvider:LoadServiceAsync("ErrorService");
local ROBLOXTextService = game:GetService("TextService");
local Core = require(script.Parent.Parent.Parent.Pseudo.Core);
local lowerCaseAZ = Core:fromStringToTable("abcdefghijklmnopqrstuvwxyz");


local function createSmartTextObject(text,size,color,font,p)
	local textObj = Instance.new("TextLabel");
	textObj.AutomaticSize = Enum.AutomaticSize.XY;
	textObj.Font = font or Enum.Font.Gotham;
	textObj.TextSize = size or 16;
	textObj.TextColor3 = color or Color3.fromRGB(255,255,255);
	textObj.BackgroundTransparency = 1;
	textObj.Text = text
	textObj.Name = "";
	local Constraint = Instance.new("UISizeConstraint");
	local s = ROBLOXTextService:GetTextSize(text,size,font,Vector2.new(math.huge,math.huge))
	Constraint.MinSize = Vector2.new(s.X,s.Y);
	Constraint.Parent = textObj;
	textObj.Parent = p;
	return textObj,Constraint
end

local function handleSmartTag(tag,size,font,color,parent)
	local t = {
		["format"] = function()
			local App = require(script.Parent.Parent.Parent);
			local format = App:GetGlobal("Format");
			--local text = createSmartTextObject()
			if(tag.props.unix)then
				local fromUnix = format(tag.value):fromUnixStamp(tag.props["12hr"]);
			
				if(tag.props.unix == "time")then
					createSmartTextObject(fromUnix:toTimeFormat(),size,color,font,parent);
				else
					createSmartTextObject(fromUnix:toDateFormat(tag.props.str,tag.props.short,tag.props.daynumber),size,color,font,parent);
				end
				fromUnix=nil;
				return;
			end
			if(tonumber(tag.value))then
				local format_ = format(tag.value);
				if(tag.props.abv)then
					format_:toNumberAbbreviation(tag.props.abv ~= true and tag.props.abv:split() or nil);
				end
				if(tag.props.commas)then
					
					format_:toNumberCommas();
				end;
				local t = format_:End();
				--print(t)
				local text = createSmartTextObject(t,size,color,font);
				text.Parent = parent;
				format_=nil;
				
			end;
		end,
		["button"] = function()
			local App = require(script.Parent.Parent.Parent);
			local RespectGrid = Instance.new("Folder");
			local Button = App.new("Button",RespectGrid);
			Button.Text = tag.value;
			Button.BackgroundColor3 = Color3.fromRGB(13, 13, 13);
			local Constraint = Instance.new("UISizeConstraint");
			--RespectGrid.Size = UDim2.fromScale
			Constraint.MinSize = Vector2.new(Button:GetAbsoluteSize().X,Button:GetAbsoluteSize().Y);
			Constraint.Parent = RespectGrid;
			RespectGrid.Parent = parent;
		end,
		["img"] = function()
			--print(tag)
			local props = tag.props;
		
			if(not props.src)then ErrorService.tossWarn("SmartText: created img tag with no src. Try src=image://source.path");end;
			props.src = props.src or "";
			props.size = props.size or tostring(size).."x"..tostring(size);

			if(tonumber(props.src))then
				props.src = "rbxthumb://type=Asset&id="..props.src.."&w=150&h=150"
			end

			local r,g,b,alpha;
			if(props.color)then
				r,g,b,alpha = props.color:match("%w%((%d+),(%d+),(%d+),*([%d%p]*)%)");
			else
				r,g,b,alpha = 255,255,255,0
			end;

			alpha = props.transparency or alpha;
			local s_split = props.size:split("x")
			props.size = Vector2.new(tonumber(s_split[1]),tonumber(s_split[2]));
			local image = App.new("Image",parent);
			image.Image = props.src;
			image.Name = "";
			image.BackgroundTransparency = 1;
			image.ImageColor3 = Color3.fromRGB(r,g,b);
			--image.ImageTransparency = alpha;
			image.ScaleType = not props.scale and Enum.ScaleType.Fit or Enum.ScaleType[props.scale];
			local Constraint = Instance.new("UISizeConstraint");
			Constraint.Name = "ImageConstraint-SmartText";
			Constraint.MinSize = props.size
			Constraint.Parent = image:GetGUIRef();

		end,
		["b"] = function()
			--print(parent)
			local textBold = Instance.new("TextLabel");
			textBold.AutomaticSize = Enum.AutomaticSize.XY;
			textBold.Font = font;
			textBold.TextSize = size;
			textBold.TextColor3 = color;
			textBold.BackgroundTransparency = 1;
			textBold.RichText = true;
			textBold.Text ="<b>"..tag.value.."</b>";
			textBold.Name = "";
			local Constraint = Instance.new("UISizeConstraint");
			local s = ROBLOXTextService:GetTextSize(tag.value,size,font,Vector2.new(math.huge,math.huge))
			Constraint.MinSize = Vector2.new(s.X,s.Y);
			Constraint.Parent = textBold;
			
			--textBold.Name = "Bold Text";
			textBold.Parent = parent;
		end,
		["w"] = function()
			--print(parent)
			local textBold = Instance.new("TextLabel");
			textBold.AutomaticSize = Enum.AutomaticSize.XY;
			textBold.Font = font;
			textBold.TextSize = size;
			textBold.TextColor3 = color;
			textBold.BackgroundTransparency = 1;
			textBold.RichText = true;
			textBold.Text = tag.value;
			textBold.Name = "";
			local Constraint = Instance.new("UISizeConstraint");
			local s = ROBLOXTextService:GetTextSize(tag.value,size,font,Vector2.new(math.huge,math.huge))
			Constraint.MinSize = Vector2.new(s.X,s.Y);
			Constraint.Parent = textBold;

			--textBold.Name = "Bold Text";
			textBold.Parent = parent;
		end,
	}
	if(t[tag.type])then
		t[tag.type]();
	end
end

--//
local function getTagAtIndex(index,textTags)
	
	for _,v in pairs(textTags)do
		if(v.starts == index)then
			return v;
		end
	end
end
--//
function disectString(String,txtSize,txtFont,txtColor3,parent,startingpoint,textTags)
	local finalString = String;
	local s,e;
	--print("Ran",String)
	for i = startingpoint or 1,#String do
		local tagAtIndex = getTagAtIndex(i,textTags);
		--print(textTags)
		
	
		if(tagAtIndex)then
			handleSmartTag(tagAtIndex,txtSize,txtFont,txtColor3,parent);
			--if(SmartTags[tagAtIndex.type])then
				--SmartTags[tagAtIndex.type](tagAtIndex,txtSize,txtFont,parent);
				s,e = tagAtIndex.starts,tagAtIndex.ends;
				--String = String:gsub(tagAtIndex.capture, "");
			--else
				--ErrorService.tossWarn("\""..tagAtIndex.type.."\" is not a valid smart tag. "..tagAtIndex.capture);
			--end;
		end;
		local k = true;
		if(s and e)then
			if(i >= s and i <= e)then
				k=false;
			end
		end
		if(k)then
			local c = String:sub(i,i);
			local textlabel = Instance.new("TextLabel");
			textlabel.Text = c;
			textlabel.Name = "";
			textlabel.Font = txtFont;
			textlabel.TextSize = txtSize;
			textlabel.TextColor3 = txtColor3;
			textlabel.BackgroundTransparency = 1;
			local Constraint = Instance.new("UISizeConstraint");
			Constraint.Name = "TextConstraint-SmartText";
			local s = ROBLOXTextService:GetTextSize(c,txtSize,txtFont,Vector2.new(math.huge,math.huge))
			Constraint.MinSize = Vector2.new(s.X,s.Y);
			Constraint.Parent = textlabel;
			textlabel.Parent = parent;
		end;
	end;
end;

--[=[]=]
function SmartTextService:GetSmartText(txt:string?,textComponent:any,ParentTo:any,txtSize:any,txtFont:any):any
	txtSize = txtSize or (textComponent and textComponent.TextSize);
	txtFont = txtFont or (textComponent and textComponent.Font);
	local TextTags,TextWithNoTags = TextService:GetTags(txt,true);
	
	if(#TextTags <= 0)then return false;end;
	
	disectString(txt,txtSize,txtFont,textComponent.TextColor3,ParentTo,1,TextTags);
--[[
	if(TextTags)then
		for _,v in pairs(TextTags) do
			if(SmartTags[v.type])then
				SmartTags[v.type](v,txtSize,txtFont,ParentTo);
			else
				ErrorService.tossWarn("\""..v.type.."\" is not a valid smart tag. "..v.capture);
			end;
		end
	end;
	]]
	return true;
end;

local SmartTags = {
	["text"] = function(x)
		local TextObject = App.new("Text");
		TextObject.Text = x.children;
		return TextObject;
	end;
}

--[=[]=]
function SmartTextService:CreateSmartComponents(Text:string,existingComponents:any?)
	local Tags = TextService:GetTags(Text,true);
	local Container = App.new("Frame",game.StarterGui.TestGui);
	local Grid = Instance.new("UIGridLayout",Container:GetGUIRef());
	Grid.CellSize = UDim2.new(0);
	Grid.FillDirection = Enum.FillDirection.Horizontal;
	for _,x in pairs(Tags) do
		if(SmartTags[x.type])then
			local res = SmartTags[x.type](x);
			res.SupportsRBXUIBase = true;
			local Constraint = Instance.new("UISizeConstraint");
			if(res:IsA("Text"))then
				local s = ROBLOXTextService:GetTextSize(res.Text,res.TextSize,res.Font,Vector2.new(math.huge,math.huge));
				Constraint.MinSize = Vector2.new(s.X,s.Y);
				Constraint.Parent = res:GetGUIRef();
			end;
			res.Parent = Container;
		end
	end;
end;

return SmartTextService
