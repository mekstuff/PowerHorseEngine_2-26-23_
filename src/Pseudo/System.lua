local Core = require(script.Parent.Core);

local SystemListenersBlacklist = {};

local System = {}

local Canvas;

--//
function System:SetCanvas(c)
	Canvas=c;
end;

--//
System.Processes = {}
function System.Processes:Normalize(xi,xmin,xmax,normal)
	if(not normal)then normal=1;end;
	return ((xi-xmin)/(xmax-xmin))*normal
end;

--//
System.Props = {};

--//
local SystemPropsCTR = {};

function SystemPropsCTR:Read()
	
end;
--//
function System.Props.new(PropName, Value)
	local Prop = {};
	local Proxy = {};

	setmetatable(Proxy, {
		__index = function(t,k)
			print(t,k)
			return Prop[k]
		end,
		__newindex = function(t,k,v)
			print(k,v)
			rawset(Prop,k,v);
		end,
	});
	
	Proxy.Name = PropName;
	Proxy.Value = Value;

	return Proxy;
end;

--//
System.Listeners = {};
System.Listeners.Blacklist = {};
function System.Listeners.BlockListenerOfClass(...)
	local Listeners = {...};
	for _,v in Listeners do
		System.Listeners.Blacklist[v]=true;
	end
end;

--local ListenerFiredEvent = Instance.new("BindableEvent",workspace);
--ListenerFiredEvent.Name = "ListenerFiredEvent-System";
--System.Listeners.ListenerFired = ListenerFiredEvent.Event;
--System.Listeners.__ListenerFired = ListenerFiredEvent;

--//
System.Document = {};
System.Document.getElementByID = function(elementID)
	local App = require(script.Parent);
	return App.GlobalElements[elementID];
end;
System.Document.RefreshPage = function()
	local App = require(script.Parent);
	for _,v in pairs(App.GlobalElements) do
		if(v.Visible)then
			--v:RenderbaseComponent();
			if(v.Render)then
				v:Render();
			end
			
		end;
	end;
end;


--//
local Prev__System_Document_createStaticInformationText;
System.Document.defaultStaticInformationText = nil;
System.Document.createStaticInformationText = function(txt,txtlifetime)
	if(Prev__System_Document_createStaticInformationText)then
		Prev__System_Document_createStaticInformationText:Destroy();
	end;
	if(not Canvas)then return Core.tossWarn("\"createStaticInformationText\" failed because there's no canvas to work with. Use System:SetCanvas(canvas GUIElement) to set a canvas, preferably a ScreenGUI or Portal.") end;
	if(not txt)then return Core.tossWarn("\"createStaticInformationText\" failed because there's no text to work with.") end;
	if(not txtlifetime)then txtlifetime = 1;end;
	local App = require(script.Parent);
	local Text = App.new("Text",{
		Parent = Canvas;
		Position = UDim2.fromScale(.5,.99);
		AnchorPoint = Vector2.new(.5,1);
		RichText = true;
	});
	Prev__System_Document_createStaticInformationText = Text;
	if(typeof(txt) == "table")then
		Text.Text = txt[1];
		if(#txt > 1)then
			local currIn = 1;
			local thread = coroutine.create(function()
				while true do
					if(not Text.__dev)then
						print("Breaking");
						break;
					end;
					
					wait(txtlifetime);
					if(currIn+1 > #txt)then
						currIn=1;else currIn+=1;
					end;
					if(not Text.__dev)then break;end;
					local TweenOut = Text:CreateTween(TweenInfo.new(.3), {TextTransparency = 1});
					TweenOut:Play();
					TweenOut.Completed:Wait();
					Text.Text = txt[currIn];
					local TweenIn = Text:CreateTween(TweenInfo.new(.3), {TextTransparency = 0});
					TweenIn:Play();
					TweenIn.Completed:Wait();
				end
			end)coroutine.resume(thread);
		end
	else
		Text.Text = txt;
	end;
	return txt;
end;

--//
System.Document.destroyStaticInformationText = function()
	System.Document.createStaticInformationText(System.Document.defaultStaticInformationText);
end;


return System
