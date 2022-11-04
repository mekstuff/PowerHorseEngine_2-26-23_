local TweenService = game:GetService("TweenService");

-- [ Enumeration ] --

--[=[
	@class Enumeration
	PowerHorseEngine's Enums
]=]
local Enumeration = {}
-- [ Ease ] --

Enumeration.Ease = {};
Enumeration.Ease.Linear = {
	f = function(cv:number,i:number,ti:number, sv:number):number
		return cv*i/ti+sv;
	end;
};

Enumeration.TransitionDirection = {};
-- [ Transition Directions ] --

Enumeration.TransitionDirection = {};
Enumeration.TransitionDirection.TopBottom = {};
-- [ Close Button Behaviour ] --

Enumeration.CloseButtonBehaviour = {};
Enumeration.CloseButtonBehaviour.None = {};
Enumeration.CloseButtonBehaviour.Hide = {};
Enumeration.CloseButtonBehaviour.Destroy = {};
Enumeration.CloseButtonBehaviour.Display = {};
-- [ Connection Status ] -

Enumeration.ConnectionStatus = {};
Enumeration.ConnectionStatus.Excellent = {n = 60};
Enumeration.ConnectionStatus.Good = {n = 120};
Enumeration.ConnectionStatus.Moderate = {n = 300};
Enumeration.ConnectionStatus.Bad = {n = 600};
Enumeration.ConnectionStatus.Awful = {n = 1000};
--[ Face Directions ] --

Enumeration.FaceDirection = {};
Enumeration.FaceDirection.None = {};
Enumeration.FaceDirection.Relative = {};
Enumeration.FaceDirection.LookAt = {};
-- [ AITypes ] --

Enumeration.AI = {};
Enumeration.AI.Human = {};

-- [ AutoAccordionBehaviour ] --

Enumeration.AccordionButtonPosition = {};
Enumeration.AccordionButtonPosition.Partial = {};
Enumeration.AccordionButtonPosition.Entire = {};
Enumeration.AccordionButtonPosition.Icon = {};
Enumeration.AccordionButtonPosition.None = {};
-- [ Ligament ] --

Enumeration.LigamentType = {};
Enumeration.LigamentType.Constraint = {ins = "WeldConstraint"};
Enumeration.LigamentType.Weld = {ins = "Weld"};

-- [ CameraMovementType ] --

Enumeration.CameraMovementType = {};
Enumeration.CameraMovementType.Default = {Name="Default",EnumType = "PromptType"};
Enumeration.CameraMovementType.DeltaLocked = {Name="DeltaLocked",EnumType = "PromptType"};
Enumeration.CameraMovementType.CharacterLocked = {Name="CharacterLocked",EnumType = "PromptType"};

Enumeration.ProductPurchaseState = {};
Enumeration.ProductPurchaseState.Declined = {};
Enumeration.ProductPurchaseState.Purchased = {};
-- [ PromptType ] --

Enumeration.PromptType = {};
Enumeration.PromptType.None = {Name="None",EnumType = "PromptType"};
Enumeration.PromptType.Warning = {Name="Warning",EnumType = "PromptType",icon = "rbxasset://textures/StudioSharedUI/alert_warning@2x.png"; c=Color3.fromRGB(245, 164, 33)};
Enumeration.PromptType.Info = {Name="Info",EnumType = "PromptType",icon = "rbxasset://textures/StudioSharedUI/alert_info@2x.png"; c=Color3.fromRGB(204, 204, 204)};
Enumeration.PromptType.Error = {Name="Info",EnumType = "PromptType",icon = "rbxasset://textures/StudioSharedUI/alert_error@2x.png"; c=Color3.fromRGB(237, 64, 64)};

-- [ Device ] --

Enumeration.Device = {};
Enumeration.Device.XBOX = {Name="XBOX",EnumType="Device",};
Enumeration.Device.Mobile = {Name="Mobile",EnumType="Device"};
Enumeration.Device.PC = {Name="PC",EnumType="Device"};

-- [ ProximityPromptExclusivity ] --

Enumeration.Exclusivity = {};
Enumeration.Exclusivity.AlwaysShow = {Name="AlwaysShow",EnumType = "ProximityPromptExclusivity"};
Enumeration.Exclusivity.OneGlobally = {Name="OneGlobally",EnumType = "ProximityPromptExclusivity"};
Enumeration.Exclusivity.OnePerButton = {Name="OnePerButton",EnumType = "ProximityPromptExclusivity"};

-- [ NotificationAnimationStyle ] --

Enumeration.NotificationAnimationStyle = {};
Enumeration.NotificationAnimationStyle.Popup = {Name="Popup",EnumType = "NotificationAnimationStyle"};
Enumeration.NotificationAnimationStyle.Slide = {Name="Popup",EnumType = "NotificationAnimationStyle"};
-- [ NotificationGroupPriority ] --

