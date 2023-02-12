-- type definitions for PowerHorseEngine
-- written by Olanzo James @ Lanzo Inc
-- contributors:

local App = script.Parent;
-- local Enumeration = App.Enumeration;

local Types = {};

type CreateCustomClass = (ClassData:PseudoClass)->(Pseudo);
-- type CreateCustomClassMethod = 

export type App = {
    new:
    --> AI
        (("AICharacterRig") -> AICharacterRig)
        &(("AI") -> AI)
        &(("AIPet") -> AIPet)
        &(("AIHuman") -> AIHuman)
        &(("BaseCharacterRig") -> BaseCharacterRig)
        &(("CharacterRig") -> CharacterRig)
--> BaseGui's 
        &(("Accordion") -> Accordion)
        &(("AccordionGroup") -> AccordionGroup)
        &(("ActionMenu") -> ActionMenu)
        &(("AppBar") -> AppBar)
        &(("Backpack") -> Backpack)
        &(("Badge") -> Badge)
        &(("BaseGui") -> BaseGui)
        &(("BaseText") -> BaseText)
        &(("Button") -> Button)
        &(("Checkbox") -> Checkbox)
        &(("CloseButton") -> CloseButton)
        &(("CurrencyDropIndicator") -> CurrencyDropIndicator)
        &(("CurrencyIndicator") -> CurrencyIndicator)
        &(("DamageIndicator") -> DamageIndicator)
        &(("DatePicker") -> DatePicker)
        &(("Dialog") -> Dialog)
        &(("DialogBox") -> DialogBox)
        &(("DialogueGUI") -> DialogueGUI)
        &(("DropdownButton") -> DropdownButton)
        &(("FormControl") -> FormControl)
        &(("Frame") -> Frame)
        &(("GUI") -> GUI)
        &(("HitMarker") -> HitMarker)
        &(("Image") -> Image)
        &(("LineBreak") -> LineBreak)
        &(("ListItem") -> ListItem)
        &(("LocationIndicator") -> LocationIndicator)
        &(("MenuItem") -> MenuItem)
        &(("Modal") -> Modal)
        &(("Navigator") -> Navigator)
        &(("NewToast") -> NewToast)
        &(("NotificationBanner") -> AccordionGroup)
        &(("NotificationGroup") -> NotificationGroup)
        &(("ObjectiveGroupOLD") -> ObjectiveGroupOLD)
        &(("ObjectiveOLD") -> ObjectiveOLD)
        &(("Portal") -> Portal)
        &(("ProgressBar") -> ProgressBar)
        &(("ProgressIndicator") -> ProgressIndicator)
        &(("ProgressiveProgress") -> ProgressiveProgress)
        &(("ProgressRadial") -> ProgressRadial)
        &(("Prompt") -> Prompt)
        &(("PromptSheet") -> PromptSheet)
        &(("ProximityPrompt") -> ProximityPrompt)
        &(("Radio") -> Radio)
        &(("RadioGroup") -> RadioGroup)
        &(("ScrollingFrame") -> ScrollingFrame)
        &(("SettingButton") -> SettingButton)
        &(("Slider") -> Slider)
        &(("Snackbar") -> Snackbar)
        &(("Subtitle") -> Subtitle)
        &(("SubtitleText") -> SubtitleText)
        &(("SuggestiveTextInput") -> SuggestiveTextInput)
        &(("TabGroup") -> TabGroup)
        &(("Text") -> Text)
        &(("TextComponent") -> TextComponent)
        &(("TextInput") -> TextInput)
        &(("TextSlider") -> TextSlider)
        &(("TimePicker") -> TimePicker)
        &(("Toast") -> Toast)
        &(("Toggle") -> Toggle)
        &(("ToolTip") -> ToolTip)
        &(("ViewportRespectiveFrame") -> ViewportRespectiveFrame)
        &(("Widget") -> Widget)

--> Instances
        &(("Folder") -> Folder)
        &(("RInstance") -> RInstance)
--> Joint
        &(("Ligament") -> Ligament)
--> PHe
        &(("PHePrompt") -> PHePrompt)
--> Promises
        &(("Promise") -> Promise)
--> Rig
        &(("DoorRig") -> DoorRig)
        &(("HingedDoorRig") -> HingedDoorRig)
        &(("Rig") -> Rig)
--> Servants
        &(("Servant") -> Servant)
--> SignalBlockers
        &(("GUISignalBlocker") -> GUISignalBlocker)
--> Signals
        &(("PHeSignal") -> PHeSignal)
--> States
        &(("State") -> State)
--> Transitions
        &(("FadeTransition") -> FadeTransition)
        &(("Transition") -> Transition)
        &(("WipeTransition") -> WipeTransition)
--> UIObjects
        &(("GuiCollider") -> GuiCollider),

	Create: CreateCustomClass,
    GetGlobal: (
        ((self:any, "Client")->ClientGlobal)
        &((self:any, "Engine")->Engine)
        &((self:any, "Enum")->Enumeration)
        &((self:any, "Format")->FormatGlobal)
        &((self:any, "Pseudo")->PseudoGlobal)
        &((self:any, "Theme")->Theme)   
    ),
	-- GetGlobal: (self:any,GlobalName:string)->any,
    GetService: (
        ((self:any,"ClientService")->ClientService)
        &((self:any,"AudioService")->AudioService)
        &((self:any,"BanService")->BanService)
        &((self:any,"ChatTagService")->ChatTagService)
        &((self:any,"ClientTradeService")->ClientTradeService)
        &((self:any,"CodeService")->CodeService)
        &((self:any,"CommandService")->CommandService)
        &((self:any,"CoordinateService")->CoordinateService)
        &((self:any,"CoreGuiService")->CoreGuiService)
        &((self:any,"CoreProviderService")->CoreProviderService)
        &((self:any,"CustomClassService")->CustomClassService)
        &((self:any,"DataStoreService")->DataStoreService)
        &((self:any,"EncryptionService")->EncryptionService)
        &((self:any,"ErrorService")->ErrorService)
        &((self:any,"FormatService")->FormatService)
        &((self:any,"GridPlacementService")->GridPlacementService)
        &((self:any,"InGamePurchaseService")->InGamePurchaseService)
        &((self:any,"KEYSERVICE")->KEYSERVICE)
        &((self:any,"MessagingService")->MessagingService) --> native
        &((self:any,"ModalService")->ModalService)
        &((self:any,"NotificationBannerService")->NotificationBannerService)
        &((self:any,"NotificationService")->NotificationService)
        &((self:any,"PingService")->PingService)
        &((self:any,"PromptService")->PromptService)
        &((self:any,"PseudoService")->PseudoService)
        &((self:any,"QuickWeldService")->QuickWeldService)
        &((self:any,"RagdollService")->RagdollService)
        &((self:any,"ReplicationService")->ReplicationService)
        &((self:any,"SerializationService")->SerializationService)
        &((self:any,"SmartTextService")->SmartTextService)
        &((self:any,"SplashScreenSequence")->SplashScreenSequence)
        &((self:any,"TextService")->TextService)
        &((self:any,"TopBarService")->TopBarService)
        &((self:any,"TradeService")->TradeService)
        &((self:any,"TweenService")->TweenService) --> Native for now
        &((self:any,"UserIdService")->UserIdService)
        &((self:any,"UserKeybindService")->UserKeybindService)
        &((self:any,"UserThumbnailService")->UserThumbnailService)
        &((self:any,"VoteKickService")->VoteKickService)
        &((self:any,"WaypointService")->WaypointService)
    ),
    -- GetService: (self:any,ServiceName:string)->any,
	-- GetProvider: (self:any,ProviderName:string)->any,
    GetProvider: (
        ((self:any,"LibraryProvider")->LibraryProvider)
        &((self:any,"ContentProvider")->ContentProvider)
        &((self:any,"ModuleFetcherProvider")->ModuleFetcherProvider)
        &((self:any,"PropProvider")->PropProvider)
        &((self:any,"ServiceProvider")->ServiceProvider)
        &((self:any,"SignalProvider")->SignalProvider)
        &((self:any,"UtilProvider")->UtilProvider)
    ),
    Import: (
        ((self:any,"DirectionalArrow3D")->DirectionalArrow3DLibrary)
        &((self:any,"Sillito")->SillitoLibrary)
        &((self:any,"Array")->ArrayLibrary)
        &((self:any,"Collector")->CollectorLibrary)
        &((self:any,"Contextor")->ContextorLibrary)
        &((self:any,"fetch")->fetchLibrary)
        &((self:any,"Math")->MathLibrary)
        &((self:any,"Pointer")->PointerLibrary)
        &((self:any,"Query")->QueryLibrary)
        &((self:any,"ReClasser")->ReClasserLibrary)
        &((self:any,"ServerBee")->ServerBeeLibrary)
        &((self:any,"SpatialArea")->SpatialAreaLibrary)
        &((self:any,"Stack")->StackLibrary)
        &((self:any,"State")->StateLibrary)
        &((self:any,"StateManager")->StateManagerLibrary)
        &((self:any,"Whiplash")->WhiplashLibrary)
    ),
	-- Import: (self:any,libraryName:string)->any,
	GetConfig: (self:any)->any,
	-- GetPseudoFromInstance: typeof(PowerHorseEngine.GetPseudoFromInstance),
}
export type PHeApp = App;

