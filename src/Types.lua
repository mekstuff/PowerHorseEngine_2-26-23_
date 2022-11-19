-- type definitions for PowerHorseEngine
-- written by Olanzo James @ Lanzo Inc
-- contributors:
--- template.x

local App = script.Parent;
-- local Enumeration = App.Enumeration;

local Types = {};

type CreateCustomClass = (ClassData:PseudoClass)->(Pseudo);
type CreateCustomClassMethod = <T>(self:any,ClassData:PseudoClass)->(Pseudo);

export type App = any&{
	new: (PseudoName:string,...any)->any,
	-- Enumeration: Enumeration.Enumeration,
	-- Enum: Enumeration.Enumeration,
	Create: CreateCustomClass,
	GetGlobal: (self:any,GlobalName:string)->any,
	GetService: (self:any,ServiceName:string)->any,
	GetProvider: (self:any,ProviderName:string)->any,
	Import: (self:any,libraryName:string)->any,
	GetConfig: (self:any)->any,
	-- GetPseudoFromInstance: typeof(PowerHorseEngine.GetPseudoFromInstance),
}
export type PHeApp = App;

type PseudoRender = (App:App) -> nil

type PHeSignal<T> = {
    Connect: (self:any,(...T)->nil)-> nil,
}

export type Pseudo = {
	Name: string,
	ClassName: string,
	Parent: Instance|Pseudo|any,
    GetFullName: <T>(self:Pseudo)->string,
    WaitForChild: <T>(self:Pseudo,Name:string,onlyPseudo:boolean?,tries:number?)->Pseudo|Instance,
    FindFirstAncestor: <T>(self:Pseudo,Name:string,level:number?)->Pseudo|Instance,
    FindFirstAncestorOfClass: <T>(self:Pseudo,Name:string,level:number?)->Pseudo|Instance,
    FindFirstAncestorWhichIsA: <T>(self:Pseudo,Name:string,level:number?)->Pseudo|Instance,
    FindFirstChild: <T>(self:Pseudo,Name:string,recursive:boolean?,onlyPseudo:boolean?)->Pseudo|Instance,
    FindFirstChildOfClass: <T>(self:Pseudo,Name:string)->Pseudo|Instance,
    FindFirstChildWhichIsA: <T>(self:Pseudo,Name:string)->Pseudo|Instance,
    GetDescendants: <T>(self:Pseudo)->any,
    GetChildren: <T>(self:Pseudo,onlyPseudo:boolean?)->any,
    SerializePropsAsync: <T>(self:Pseudo)->string,
    DeserializePropsAsync: <T>(self:Pseudo,Serialized:string,Apply:boolean?)->any,
    GET: <T>(self:Pseudo,Target:string)->any?,
    Clone: <T>(self:Pseudo)->Pseudo?,
    Destroy: <T>(self:Pseudo)->nil,
    GetPropertyChangedSignal: <T>(self:Pseudo)->nil,
    IsA: <T>(self:Pseudo,ClassQuery:string)->boolean,
    _GetAppModule: <T>(self:any)->App,
    _GetCompRef: <T>(self:Pseudo)->Instance,
    GetRef: <T>(self:Pseudo)->Folder,
    AddEventListener: <T>(self:Pseudo,EventName:string,CreatingEvent:boolean?,BindCreateToEvent:BindableEvent?,SharedSignal:boolean?)->PHeSignal<nil>,
    RemoveEventListener: <T>(self:Pseudo,Events:string|any)->nil,
    RemoveEventListeners: <T>(self:Pseudo)->nil,
    GetEventListener: <T>(self:Pseudo)->PHeSignal<nil>,
    _lockProperty: <T>(self:Pseudo,propertyName:string,propertyCallback:any)->nil,
    _lockProperties: <T>(self:Pseudo,properties:string|any)->nil,
    _unlockProperty: <T>(self:Pseudo,propertyNames:string|any)->nil,
    [string]: any?
    -- _Render: PseudoRender
}