Enumeration.NotificationPriority = {};
Enumeration.NotificationPriority.Low = {Name="Low",EnumType = "NotificationPriority",prNumber = 14};
Enumeration.NotificationPriority.Class1 = {Name="Class1",EnumType = "NotificationPriority",prNumber = 13};
Enumeration.NotificationPriority.Class2 = {Name="Class2",EnumType = "NotificationPriority",prNumber = 12};
Enumeration.NotificationPriority.Class3 = {Name="Class3",EnumType = "NotificationPriority",prNumber = 11};
Enumeration.NotificationPriority.Class4 = {Name="Class4",EnumType = "NotificationPriority",prNumber = 10};
Enumeration.NotificationPriority.Class5 = {Name="Class5",EnumType = "NotificationPriority",prNumber = 9};
Enumeration.NotificationPriority.Class6 = {Name="Class6",EnumType = "NotificationPriority",prNumber = 8};
Enumeration.NotificationPriority.Class7 = {Name="Class7",EnumType = "NotificationPriority",prNumber = 7};
Enumeration.NotificationPriority.Class8 = {Name="Class8",EnumType = "NotificationPriority",prNumber = 6};
Enumeration.NotificationPriority.Class9 = {Name="Class9",EnumType = "NotificationPriority",prNumber = 5};
Enumeration.NotificationPriority.Class10 = {Name="Class10",EnumType = "NotificationPriority",prNumber = 4};
Enumeration.NotificationPriority.Medium = {Name="Medium",EnumType = "NotificationPriority",prNumber = 3};
Enumeration.NotificationPriority.High = {Name="High",EnumType = "NotificationPriority",prNumber = 2};
Enumeration.NotificationPriority.Critical = {Name="Critical",EnumType = "NotificationPriority",prNumber = 1};

-- [ ActionMenuAutomaticHide ] --
Enumeration.ActionMenuAutomaticHide = {};
Enumeration.ActionMenuAutomaticHide.None = {Name="None",EnumType = "ActionMenuAutomaticHide"};
Enumeration.ActionMenuAutomaticHide.TreeOnly = {Name="TreeOnly",EnumType = "ActionMenuAutomaticHide"};
Enumeration.ActionMenuAutomaticHide.All = {Name="All",EnumType = "ActionMenuAutomaticHide"};
-- [ PositionBehaviour ] --
Enumeration.PositionBehaviour = {};
Enumeration.PositionBehaviour.FollowMouse = {Name="FollowMouse",EnumType="PositionBehaviour"};
Enumeration.PositionBehaviour.Static = {Name="Static",EnumType="PositionBehaviour"};

-- [ HoverEffect ] --
Enumeration.HoverEffect = {};
Enumeration.HoverEffect.Highlight = {Name="Highlight",EnumType="HoverEffect"};
Enumeration.HoverEffect.Reveal = {Name="Reveal",EnumType="HoverEffect"};
Enumeration.HoverEffect.None = {Name="None",EnumType="HoverEffect"};

-- [ Active Behaviour ] --

Enumeration.ActiveBehaviour = {};
Enumeration.ActiveBehaviour.ExpandedStroke = {Name="ExpandedStroke",EnumType="ActiveBehaviour"};
Enumeration.ActiveBehaviour.BorderStroke = {Name="BorderStroke",EnumType="ActiveBehaviour"};
Enumeration.ActiveBehaviour.None = {Name="None",EnumType="ActiveBehaviour"};

-- [ Ripple Style ] --

Enumeration.RippleStyle = {};
Enumeration.RippleStyle.Dynamic = {Name="Dynamic",EnumType="RippleStyle"};
Enumeration.RippleStyle.Static = {Name="Static",EnumType="RippleStyle"};
Enumeration.RippleStyle.None = {Name="None",EnumType="RippleStyle"};

-- [ DropdownState ] --
Enumeration.DropdownState = {};
Enumeration.DropdownState.Collapsed = {Name="Collapsed",EnumType="DropdownState"};
Enumeration.DropdownState.Expanded = {Name="Expanded",EnumType="DropdownState"};

-- [ KeyCode ] --