type PseudoRender = (App:App) -> nil

type PHeSignal<T...> = {
    Connect: (self:any, callback:(T...)->())->nil, --> For now we use this because I have no idea how to setup dynamic arguments with types :)
};

export type Pseudo = {
	Name: string,
	ClassName: string,
	Parent: Instance|Pseudo|any,
    Replicate: (self:Pseudo)->nil,
    GetFullName: (self:Pseudo)->string,
    WaitForChild: (self:Pseudo,Name:string,onlyPseudo:boolean?,tries:number?)->Pseudo|Instance,
    FindFirstAncestor: (self:Pseudo,Name:string,level:number?)->Pseudo|Instance,
    FindFirstAncestorOfClass: (self:Pseudo,Name:string,level:number?)->Pseudo|Instance,
    FindFirstAncestorWhichIsA: (self:Pseudo,Name:string,level:number?)->Pseudo|Instance,
    FindFirstChild: (self:Pseudo,Name:string,recursive:boolean?,onlyPseudo:boolean?)->Pseudo|Instance,
    FindFirstChildOfClass: (self:Pseudo,Name:string)->Pseudo|Instance,
    FindFirstChildWhichIsA: (self:Pseudo,Name:string)->Pseudo|Instance,
    GetDescendants: (self:Pseudo)->any,
    GetChildren: (self:Pseudo,onlyPseudo:boolean?)->any,
    SerializePropsAsync: (self:Pseudo)->string,
    DeserializePropsAsync: (self:Pseudo,Serialized:string,Apply:boolean?)->any,
    GET: (self:Pseudo,Target:string)->Pseudo|Instance|nil?,
    Clone: (self:Pseudo)->Pseudo?,
    Destroy: (self:Pseudo)->nil,
    GetPropertyChangedSignal: (self:Pseudo)->nil,
    IsA: (self:Pseudo,ClassQuery:string)->boolean,
    _GetAppModule: (self:any)->App,
    _GetCompRef: (self:Pseudo)->Instance,
    GetRef: (self:Pseudo)->Folder,
    AddEventListener: (self:Pseudo,EventName:string,CreatingEvent:boolean?,BindCreateToEvent:BindableEvent?,SharedSignal:boolean?)->PHeSignal<nil>,
    RemoveEventListener: (self:Pseudo,Events:string|any)->nil,
    RemoveEventListeners: (self:Pseudo)->nil,
    GetEventListener: (self:Pseudo)->PHeSignal<nil>,
    _lockProperty: (self:Pseudo,propertyName:string,propertyCallback:any)->nil,
    _lockProperties: (self:Pseudo,...string|any)->nil,
    _unlockProperty: (self:Pseudo,...string|any)->nil,
    _Render: (self:Pseudo)->{}|(Hooks:PseudoHooks)->any,
    [any]: any?
}


type useEffect = (Handler:any, Depedencies:any?) -> Servant
type useRender = (Handler:any, Depedencies:any?) -> Servant
type useMapping = (props:{[string|number]:string},depedencies:{Instance|Pseudo|any},trackMap:boolean?) -> Servant|nil
type useRawset = (handler:(newValue:any)->any,dependency:string) -> nil
type useComponents = (components:{[string]:any}) -> nil

type StateFunctionalCall = () -> any
export type State = Pseudo&StateFunctionalCall&{
    State: any,
    useEffect: (self:any,Handler:any,Depedencies:any?) -> Servant,
};

export type PseudoHooks = {
    useEffect: useEffect,
    useRender: useRender,
    useMapping: useMapping,
    useRawset: useRawset,
    useComponents: useComponents,
}

-- export type Enumeration = Enumeration.Enumeration;
-- export type Enum = Enumeration;

--> Servants
export type Servant = Pseudo&{
    Task: (self:any,cb:()->nil) -> nil,
    Instance: (self:any,...any) -> any,
    Pseudo: (self:any,...any) -> any,
    Keep: (self:any,TargetItem:any) -> any,
    Free: (self:any,TargetItem:any) -> any,
    Connect: (self:any, connection:RBXScriptSignal,connectionCallback:(...any)->nil) -> RBXScriptConnection,
    Disconnect: (self:any,connection:RBXScriptConnection)->nil
}
export type PHeServant = Servant;
--> Promises
export type Promise = Pseudo&{
    State: string,
    MAXIMUM_RETRIES: number,
    Try: (self:any,handler:(resolve:any,reject:any,cancel:any,promise:Promise)->any) -> Promise,
    WhenThen: (self:any,handler:(res:any,Promise:Promise?)->any) -> Promise,
    Then: (self:any,handler:(res:any,Promise:Promise?)->any) -> Promise,
    Catch: (self:any,handler:(err:any,Promise:Promise?)->any) -> Promise,
    Cancel: (self:any,handler:(err:any,Promise:Promise?)->any) -> Promise,
    Retry: (self:any) -> nil,
};
export type PHePromise = Promise;

--> AI
export type AICharacterRig = Pseudo&AI&BaseCharacterRig&{
    ShirtTemplate: string,
    PantsTemplate: string,
    WalkToPoint: Vector3,
    WalkToPart: BasePart,
};
export type PHeAICharacterRig = AICharacterRig;

export type AI = {
    Target: Instance?,
    TargetOffset: Vector3,
    RelativeOffset: boolean,
    GetTargetPosition: (self:any) -> Vector3
};


export type PHeBaseCharacterRig = BaseCharacterRig;


export type AIPet = Pseudo&{
    IdleAnimation: string,
    WalkAnimation: string,
    RunAnimation: string,
    JumpAnimation: string,
    Skin: Instance?,
    Health: number,
    RenderDistance: number,
    TargetRotation: number,
    -- FaceDirection: Enumeration,
}