type useEffect = (Handler:any, Depedencies:any?) -> nil
type useRender = () -> nil

type StateFunctionalCall = () -> any
export type State = Pseudo&StateFunctionalCall&{
    State: any,
};
export type PHeState = State;

export type PseudoHooks = {
    useEffect: useEffect,
    useRender: useRender,
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
    Try: <T>(self:any,handler:(resolve:any,reject:any,cancel:any)->nil) -> Promise,
    Then: <T>(self:any,handler:(res:any)->nil) -> Promise,
    Catch: <T>(self:any,handler:(err:any)->nil) -> Promise,
    Cancel: <T>(self:any,handler:(err:any)->nil) -> Promise,
};
export type PHePromise = Promise;

--> AI
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
export type PHeAIPet = AIPet;

--> Base Gui's
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
export type PHeBaseGui = BaseGui;
export type GUI = {

};
export type PHeGUI = GUI;
export type Text = {

};
export type PHeText = Text;
export type Frame = {
    MouseButton1Down: PHeSignal<nil>,
    MouseButton2Down: PHeSignal<nil>,
    MouseButton1Up: PHeSignal<nil>,
    MouseButton2Up: PHeSignal<nil>,
    MouseClick: PHeSignal<nil>,
    MouseLeave: PHeSignal<nil>,
};
export type PHeFrame = Frame;
export type BaseText = Pseudo&GUI&{
    GetUserTextAsync: (self:any,ShowText:string?) -> (string|nil,boolean),
};
export type PHeBaseText = BaseText;
export type Accordion = Pseudo&BaseGui&{
    Icon: string,
    Font: Enum.Font,
    TextSize: number,
    TextColor3: Color3,
    Expanded: boolean,
    -- AccordionButtonPosition: Enumeration
    AutomaticSize: Enum.AutomaticSize,
    ButtonSize: UDim2,
    AutoExpand: boolean,
    ButtonMouseEnter: PHeSignal<nil>,
    ButtonMouseLeave: PHeSignal<nil>,
};
export type PHeAccordion = Accordion;

export type ActionMenuAction = Pseudo&{
    ID: string,
    Text: string,
    Icon: string,
    OnAction: PHeSignal<nil>,
    UpdateText: (self:any,Text:string)->nil,
    UpdateIcon: (self:any,Icon:string)->nil
};
export type PHeActionMenuAction = ActionMenuAction;

export type ActionMenu = Pseudo&{
    -- AutomaticHide: 
    Showing: boolean,
    TextSize: number,
    ShowAsync: (self:any,...any)->ActionMenuAction|nil,
    Show: (self:any,ignoreFocusLost:boolean?,CustomAdornee:any?)->nil,
    Hide: (self:any)->nil,
    AddSplit: (self:any)->nil,
    AddPadding: (self:any,y:number?)->nil,
    AddHeader: (self:any,Header:string?)->nil,
    AddAction: (self:any,ActionName:string,id:string,ActionIcon:string?,...any?)->ActionMenuAction,
    UpdateAllIcons: (self:any,Icon:string, IgnoreList:table?, Inverse:boolean?)->nil,
    GetActions: (self:any,Icon:string)->{},
    GetAction: (self:any,ActionName:string)->ActionMenuAction,
    AddToTree: (self:any,...any)->nil,
    ActionTriggered: PHeSignal<ActionMenuAction>
};
export type PHeActionMenu = ActionMenu;

export type AppBar = Pseudo&BaseGui&{
    Text: string,
    TextColor3: Color3,
    Icon: string,
    Size: UDim2,
    ActionButtonPressed: PHeSignal<nil>
};
export type PHeAppBar = AppBar;
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
export type PHeButton = Button;
export type Checkbox = BaseGui&Frame&{
    Icon: string,
    Toggle: boolean,
    AutoToggle: boolean,
    Toggled: PHeSignal<boolean>
};
export type PHeCheckbox = Checkbox;