--//Keyboard
Enumeration.KeyCode = {};
Enumeration.KeyCode.Unknown = {Name = "Unknown",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Zero = {Name = "Zero",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.One = {Name = "One",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Two = {Name = "Two",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Three = {Name = "Three",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Four = {Name = "Four",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Five = {Name = "Five",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Six = {Name = "Six",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Seven = {Name = "Seven",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Eight = {Name = "Eight",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Nine = {Name = "Nine",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.A = {Name = "A",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.B = {Name = "B",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.C = {Name = "C",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.D = {Name = "D",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.E = {Name = "E",ReferenceImage = nil,ConsoleLink = Enumeration.KeyCode.ButtonA,EnumType="KeyCode"};
Enumeration.KeyCode.F = {Name = "F",ReferenceImage = nil,ConsoleLink = Enumeration.KeyCode.ButtonB,EnumType="KeyCode"};
Enumeration.KeyCode.G = {Name = "G",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.H = {Name = "H",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.I = {Name = "I",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.J = {Name = "J",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.K = {Name = "K",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.L = {Name = "L",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.M = {Name = "M",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.N = {Name = "N",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.O = {Name = "O",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.P = {Name = "P",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Q = {Name = "Q",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.R = {Name = "R",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.S = {Name = "S",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.T = {Name = "T",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.U = {Name = "U",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.V = {Name = "V",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.W = {Name = "W",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.X = {Name = "X",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Y = {Name = "Y",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.Z = {Name = "Z",ReferenceImage = nil,ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.LeftShift = {};
Enumeration.KeyCode.RightShift = {};
Enumeration.KeyCode.LeftAlt = {};
Enumeration.KeyCode.RightAlt = {};
Enumeration.KeyCode.LeftControl = {};
Enumeration.KeyCode.RightControl = {};
Enumeration.KeyCode.CapsLock = {};

--//Console (XBOX)
local Path = "rbxasset://textures/ui/Controls/"
Enumeration.KeyCode.ButtonX = {Name = "ButtonX",ReferenceImage = Path.."xboxX@3x.png",ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.ButtonY = {Name = "ButtonY",ReferenceImage = Path.."xboxB@3x.png",ConsoleLink = nil,EnumType="KeyCode"};
Enumeration.KeyCode.ButtonA = {};
Enumeration.KeyCode.ButtonB = {};
Enumeration.KeyCode.ButtonR1 = {};
Enumeration.KeyCode.ButtonL1 = {};
Enumeration.KeyCode.ButtonR2 = {};
Enumeration.KeyCode.ButtonL2 = {};
Enumeration.KeyCode.ButtonR3 = {};
Enumeration.KeyCode.ButtonL3 = {};
Enumeration.KeyCode.ButtonStart = {};
Enumeration.KeyCode.ButtonSelect = {};
Enumeration.KeyCode.DPadLeft = {};
Enumeration.KeyCode.DPadRight = {};
Enumeration.KeyCode.DPadUp = {};
Enumeration.KeyCode.DPadDown = {};
Enumeration.KeyCode.Thumbstick1 = {};
Enumeration.KeyCode.Thumbstick2 = {};


-- [ Adjustment ] --
Enumeration.Adjustment = {};
Enumeration.Adjustment.Center = {};
Enumeration.Adjustment.Left = {};
Enumeration.Adjustment.Right = {};
Enumeration.Adjustment.Flex = {};
Enumeration.Adjustment.Top = {};
Enumeration.Adjustment.Bottom = {};

-- [ DoorActivationType ] --
Enumeration.DoorActivationType = {};
Enumeration.DoorActivationType.Prompt = {};
Enumeration.DoorActivationType.Proximity = {};

-- [ PlaceholderBehaviour ] --
Enumeration.PlaceholderBehaviour = {};
Enumeration.PlaceholderBehaviour.Default = {};
Enumeration.PlaceholderBehaviour.Margin = {};

--//Convert Enums to Objects.
local EnumObjects = {};

function EnumObjects:GetEnums(ENUM,Sorted)
	for EnumClass,EnumData in pairs(EnumObjects) do
		if(EnumClass == ENUM)then
			if not (Sorted)then
				return EnumData;
			else
				local t = {};
				
				for _,v in pairs(EnumData) do
					table.insert(t,v);
				end;
				return t;
			end;
			
		end;
	end
end

for EnumerationReference,EnumerationData in pairs(Enumeration) do
	local newEnumObject = {};
	--print(EnumerationReference, EnumerationData)
	for ENUMNAME,EnumItem in pairs(EnumerationData) do
		
		local newEnumItem = {};
		EnumItem.Name = ENUMNAME;
		EnumItem.EnumType = EnumerationReference;
		EnumItem.PowerHorseEnumType = EnumerationReference;

		
		local n = "Enumeration."..EnumerationReference.."."..EnumItem.Name;
		setmetatable(newEnumItem, {
			
			__tostring = function()
				return n
				--return "EnumItem "..ENUMNAME.."."..EnumItem.Name;
			end,
			__eq = function(me,them)
				
				return (me._value == them._value)
			end,
			__index = function(t,k)
				if(k == "IsA")then
					return function ()
						return false;
					end
					-- return function (query)
						-- if(query == "Enum")then return true;end;
						-- return false;
					-- end;
				end;
				if(k == "GetEnumItems")then
					return newEnumObject;
				elseif(k == "_value")then
					-- print("value called");
					return n;
					-- return "Enum "..EnumerationReference..":/"..EnumItem.Name;
				elseif(k == "_isEnumObject?_$")then
					return true;
				end;
			
				
				return EnumItem[k];
			end,
		})
		
		newEnumObject[EnumItem.Name]=newEnumItem;
	end;
	
	EnumObjects[EnumerationReference]=newEnumObject;
end;

return EnumObjects;