export type AIHuman = AI&{
    IdleAnimation: string,
    WalkAnimation: string,
    RunAnumation: string,
    JumpAnimation: string,
    Health: number,
    _DetermineIsValidHumanModel: (self:any, Parent:any?) -> any,
};

export type BaseCharacterRig = Pseudo&{
    GetClothing: (self:any) -> {[any]:any},
    GetCharacterInRadius: (self:any, Radius:number) -> {[any]:any},
    GetBaseHumanoid: (self:any,Target:Instance|Pseudo) -> {[any]:any},
};

export type CharacterRig = Pseudo&{
    WalkAnimation: string,
    RunAnimation: string,
    JumpAnimation: string,
    Shirt: string,
    Pants: string,
    WalkSpeed: number,
    JumpPower: number,
    WalkTo: Vector3,
    Focus: any,
    Sprint: (self:any) -> nil,
    StopSprint: (self:any) -> nil,
    GetIsCharacter: (self:any) -> any,
    GetBodyParts: (self:any) -> any,
    AddAccessory: (self:any,Accessory:Accessory,SpecialId:any?) -> nil,
    RemoveAccessory: (self:any) -> nil,
    WalkToCoordinate: (self:any,Coordinates:CFrame|Vector3,Force:boolean?) -> nil,
}

--> Base Gui's

export type Accordion = Pseudo&BaseGui&{
    Text: string,
    Icon: string,
    Font: Font,
    TextSie: number,
    TextColor3: Color3,
    Expanded: boolean,
    -- AccordionButtonPosition: Enumeration.AccordionButtonPosition,
    ButtonSize: UDim2,
    AutoExpand: boolean,
    GetButton: (self:any) -> Button,
    ButtonMouseEnter: PHeSignal<nil>,
    ButtonMouseLeave: PHeSignal<nil>,
    ButtonPressed: PHeSignal<nil>,
};

export type AccordionGroup = {
    CellSize: UDim2,
    CellPadding: UDim2,
    HorizontalAlignment: Enum.HorizontalAlignment,
    VerticalAlignment: Enum.VerticalAlignment,
    FillDirection: Enum.FillDirection,
    SortOrder: Enum.SortOrder,
    AddAccordion: (self:any, Text:string?, Icon:string?) -> Accordion,
    Add: (self:any,...any) -> Accordion,  
};

export type ActionMenuAction = Pseudo&{
    ID: string,
    Text: string,
    Icon: string,
    UpdateText: (self:any, Text:string) -> nil,
    UpdateIcon: (self:any, Icon:string) -> nil,
    AddActionMenu: (self:any) -> ActionMenu,
};
export type ActionMenu = {
    -- AutomaticHide: Enumeration.ActionMenuAutomaticHide,
    Showing: boolean,
    TextSize: number,
    ShowAsync: (self:any, ...any) -> ActionMenuAction,
    Show: (self:any, ignoreFocusLost:boolean?,CustomAdornee:any?) -> nil,
    Hide: (self:any) -> nil,
    AddSplit: (self:any) -> nil,
    AddPadding: (self:any, y:number?) -> nil,
    AddHeader: (self:any, Header:string?) -> nil,
    AddAction: (self:any, ActionName:string,id:string,ActionIcon:string?,...any) -> ActionMenuAction,
    UpdateAllIcons: (self:any, Icon:string, IgnoreList:{[number]:any}?, Inverse:boolean?) -> nil,
    GetActions: (self:any) -> {[any]:ActionMenuAction},
    GetAction: (Action:string) -> ActionMenuAction,
    AddToTree: (self:any,...any) -> nil,
    ActionTrigger: PHeSignal<ActionMenuAction>
};

export type AppBar = Pseudo&BaseGui&{
    Text: string,
    TextColor3: Color3,
    Icon: string,
    Size: UDim2,
    ActionButtonPressed: PHeSignal<nil>
};

export type Badge = {
    Text: string,
    TextColor3: Color3,
    TextScaled: boolean,
    StrokeTransarepcny: number,
    StrokeThickness: number,
    StrokeColor3: number,
    -- xAdjustment: Enumeration,
    Roundness: UDim,
};

export type BaseGui = {
	Disabled: boolean,
	Position: UDim2,
	Size: UDim2,
	SupportsRBXUIBase: boolean,
	Visible: boolean,
	ZIndex: number,
	LayoutOrder: number,
    GetAbsoluteSize: (self:any) -> Vector2,
    GetAbsolutePosition: (self:any) -> Vector2,
    GetGUIRef: (self:any) -> any,
};

export type BaseText = Pseudo&GUI&{
    GetUserTextAsync: (self:any,ShowText:string?) -> (string|nil,boolean),
};

export type Button = Pseudo&Frame&Text&BaseGui&{
    Icon: string,
    IconSize: UDim2,
    IconAdaptsTextColor: boolean,
    IconColor3: Color3,
    Loading: boolean?,
    -- TextAdjustment: Enumeration.Enumeration,
    -- IconAdjustment: Enumeration.Enumeration,
    ButtonFlexSizing: boolean?,
    Roundness: UDim,
    RippleColor: Color3,
    RippleTransparency: number,
    ClickEffect: boolean?,
    Padding: Vector2,
};

export type Checkbox = BaseGui&Frame&{
    Icon: string,
    Toggle: boolean,
    AutoToggle: boolean,
    Toggled: PHeSignal<boolean>
};

export type CloseButton = Pseudo&BaseGui&{
    Actvated: PHeSignal<true>
};

export type CurrencyDropIndicator = Pseudo&BaseGui&{
    Lost: string,
    Target: Instance|Pseudo|any,
};

export type CurrencyIndicator = Pseudo&BaseGui&{
    VisibleLifetime: number,
    AnimateNumbers: boolean,
    FormatToCommas: boolean,
    FormatToNumberAbbreviation: boolean,
    Text: string,
    MinimumRandom: number,
    MaximumRandom: number,
    Icon: string,
    EntryTween: TweenInfo,
    TweenInfo: TweenInfo,
    animText: (self:any,v:number,default:number?) -> IntValue
};

export type DamageIndicator = Pseudo&BaseGui&{
    Damage: string|number,
    Origin: UDim2|Vector3|Instance|CFrame,
    TextColor3: Color3|{[any]:any},
    TextSize: number,
    Lifetime: number,
    PositionOffset: UDim2,
    PopoutTweenInfo: TweenInfo,
    _Initiate: (self:any) -> any,
}

-- export type DatePicker = 
export type DialogBoxSequence = {
    Play: (self:any) -> any;
    Stop: (self:any) -> any;
    Resume: (self:any) -> any;
    Pause: (self:any) -> any;

}&Pseudo;

export type DialogBox = {
    -- HorizontalAlignment: Enum.HorizontalAlignment,
    SpeakerText: string,
    SpeakerTextColor3: Color3,
    SpeakerTextSize: number,
    SpeakerRichText: boolean,
    SpeakerSmartText: boolean,
    SpeakerRotation: number,
    SpeakerFont: Enum.Font,
    SpeakerBackgroundColor3: Color3,
    SpeakerPaddingBottom: UDim,
    SpeakerPaddingLeft: UDim,
    SpeakerPaddingRight: UDim,
    SpeakerPaddingTop: UDim,
    ContentText: string,
    ContentTextColor3: Color3,
    ContentTextSize: boolean,
    ContentFont: boolean,

    Options: {
        id: string?,
        [any]:any,
    },
    OptionsFillDirection: Enum.FillDirection,
    OptionsHorizontalAlignment: Enum.HorizontalAlignment,
    OptionsVerticalAlignment: Enum.VerticalAlignment,
    OptionsSortOrder: Enum.SortOrder,
    OptionsPosition: UDim2,
    OptionsAnchorPoint: Vector2,

    OptionClicked: PHeSignal<Button,any>,
    CreateDialogSequence: (self:any,Sequence:{[number]:{
        id:string|number|nil,
        options: {
            id: string?,
            [any]:any,
        },
        props: {[any]:any}
    }}) -> DialogBoxSequence

}&BaseGui&Pseudo;
-- export type Dialog
-- export type DialogueGUI
-- export type FormControl