export type Modal = Pseudo&BaseGui&GUI&{
    Header: string,
    HeaderIcon: string,
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
    AddButton: (self:any,Text:string,styles:{}?,ID:any?)->Button,
    OnHighlightClicked: (self:any, handler:()->nil) -> nil
    -- CloseButtonBehaviour: Enumeration.CloseButtonBehaviour,
};
export type PHeModal = Modal;
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
export type PHeModalPrompt = Prompt;


--> Services
export type AudioChannelAudio = Pseudo&{
    Play:<T>(self:any)->nil,
    Resume:<T>(self:any)->nil,
    Pause:<T>(self:any)->nil,
    Stop:<T>(self:any)->nil,
    isDefaultAudio: boolean,
};
export type PHeAudioChannelAudio = AudioChannelAudio;
export type AudioChannel = Pseudo&{
    AddAudio:<T>(self:Pseudo,AudioName:string,AudioID:number,AudioVolume:number?,Looped:boolean?,PlayAudio:boolean?,Instant:boolean?)->AudioChannelAudio,
    SetAudioMuted:<T>(self:any,AudioName:string,State:boolean,AudioInstance:any)->nil,
    GetAudio:<T>(self:any,AudioName:string)->AudioChannelAudio,
    GetAudios:<T>(self:any)->nil,
    SetDefaultAudio:<T>(self:any,AudioName:string)->nil,
    SetVolume:<T>(self:any,Volume:number)->nil,
    Mute:<T>(self:any)->nil,
    UnMute:<T>(self:any)->nil,
    PlayAudio:<T>(self:any,AudioName:string,FromPaused:boolean?)->nil,
    StopAudio:<T>(self:any,AudioName:string,ignoreDefault:boolean?)->nil,
    PauseAudio:<T>(self:any,AudioName:string,ignoreDefault:boolean?,DoNotRemove:boolean?)->nil,
    MuteChanged: PHeSignal<nil>,
    AudioAdded: PHeSignal<nil>,
    AudioRemoved: PHeSignal<nil>,
    AudioMuteChanged: PHeSignal<nil>,
    DefaultAudioTriggered: PHeSignal<nil>,
    Audios: {}
};
export type PHeAudioChannel = AudioChannel;
export type AudioService = {
    GetChannel:<T>(self:any,ChannelName:string)->AudioChannel,
    GetChannels:<T>(self:any)->any,
    RemoveChannel:<T>(self:any,ChannelName:string)->nil,
    CreateSoundEffectsChannel:<T>(self:any,ChannelName:string?)->AudioChannel,
    CreateChannel:<T>(self:any,ChannelName:string,AudiosAllowedInParallel:number?,DefaultVolume:number?,DefaultLoop:boolean?,AudiosInstant:boolean?)->AudioChannel,
    MuteChannel:<T>(self:any,ChannelName:string)->nil,
    UnmuteChannel:<T>(self:any,ChannelName:string)->nil,  
};
export type PHeAudioService = AudioService;
export type PseudoClassFunctionalRender = (PseudoHooks:PseudoHooks) -> nil
export type PseudoClass = {
    Name: string?,
	ClassName: string,
	_Render: (self:any, App:App?)->({}|PseudoClassFunctionalRender),
    [string]: any?
}
export type CustomClassService = {
	CreateClassAsync: CreateCustomClassMethod,
	Create: CreateCustomClassMethod
};
export type PHeCustomClassService = CustomClassService;
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
    concat: <T>(self:any,ConcatVal:any) -> FormatGlobalObject,
    toNumber: <T>(self:any) -> FormatGlobalObject,
    toString: <T>(self:any) -> FormatGlobalObject,
    atStart: <T>(self:any,State:any) -> FormatGlobalObject,
    atEnd: <T>(self:any,State:any) -> FormatGlobalObject,
    toTimeDifference: <T>(self:any,format:string) -> (FormatGlobalObject,any),
    toDateFormat: <T>(self:any,useString:boolean?,shortenString:boolean?,indicateDayAsNumber:boolean?) -> (string),
    toTimeFormat: <T>(self:any) -> (string),
    fromUnixStamp: <T>(self:any,is12Hour:boolean) -> FormatGlobalObject,
    toNumberAbbreviation: <T>(self:any,tuple:any?) -> FormatGlobalObject,
    toNumberCommas: <T>(self:any) -> FormatGlobalObject,
    End: <T>(self:any) -> any,
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
    InitPlugin: <T>(self:any,plugin:Plugin)->nil,
    InitServer: <T>(self:any,PushPackages:boolean?)->nil,
    InitClient: <T>(self:any,Client:Player?)->nil,
    RequestContentFolder: <T>(self:any)->Folder,
    RequestConfig: <T>(self:any)->userConfigModule,
    RequestUserGameContent: <T>(self:any)->userConfigGameContent,
    FetchReplicatedStorage: <T>(self:any)->Folder,
    FetchWorkspaceStorage: <T>(self:any)->Folder,
    FetchLocalEvents: <T>(self:any)->Folder,
    FetchServerStorage: <T>(self:any)->Folder,
    FetchStorageEvent: <T>(self:any,EventType:string,EventType:string?)->RemoteEvent|RemoteFunction|BindableEvent?,
}
export type PHeEngine = Engine;
--> Built in libraries
export type StateSetterFunc = (value:any) -> nil;
export type PHeStateSetterFunc = StateSetterFunc;
export type StateLibrary = (defaultValue:any?) -> (State,StateSetterFunc);
export type PHeStateLibrary = StateLibrary;