export type Frame = {
    MouseButton1Down: PHeSignal<nil>,
    MouseButton2Down: PHeSignal<nil>,
    MouseButton1Up: PHeSignal<nil>,
    MouseButton2Up: PHeSignal<nil>,
    MouseClick: PHeSignal<nil>,
    MouseLeave: PHeSignal<nil>,
};

export type GUI = {

};

export type HitMarker = Pseudo&BaseGui&{
    SoundProps: {
        SoundId: string,
        SoundVolume: number,
    },
    Lifetime: number,
    HitMarkerImage: string,
    HitMarkerType: "default",
    Target: Instance?,
    -- _Initate: (self:any,Hooks:PseudoHooks) -> any,
    GetTargetPositionRelativeToCamera: (self:any,Target:BasePart|Model|Instance?) -> UDim2,
}

export type Image = Pseudo&BaseGui&Frame&GUI&{
    Model: Instance?,
    ModelAngle: Vector3,
    Image: string,
    ImageColor3: Color3,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
    ImageTransparency: number,
    ResampleMode: Enum.ResamplerMode,
    ScaleType: Enum.ScaleType,
    SliceScale: number
};

export type LineBreak = BaseGui&{
    Color: Color3,
};

-- export type ListItem --> MenuItem instead

export type LocationIndicator = Pseudo&BaseGui&{
    StartAnchorPoint: Vector2,
    AnchorPoint: Vector2,
    StartPosition: UDim2,
    Position: UDim2,
    TweenInfo: TweenInfo,
    Text: string,
    Lifetime: number,
    IndicatorClass: string,
};

export type MenuItem = BaseGui&Button&Text&Frame&GUI&{
    RightSlotIcon: string,
    HoverColorEffect: boolean,
    HoverColor3: Color3,
    HoverColorTweenInfo: TweenInfo,
};

export type Modal = Pseudo&BaseGui&GUI&{
    Header: string,
    HeaderIcon: string,
    HeaderIconColor3: Color3,
    HeaderIconAdaptsHeaderTextColor: boolean,
    HeaderIconSize: UDim2,
    HeaderTextSize: number,
    HeaderTextFont: Enum.Font,
    HeaderTextColor3: Color3,
    BodyTextSize: number,
    BodyTextColor3: Color3,
    -- HeaderAdjustment: Enumeration.Adjustment,
    -- ButtonsAdjustment: Enumeration.Adjustment,
    ButtonsScaled: boolean,
    Highlighted: boolean,
    Body: string?,
    ButtonClicked: PHeSignal<Button>,
    ButtonAdded: PHeSignal<Button>,
    CaptureUserFocus: (self:any,Pulse:number)->nil,
    AddButton: (self:any,Text:string,styles:{[string]:any}?,ID:any?)->Button,
    OnHighlightClicked: (self:any, handler:()->nil) -> nil
    -- CloseButtonBehaviour: Enumeration.CloseButtonBehaviour,
};

export type Navigator = BaseGui&{
    NavigationSpeed: number,
    Back: (self:any) -> nil,
    Next: (self:any, initial:boolean?) -> nil,
    NavigateTo: (self:any, index:number|string,initial:boolean?) -> nil,
    RemoveNavigation: (self:any, id:string) -> nil,
    AddNavigation: (Page:Instance|Pseudo, id:string|number, Number:number?) -> nil,
    Navigated: PHeSignal<string|number,Instance|Pseudo,string,number>
};

-- export type NewToast = 
-- export type NotificationBanner
-- export type ObjectiveGroupOLD
-- export type ObjectiveOLD

export type Portal = BaseGui&{
    IgnoreGuiInset: boolean,
    ResetOnSpawn: boolean
};

export type ProgressBar = BaseGui&{
    ForegroundColor3: Color3,
    TweenSpeed: number,
    ValueChanged: PHeSignal<nil>
};

export type ProgressIndicator = {
    Color: Color3,
    CycleSpeed: number,
    Size: number,
    Enabled: boolean
};

export type ProgressProgress = ProgressBar&{
    CurrentIndex: string,
    NextIndex: string,
    ProgressBarPadding: number
};

export type ProgressRadial = GUI&BaseGui&{
    Value: number,
    Color: Color3,
    Yielding: boolean,
    SetYielding: (self:any, Yield:boolean) -> nil,
    FillValue: (self:any, Value:number?, Speed:number?) -> nil,
};

export type Prompt = Modal&{
    Level: number,
    StartPosition: UDim2,
    StartAnchorPoint: Vector2,
    DestroyOnOverride: boolean,
    PromptClass: string,
    Show: (self:any) -> nil,
    Hide: (self:any,DontLookForOther:boolean?,Destroy:boolean?) -> nil,
    SetTweenSpeed: (self:any,Speed:number)->nil,
    Yield: (self:any,DestroyOnEnded:boolean?)->(Button,any),    
};

export type PromptSheet = BaseGui&Prompt&Modal&GUI&Frame;

export type ProximityPrompt = BaseGui&{
    Icon: string,
    ActionText: string,
    ActionTextColor3: Color3,
    ActionTextSize: number,
    KeyTextColor3: Color3,
    -- ActionTextAdjustment: Enumeration.Adjustment,
    PromptOffset: Vector2,
    -- KeyCode: Enumeration.KeyCode,
    MaxActivationDistance: number,
    RequiresLineOfSight: boolean,
    HoldDuration: number,
    RetractionSpeed: number,
    -- Exclusivity: Enumeration.Exclusivity,
    Hidden: boolean,
    Disabled: boolean,
	Triggered: PHeSignal<Player>,
	TriggerEnded: PHeSignal<nil>,
	HoldBegan: PHeSignal<nil>,
	HoldEnded: PHeSignal<nil>,
	ProximityGained: PHeSignal<nil>,
	ProximituLost: PHeSignal<nil>,
};

export type TabGroup = Pseudo&BaseGui&{
    HighlighterColor3: Color3,
    HighlighterThickness: number,
    HighlighterPadding: number,
    AddTab: (self:any,TabContent:(Pseudo|Instance|any),TabName:string|{},TabIcon:string?,TabId:any?,TabButtonProps:{}?)->Button,
    OpenTab: (self:any,TabId:any)->nil,
    TabSwitched: PHeSignal<any>
};

export type PHeTabGroup = TabGroup;

export type Text = {

};
export type PHeText = Text;

export type PHeCloseButton = CloseButton;

export type DropdownButton = {
    ContentSize: Vector2,
    Expanded: boolean,
};
export type PHeDropdownButton = DropdownButton;

export type GuiCollider = {
    Adornee: Instance|Pseudo|nil,
}&Pseudo

--> Providers
export type LibraryProvider = {
    LoadLibrary: (...string) -> ...any
};
export type ContentProvider = {
    Uri: (self:any, string:string,promise:boolean?) -> Promise|string
};

export type ModuleFetcherProvider = ModuleFetcherConstantProvider;

export type PropProvider = {
    GetProps: (self:any,propSheet:{},ignoreHiddenProps:boolean?,ignoreFunctions:boolean?,onlykeys:boolean?)->{[any]:any},
    FromPseudoClass: (self:any,Class:string,ignoreHiddenProps:boolean?,ignoreFunctions:boolean?,onlyKeys:boolean?)->{[any]:any}
};

export type ServiceProvider = {
    LoadServiceAsync: (self:any,ServiceName:string)->any
};

export type SignalProvider = {
    new: (Name:string?) -> PHeSignal
};

export type UtilProvider = {
    LoadUtil: (UtilName:string) -> any
}

--> Services
type ClientService_Backpack_ClientBackpackProxy = Pseudo&{
    GUID: string,
    Backpack: {[any]:any},
    Characters: {[any]:any},
    ToolBind: (self:any, BindHandler:(Tool:Tool,CollectorBinder:Servant)->any) -> Servant,
    GetTools: (self:any) -> {[number]:Tool},
    BindKeysToList: (self:any,KeybindMapping:{[number]:{[number]:Enum.KeyCode}},RequestsHandler:(TargetTool:Tool,InputObject:InputObject?)->any??)->Servant,
    HasToolEquipped: (self:any, Tool:Tool) -> boolean,
    SetToolEquipped: (self:any, Tool:Tool, State:boolean) -> any
};

type ClientService_Backpack = Pseudo&{
    Tracked: {[any]:any},
    ToolTagName: string,
    ProxyBackpacks: {[any]:any},
    SetCoreBackpackEnabled: (self:any, state:boolean) -> any,
    GetTools: (self:any, Player:Player, existingTable:{[any]:any}?) -> {[any]:any},
    ProxyBackpack: (self:any, Player:Player?) -> ClientService_Backpack_ClientBackpackProxy,
    GetToolOwner: (self:any, Tool:Tool) -> Player?
};

export type ClientService = {
    Ping: PingReader,
    Backpack: ClientService_Backpack,
    SetDeviceClientType: (self:any,DeviceType:"pc"|"mobile"|"xbox") -> nil,
    GetClientDeviceType: (self:any) -> State,
    Device: State,
    GetIsGamePadConnected: (self:any) -> State,
    GamepadConnected: State,
}

type PHePluginStudioTool_dev = {}
type PHePluginStudioTool_initreturn = {
    name: string,
    id: string,
    icon: string?,
    toolboxbutton:boolean?,
    api: boolean|string?,
}

type launch = (self:any)->nil;
export type PHePluginStudioTool = {
    init: ()->PHePluginStudioTool_initreturn,
    launch: launch?,
    initiated: (self:any,Hooks:PseudoHooks)->any,
    open: (self:any)->any,
    close: (self:any)->any,
    ProvideAPI: (self:any, APIKEY:string?) -> any,
    _App: PHePluginLibraryObject,

    [string]: any
};

export type PHePluginLibraryObject = Pseudo&{
    onReady: ()->nil,
    onInstall: ()->nil,
    onUninstall: ()->nil,
    onUpdate: ()->nil,
    onReady: ()->nil,
    GetLocalPluginVersion: (self:any) -> string,
    GetCloudPluginVersion: (self:any) -> string,
    RequestVersionUpdateAsync: (self:any,Append:any?,UpdateRequired:boolean?,HeadsupText:string?) -> boolean,
    CreateStudioTool: (self:any,ClassInfo:PHePluginStudioTool)->PHePluginStudioTool,
    CreateDockWidgetPluginGui: (self:any,WidgetName:string,WidgetInfo:DockWidgetPluginGuiInfo)->DockWidgetPluginGui,
    CreatePluginMenu: (self:any,id:any,name:string?)->PluginMenu,
    SavePluginData: (self:any,key:any,value:any)->nil,
    GetPluginData: (self:any,key:any,value:any)->nil,
    SendNotification: (self:any,t:any)->nil,
    GetPluginApp: (self:any,PluginAppName:string) -> PHePluginLibraryObject?,
    WaitForPluginApp: (self:any,PluginAppName:string,TRIES:number?) -> PHePluginLibraryObject?,
    HasPluginApp: (self:any,PluginAppName:string) -> boolean,
    GetStudioTool: (self:any,StudioToolId:string) -> PHePluginStudioTool,
    WaitForStudioTool: (self:any,StudioToolId:string) -> PHePluginStudioTool,
    HasStudioTool: (self:any,StudioToolId:string) -> boolean,
};

export type PHePluginAppHandler = {
    IsProperLibraryFile: (libfile:Folder)->boolean,
    getModulesfolder: (libfile:Folder)->Folder,
    addTool: (App:App,ToolData:table,ManifestName:string,toolbar:PluginToolbar)->Folder,
    createPHeLibraryObject: (LibraryFolder:Folder,toolbar:PluginToolbar,plugin:Plugin)->nil,
};

export type PluginService = {
    BuildAsPHeApp: (self:any,pluginApp:Folder,PluginToolbar:PluginToolbar?,plugin:Plugin?)->nil,
    IsPluginMode: (self:any)->boolean,
    ReadSync: (self:any)->{}?,
};
export type PHePluginService = PluginService;

export type AudioChannelAudio = Pseudo&{
    Play:(self:any)->nil,
    Resume:(self:any)->nil,
    Pause:(self:any)->nil,
    Stop:(self:any)->nil,
    isDefaultAudio: boolean,
};
export type PHeAudioChannelAudio = AudioChannelAudio;
export type AudioChannel = Pseudo&{
    AddAudio:(self:Pseudo,AudioName:string,AudioID:number,AudioVolume:number?,Looped:boolean?,PlayAudio:boolean?,Instant:boolean?,DeleteOnComplete:boolean?)->AudioChannelAudio,
    SetAudioMuted:(self:any,AudioName:string,State:boolean,AudioInstance:any)->nil,
    GetAudio:(self:any,AudioName:string)->AudioChannelAudio,
    GetAudios:(self:any)->nil,
    SetDefaultAudio:(self:any,AudioName:string)->nil,
    SetVolume:(self:any,Volume:number)->nil,
    Mute:(self:any)->nil,
    UnMute:(self:any)->nil,
    PlayAudio:(self:any,AudioName:string,FromPaused:boolean?)->nil,
    StopAudio:(self:any,AudioName:string,ignoreDefault:boolean?)->nil,
    PauseAudio:(self:any,AudioName:string,ignoreDefault:boolean?,DoNotRemove:boolean?)->nil,
    MuteChanged: PHeSignal<nil>,
    AudioAdded: PHeSignal<nil>,
    AudioRemoved: PHeSignal<nil>,
    AudioMuteChanged: PHeSignal<nil>,
    DefaultAudioTriggered: PHeSignal<nil>,
    Audios: {}
};
export type PHeAudioChannel = AudioChannel;
export type AudioService = {
    GetChannel:(self:any,ChannelName:string)->AudioChannel,
    GetChannels:(self:any)->any,
    RemoveChannel:(self:any,ChannelName:string)->nil,
    CreateSoundEffectsChannel:(self:any,ChannelName:string?)->AudioChannel,
    CreateChannel:(self:any,ChannelName:string,AudiosAllowedInParallel:number?,DefaultVolume:number?,DefaultLoop:boolean?,AudiosInstant:boolean?)->AudioChannel,
    MuteChannel:(self:any,ChannelName:string)->nil,
    UnmuteChannel:(self:any,ChannelName:string)->nil,  
};
export type PHeAudioService = AudioService;

export type ChatTagService = {
    AddChatTag: (self:any,Player:Player, TagInformation:{[any]:any}?) -> nil,
    GetChatTags: (self:any,Player:Player, TagInformation:{[any]:any}?) -> nil,
};