export type PointerLibrary = (Instance:Instance,Parent:any?) -> Pseudo;

export type FrameworkLibraryService = {
    Init: <T>(self:any)->(nil)?,
    Start: <T>(self:any)->nil,
    GetService: <T>(self:any,ServiceName:string)->FrameworkLibraryService,
    GetComponentClass: <T>(self:any,ComponentClassName:string)->any,
    UseChannel: <T>(self:any, ChannelName:string)->RemoteEvent,
    Shared: any?
};
export type PHeFrameworkLibraryService = FrameworkLibraryService;
export type FrameworkLibraryServer = {
    Start: <T>(self:any)->Promise,
    PortService: <T>(self:any,Service:ModuleScript)->FrameworkLibraryService,
    PortServices: <T>(self:any,Services:Folder|any)->nil,
    PortComponentClass: <T>(self:any,ComponentClass:ModuleScript)->nil,
    PortComponentClasses: <T>(self:any,ComponentClasses:Folder|any)->nil,
    GetComponentClass: <T>(self:any,ComponentClassName:string)->any,
    GetService: <T>(self:any,ServiceName:string)->FrameworkLibraryService,
};
export type PHeFrameworkLibraryServer = FrameworkLibraryServer;
export type FrameworkLibraryModular = Pseudo&{
    Init: <T>(self:any)->nil,
    Start: <T>(self:any)->nil,
    GetModular: <T>(self:any,ServiceName:string)->FrameworkLibraryModular,
    GetComponentClass: <T>(self:any,ComponentClassName:string)->any,
    UseChannel: <T>(self:any, ChannelName:string)->RemoteEvent,
};
export type PHeFrameworkLibraryModular = FrameworkLibraryModular;
export type FrameworkLibraryClient = {
    Start: <T>(self:any)->Promise,
    PortModular: <T>(self:any,Service:ModuleScript)->FrameworkLibraryModular,
    PortModulars: <T>(self:any,Services:Folder|any)->nil,
    PortComponentClass: <T>(self:any,ComponentClass:ModuleScript)->nil,
    PortComponentClasses: <T>(self:any,ComponentClasses:Folder|any)->nil,
    GetComponentClass: <T>(self:any,ComponentClassName:string)->any,
    GetService: <T>(self:any,ServiceName:string)->FrameworkLibraryModular,
    GetModular: <T>(self:any,ServiceName:string)->FrameworkLibraryModular,
};
export type PHeFrameworkLibraryClient = FrameworkLibraryClient

return Types;