export type ClientTradeService = {
    TradeStarted: PHeSignal<nil>,
    TradeEnded: PHeSignal<nil>,
};

export type CodeService = Pseudo&{

};

export type CommandService = {
    GetCommands: (self:any) -> {[any]:any},
    ExecuteCommand: (self:any, x:string, y:{[any]:any}, focusOnCommand:boolean?) -> string?,
    GetCommand: (self:any, name:string) -> any,
    FromStringToCommand: (self:any,String:string) -> (string,{}),
    ExecuteCmdFromStr: (self:any, Str:string) -> string?
};

export type CoordinateService = {
    AddCoordinate: (self:any, CFrameCoor:CFrame,Name:string,Category:string?,CoordinateId:string?,Reserved:{[number]:string|number}?) -> nil,
    GetCoordinatesAsync: (self:any,forTeleportService:boolean?) -> {[any]:any}?,
    TeleportAsync: (self:any,Player:Player,CoordinateName:string,CoordinateCategory:string?,Transition:boolean?,Notify:table?,IgnoreReserved:boolean?) -> nil,
};

export type CoreGuiService = {
    SetNativeGuiEnabled: (self:any,coreGuiType:Enum.CoreGuiType,enabled:boolean,MAX_TRIES:number?) -> Promise,
    SetCoreGuiEnabled: (self:any,name:string,state:boolean) -> any,
    GetIsCoreScript: (self:any,Script:Script|LocalScript|ModuleScript) -> boolean,
    GetCoreGuiRepository: (self:any) -> ScreenGui,
    WaitFor: (self:any,CoreGuiName:string,TIME:number?) -> ScreenGui,
    RemoveObject: (Name:string) -> any,
    ShareObject: (Name:string) -> any,
    GetCoreGui: (self:any,Name:string) -> any,
};

export type CoreProviderService = {
    CalculateUIAbsolutePosition: (self:any,Position:UDim2?,AnchorPoint:Vector2?,Relative:Vector2?) -> nil,
};

export type PseudoClassFunctionalRender = (PseudoHooks:PseudoHooks) -> nil
export type PseudoClass = {
    Name: string?,
	ClassName: string,
	_Render: (self:any, App:App?)->({}|PseudoClassFunctionalRender),
    [string]: any?
}
export type CustomClassService = {
	CreateClassAsync: (self:any,ClassData:PseudoClass,DirectParent:any?,PropArguments:any?,DirectProps:{[any]:any}?)->(Pseudo),
	Create: (self:any,ClassData:PseudoClass,DirectParent:any?,PropArguments:any?,DirectProps:{[any]:any}?)->(Pseudo),
};

export type DataStore = Pseudo&{
    Autosave: boolean,
    RemoveCache: (self:any, Key:any) -> nil,
    GetCache: (self:any) -> any,
    SetCache: (self:any, To:any) -> nil,
    RemoveAsync: (self:any, Key:any) -> nil,
    RemoveAsync: (self:any, Key:any) -> nil,
    GetAsync: (self:any, Key:any) -> any,
    SetAsync: (self:any,Key:any,Value:any,ShouldServe:boolean?) -> nil,
    SaveAsync: (self:any) -> nil,
    Serve: (self:any,Key:any) -> nil,
    UpdateAsync: (self:any,DatastoreKey:any,Key:any,Value:any) -> nil,
};

export type DataStoreService = {
    GetDataStore: (self:any,dstore:string,version_:string?) -> DataStore
};

export type EncryptionService = {
    g256enc: (self:any) -> string,
    Encrypt: (self:any,str:any,enckey:string) -> nil,
    Decrypt: (self:any,str:any,enckey:string) -> nil,
};

export type ErrorService = {
    tossError: (errorshort:string, ...any) -> nil,
    tossWarn: (errorshort:string, ...any) -> nil,
    tossMessage: (errorshort:string, ...any) -> nil,
    assert: (condition:boolean,errorshort:string, ...any) -> nil,
};

export type FormatService = {
    toNumberAbbreviation: (self:any,n:number,...any) -> string,
    toNumberCommas: (self:any,n:number,...any) -> string,
    toTimeFormat: (self:any,timeStamp:number,is12Hour:boolean?) -> string,
    toDateFormat: (self:any,timeStamp:number,useString:boolean?,shortenString:boolean?,indicateDayAsNumber:boolean?) -> string,
    toTimeDifference: (self:any,t1:number,t2:number,...any) -> string,
};

export type GridPlacement = Pseudo&{
    RaycastParams: RaycastParams,
    UnitLength: number,
    Results: {}?,
    AutomaticPlacement: boolean,
    AutomaticRotation: boolean,
    -- RotationKeyCode: Enumeration.KeyCode
    ShowBoundingBox: boolean,
    GridCellSize: number,
    Angle: number,
};
export type GridPlacementService = {
    Create: (self:any, Instance:Instance) -> GridPlacement
};

export type InGamePurchaseService = {
    PurchaseCompleted: PHeSignal<nil>,
    PromptPurchase: (self:any,ProductId:number,Props:{[string]:any}) -> nil
};

export type KEYSERVICE = {
    Give: (self:any,KeyName:string,Shared:boolean?,dedicatedUserId:number?) -> nil,
    Get: (self:any,Keyname:string,fromShared:boolean?) -> nil,
};

export type ModalService = {
    ConvertToModal: (self:any,Frame:any,TargetModal:Modal?,ModalCloseButton:Button|CloseButton?,ModalAppender:any?,ModalHeader:Text|TextLabel|any?)->Modal
};

-- export type MessagingService 

-- export type NotificationBannerService 

export type NotificationResponse = Pseudo&{
    Dismiss: (self:any) -> nil
}
export type NotificationService = {
    SetNotificationsEnabled: (self:any, State:boolean) -> nil,
    BroadcastNotification: (self:any, Data:{[any]:any}) -> nil,
    SendNotificationToAllPlayers: (self:any, Data:{[any]:any},...any) -> nil,
    SendNotification: (self:any, ...any) -> NotificationResponse,
    SendNotificationAsync: (self:any, Plr:Player,Data:{[any]:any},...any) -> NotificationResponse,
    AddNotificationStyle: (self:any, StyleName:string, StyleHandler:()->nil) -> nil,
    HandleNotificationRequest: (self:any, ...any) -> any
};

export type PingReader = Pseudo&{
    Enabled: boolean,
    ms: string,
    Ping: number,
    UpdateInterval: number,
    -- ConnectionStatus: Enumeration.ConnectionStatus,
    PingChanged: PHeSignal<nil>

};
export type PingService = {
    Invoke: () -> boolean,
    RequestUserPingAsync: () -> PingReader,
};

export type PromptResponse = Pseudo&{

};
export type PromptService = {
    PromptUser: (self:any,User:Player,Header:string|{[any]:any},Body:string|nil?,Buttons:{[any]:any}?) -> PromptResponse,
};

export type PseudoService = {
    FromROBLOXObject: (self:any, Instance:Instance,dontdeleteInstance:boolean?,p:Instance?) -> (Instance,{[any]:any}),
    GetPseudoFromId: (self:any, id:Instance|StringValue|string) -> any,
    GetPseudoObjects: (self:any, Specific:{[number]:string}?) -> {[any]:any}
};

export type QuickWeldService = {
    AnchorAll: (self:any,Object:Instance,Ignore:{string}?)->nil,
    UnAnchorAll: (self:any,Object:Instance,Ignore:{string}?)->nil,
    SetCanCollideAll: (self:any,Object:Instance,State:boolean?,Ignore:{string}?)->nil,
    WeldAll: (self:any,Object:Instance,WeldTo:Instance?,DontWeldDescendants:boolean?)->nil,
};

export type RagdollService = {
    RigCharacter: (self:any, Character:Model) -> nil,
};

export type ReplicationService = {
    destroyReplicationToken: (id:string) -> nil,
    newReplicationToken: (pseudo:Pseudo) -> nil,
    ReplicatePseudo: (pseudo:Pseudo) -> nil,
};

type SerializationService_SerializeAsync = (self:any,ToSerialize:any,...any) -> string;
type SerializationService_DeserializeAsync = (self:any,ToDeserialize:any,...any) -> {[any]:any};
export type SerializationService = {
    SerializeAsync: SerializationService_SerializeAsync,
    DeserializeAsync: SerializationService_DeserializeAsync,
    Serialize: SerializationService_SerializeAsync,
    Deserialize: SerializationService_DeserializeAsync,
    SerializeTable: (self:any, Table:{[any]:any},...any) -> string,
    DeserializeTable: (self:any, ...any) -> {[any]:any},
    SerializeString: (self:any, String:string, SerializationVersion:string?) -> string,
    DeserializeString: (self:any, String:string) -> string,
    toBinary: (self:any, str:string) -> string,
    fromBinary: (self:any, str:string) -> string,
};

export type SmartTextService = {
    GetSmartText: (self:any, txt:string?, textComponent:any, ParentTo:any, txtSize:any, txtFont:any) -> any,
    CreateSmartComponents: (self:any,Text:string,existingComponents:any?) -> any,
};

export type SplashScreenSequence = {
    new: (Sequences:{[any]:any},defaultColor:Color3?,defaultLifeTime:number?) -> nil,  
};

type TextService_GetTags = {
    type: string,
    props: {[any]:any},
    children:any,
    close: string,
    starts: number,
    ends: number,
    capture: string
}

export type TextService = {
    GetWordsFromString: (self:any, String:string, StartCapture:string?, EndCapture:string?) -> {[any]:any},
    GetWordAtPosition: (self:any, String:string, i:number) -> (string,number,number),
    GetWordAtPosition: (self:any, txt:string, returnWithNoTags:boolean?) -> ({[any]:any},any?),
    GetTags: (self:any,txt:string,wrapNonTagsInTextTags:boolean?,returnWithNoTags:boolean?) -> ({[number]:TextService_GetTags},any)
};

export type ActiveTrade = Pseudo&{
    Sender: Player?,
    Reciever: Player?,
    TradeId: string,
    MaximumContent: number,
    AddContent: (self:any, ToUser:Player,Content:any,ContentId:string,IgnoreMaximumLimit:boolean?) -> nil,
    RemoveContent: (self:any, fromUser:Player,ContentId:string) -> nil,
    GetContents: (self:any, fromUser:Player) -> {[any]:any},
    End: (self:any, Reasons:any) -> nil,
    GetTradeActive: (self:any, Player1:Player,Player2:Player?) -> Player|boolean,
    TradeRequestOutBound: (Sender:Player,Reciever:Player,Header:string?,Body:string?,Blurred:boolean?,Button1:string?,Button2:string?) -> nil,
    ContentAdded: PHeSignal<Player,any,string>,
    ContentRemoved: PHeSignal<Player,string>,
    Ended: PHeSignal<...any>,
};

export type TradeService = {
    TradeRequest: PHeSignal<nil>,
    TradeStarted: PHeSignal<ActiveTrade>,
    TradeEnded: PHeSignal<ActiveTrade>,
    new: (Sender:Player,Reciever:Player,Header:string?,Body:string?,Blurred:boolean?,Button1:string?,Button2:string?) -> ActiveTrade,
};

-- export type TweenService

export type UserIdService = {
    GetUsername: (self:any, obj:Player|string|number) -> Promise,
    GetUserId: (self:any, obj:Player|string|number) -> Promise,
    getUserId: (obj:Player|string|number) -> number?,
    getUsername: (obj:Player|string|number) -> string?,
};

export type UserKeybindService = {
    BindKeybind: (self:any,...any) -> (RBXScriptSignal,any,...any),
    UnbindKey: (self:any,id:any) -> nil,
    ConvertBindsToString: (self:any,...any) -> string,
};

export type UserThumbnailService = {

};

export type VoteKickService = {
    SpawnToken: (self:any, TargetUser:Player, TargetSender:Player?, TotalTime:number?, TotalVotes:number?) -> nil,
};

export type Waypoint = Pseudo&{
    ShowOnMap: boolean,
    ShowScreenIndicator: boolean,
    ShowDirectionalArrow: boolean,
    WaypointInfo: string,
    WaypointReached: PHeSignal<nil>
};

export type WaypointService = {
    CreateWaypoint: (self:any,Direction:Vector3,WaypointInfo:string?) -> Waypoint
}

--> Globals

type themeDefaults = {
    Alert: Color3,
	Warning: Color3,
	Danger: Color3,
	Success: Color3,
	Info: Color3,
	Active: Color3,
	Unactive: Color3,
	Primary: Color3,
	PrimaryLite: Color3,
	Secondary: Color3,
	SecondaryLite: Color3,
	Disabled: Color3,
	DisabledLite: Color3,
	Background: Color3,
	BackgroundLite: Color3,
	Text: Color3,
	TextLite: Color3,
	Border: Color3,
	BorderLite: Color3,
	Foreground: Color3,
	ForegroundLite: Color3,
	ForegroundText: Color3,
	ForegroundTextLite: Color3,
	Font: Enum.Font,
    [string?]: (number|Color3|Enum.Font),
};
export type Theme = {
    extendTheme: (extension:{
        [string?]: (number|Color3|Enum.Font)
    },uniqueThemeIdentifier:string?) -> nil,
    useTheme: (theme:string,uniqueThemeIdentifier:string?) -> State,
    getDefaultTheme: () -> themeDefaults,
    getCurrentTheme: () -> themeDefaults,
};
export type PHeTheme = Theme;

export type FormatGlobalObject = {
    concat: (self:any,ConcatVal:any) -> FormatGlobalObject,
    toNumber: (self:any) -> FormatGlobalObject,
    toString: (self:any) -> FormatGlobalObject,
    atStart: (self:any,State:any) -> FormatGlobalObject,
    atEnd: (self:any,State:any) -> FormatGlobalObject,
    toTimeDifference: (self:any,format:string) -> (FormatGlobalObject,any),
    toDateFormat: (self:any,useString:boolean?,shortenString:boolean?,indicateDayAsNumber:boolean?) -> (string),
    toTimeFormat: (self:any) -> (string),
    fromUnixStamp: (self:any,is12Hour:boolean) -> FormatGlobalObject,
    toNumberAbbreviation: (self:any,tuple:any?) -> FormatGlobalObject,
    toNumberCommas: (self:any) -> FormatGlobalObject,
    End: (self:any) -> any,
};
export type PHeFormatGlobalObject = FormatGlobalObject;
export type FormatGlobal = (defaultValues:any) -> FormatGlobalObject;
export type PHeFormatGlobal = FormatGlobal;
type userConfigGameContent = {

}

type userConfigModule = {
    Game: userConfigGameContent
}

export type Engine = {
    InitPlugin: (self:any,plugin:Plugin)->nil,
    InitServer: (self:any,PushPackages:boolean?)->nil,
    InitClient: (self:any,Client:Player?)->nil,
    RequestContentFolder: (self:any)->Folder,
    RequestConfig: (self:any,NotImportant:boolean?)->{}|nil,
    RequestUserGameContent: (self:any)->userConfigGameContent,
    FetchReplicatedStorage: (self:any)->Folder,
    FetchWorkspaceStorage: (self:any)->Folder,
    FetchLocalEvents: (self:any)->Folder,
    FetchServerStorage: (self:any)->Folder,
    FetchStorageEvent: (self:any,EventType:string,EventType:string?)->RemoteEvent|RemoteFunction|BindableEvent?,
}
export type PHeEngine = Engine;
--> Built in libraries

export type fetchLibrary = ((params:{[any]:any})-> Promise)&{
    GET: (url:string,nocache:boolean?,headers:any?) -> Promise,
    POST: (url:string,data:string,content_type:Enum.HttpContentType?,compress:string?,headers:any?) -> Promise,
}

export type MathLibrary = {
    oscillate: (min:number,max:number?,Time:number?)->number,
    perc: (x:number,y:number,max:number?)->number
}
export type ReClasserLibrary = {
    ToClass: (self:any,Original:Instance,TargetClass:string,DontDestroy:boolean?,runOnBuild:any?)->(Pseudo|Instance)
};
export type ServerBeeLibrary = Pseudo&{
    ValidateDepedency: (self:any,Player:Player,objectHost:table,TargetHOST_KEY:string)->boolean,
    OnServerEvent: (self:any,HOST_KEY:string,Handler:any)->nil,
    REMOVEHOST: (self:any,HOST_KEY:string)->nil,
    HOST: (self:any,HOST_KEY:string,State:any,ClientDepedencies:table?)->nil
};

export type SpatialAreaClass = Pseudo&{
    OverlapParams: OverlapParams,
    Area: Instance?,
    CFrame: CFrame,
    Size: Vector3,
    Enabled: boolean,
    GetSpotWithinArea:(self:any, Object:Instance)->CFrame,
    ObjectAdded: PHeSignal<Pseudo|Instance>,
    ObjectRemoved: PHeSignal<Pseudo|Instance>,
    PlayerAdded: PHeSignal<Player>,
    PlayerRemoved: PHeSignal<Player>,
};
export type SpatialAreaLibrary = {
    new: () -> SpatialAreaClass,
}

export type StateSetterFunc = (value:any) -> nil;
export type PHeStateSetterFunc = StateSetterFunc;
export type StateLibrary = (defaultValue:any?) -> (State,StateSetterFunc);
export type PHeStateLibrary = StateLibrary;

export type StateManagerClass = {
    new: (self:any,...any)->(State,StateSetterFunc)
};
export type StateManagerLibrary = {
    new: () -> StateManagerClass
}

export type WhiplashLibrary = {
    New: (class:string,...any)->(()->(Instance,Pseudo)),
    ForEach: (loop:{})->(()->(any,any)),
    OnChange: (Event:string)->(()->(any,any)),
    OnEvent: (Event:string)->(()->(any,any)),
    Children: (Parent:Instance,Value:any)->(()->(any,any)),
    this: (followOrder:boolean?)->string,
}

export type PointerLibrary = (Instance:Instance,Parent:any?) -> Pseudo;

export type SillitoLibrary = {
    Start: (self:any)->Promise,
    PortService: (self:any, Service:any)->SillitoLibrary,
    PortServices: (self:any, ...any)->SillitoLibrary,
    PortModular: (self:any, Modular:any)->SillitoLibrary,
    PortModulars: (self:any, ...any)->SillitoLibrary,
    GetBranch: (self:any, BranchName:string)->SillitoBranch,
    HasBranch: (self:any, BranchName:string)->(boolean,SillitoBranch?),
    GetModular: (self:any,ServiceName:string)->SillitoBranch,
    GetService: (self:any,ServiceName:string)->SillitoBranch,
    CreateBranch: (self:any,BranchName:string)->SillitoBranch,

}&SillitoBranch;

export type SillitoBranch = {
    PortComponentClass: (self:any,ComponentClass:ModuleScript)->SillitoLibrary,
    PortComponentClasses: (self:any,ComponentClasses:Folder|any)->SillitoLibrary,
    GetComponentClass: (self:any,ComponentClassName:string)->any,
    GetService: (self:any,ServiceName:string)->SillitoBranch,
    GetModular: (self:any,ServiceName:string)->SillitoBranch,
    CreateDedicatedScreenGui: (self:any, ScreenGuiProps:{[string]:any}?) -> ScreenGui,
    [any]:any
}&Pseudo

export type ArrayLibrary = {
    new: () -> {};
    Adapt: (self:any, originalTable:{},properTypes:boolean?,AdaptNestedArrays:boolean?,onImproperType:(key:any,value:any,selfvalue:any,self:{},originalArray:{})->any) -> {},
    detach: (self:any,conditional:(key:any,value:any)->boolean|nil) -> any,
    find: (self:any,conditional:(key:any,value:any)->any,handler:(key:any,value:any)->any??,executeHandlersAfterConditionals:boolean?)->(any,any)
}

export type DirectionalArrowClass = Pseudo&{
    Origin: any,
    Target: any,
    OriginOffset: Vector3,
    Magnitude: number,
    BrickColor: BrickColor,
    Enabled: boolean,
};
export type DirectionalArrow3DLibrary = {
    new: (Origin:any, Target:any) -> DirectionalArrowClass
}


export type FrameworkLibraryModular = Pseudo&{
    Init: (self:any)->nil,
    Start: (self:any)->nil,
    GetModular: (self:any,ServiceName:string)->FrameworkLibraryModular,
    GetComponentClass: (self:any,ComponentClassName:string)->any,
    UseChannel: (self:any, ChannelName:string)->RemoteEvent,
};
export type PHeFrameworkLibraryModular = FrameworkLibraryModular;
export type FrameworkLibraryClient = {
    Start: (self:any)->Promise,
    PortModular: (self:any,Service:ModuleScript)->FrameworkLibraryModular,
    PortModulars: (self:any,...Folder|any)->nil,
    PortComponentClass: (self:any,ComponentClass:ModuleScript)->nil,
    PortComponentClasses: (self:any,ComponentClasses:Folder|any)->nil,
    GetComponentClass: (self:any,ComponentClassName:string)->any,
    GetService: (self:any,ServiceName:string)->FrameworkLibraryModular,
    GetModular: (self:any,ServiceName:string)->FrameworkLibraryModular,
};
export type PHeFrameworkLibraryClient = FrameworkLibraryClient;

export type CollectorLibrary = Pseudo&{
    Bind: (self:any,Tag:string,handler:(Pseudo|Instance)->()?) -> Servant,
    Unbind: (self:any,Binded:Servant) -> nil,
    Tag: (self:any,Instances:table|Instance|Pseudo,TagName:string) -> nil,
    AddTag: (self:any,Instances:table|Instance|Pseudo,TagName:string) -> nil,
    RemoveTag: (self:any,Instances:table|Instance|Pseudo,TagName:string) -> nil,
    Has: (self:any,Instance:Pseudo|Instance,TagName:string) -> boolean,
    GetTagged: (self:any,TagName:string) -> table,
};
export type PHeCollectorLibrary = CollectorLibrary;

type ContextorLibrary_supportedMobileButtonsArray = {
    Title: string|State,
    Position: string|State,
    Description: string|State,
    Image: string|State,
};
export type ContextorLibrary = {
    Bind: (self:any, actionName:string, actionHandler: ()->(()->any??,()->any??,()->any??), mobileButton:boolean|ContextorLibrary_supportedMobileButtonsArray?,...Enum.KeyCode|Enum.UserInputType?) -> any,
}&Pseudo;

return Types;