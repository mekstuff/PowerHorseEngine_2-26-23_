"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[1926],{3905:(e,t,n)=>{n.d(t,{Zo:()=>s,kt:()=>d});var o=n(67294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);t&&(o=o.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,o)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,o,r=function(e,t){if(null==e)return{};var n,o,r={},i=Object.keys(e);for(o=0;o<i.length;o++)n=i[o],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(o=0;o<i.length;o++)n=i[o],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var c=o.createContext({}),u=function(e){var t=o.useContext(c),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},s=function(e){var t=u(e.components);return o.createElement(c.Provider,{value:t},e.children)},m={inlineCode:"code",wrapper:function(e){var t=e.children;return o.createElement(o.Fragment,{},t)}},p=o.forwardRef((function(e,t){var n=e.components,r=e.mdxType,i=e.originalType,c=e.parentName,s=l(e,["components","mdxType","originalType","parentName"]),p=u(n),d=r,g=p["".concat(c,".").concat(d)]||p[d]||m[d]||i;return n?o.createElement(g,a(a({ref:t},s),{},{components:n})):o.createElement(g,a({ref:t},s))}));function d(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=n.length,a=new Array(i);a[0]=p;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l.mdxType="string"==typeof e?e:r,a[1]=l;for(var u=2;u<i;u++)a[u]=n[u];return o.createElement.apply(null,a)}return o.createElement.apply(null,n)}p.displayName="MDXCreateElement"},5722:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>c,contentTitle:()=>a,default:()=>m,frontMatter:()=>i,metadata:()=>l,toc:()=>u});var o=n(87462),r=(n(67294),n(3905));const i={sidebar_position:4},a="Stateful Button Incrementing",l={unversionedId:"Tutorials/intro",id:"Tutorials/intro",title:"Stateful Button Incrementing",description:"How to use State & the State Library",source:"@site/docs/Tutorials/intro.md",sourceDirName:"Tutorials",slug:"/Tutorials/intro",permalink:"/PowerHorseEngine/docs/Tutorials/intro",draft:!1,editUrl:"https://github.com/lanzoinc/PowerHorseEngine/edit/main/docs/Tutorials/intro.md",tags:[],version:"current",sidebarPosition:4,frontMatter:{sidebar_position:4},sidebar:"defaultSidebar",previous:{title:"libs",permalink:"/PowerHorseEngine/docs/Customization/libs"},next:{title:"Dark & Light Theme",permalink:"/PowerHorseEngine/docs/Tutorials/DarkAndLightTheme"}},c={},u=[{value:"Vanilla",id:"vanilla",level:2},{value:"State Pseudo",id:"state-pseudo",level:3},{value:"StateLibrary",id:"statelibrary",level:3},{value:"Whiplash Library",id:"whiplash-library",level:2}],s={toc:u};function m(e){let{components:t,...n}=e;return(0,r.kt)("wrapper",(0,o.Z)({},s,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"stateful-button-incrementing"},"Stateful Button Incrementing"),(0,r.kt)("admonition",{title:"What you'll learn",type:"note"},(0,r.kt)("blockquote",{parentName:"admonition"},(0,r.kt)("p",{parentName:"blockquote"},"How to use State & the State Library")),(0,r.kt)("blockquote",{parentName:"admonition"},(0,r.kt)("p",{parentName:"blockquote"},"How to use the Whiplash Library"))),(0,r.kt)("p",null,"All of the following examples below will produce the exact same results, PowerHorseEngine provides alot of ways to complete tasks, you decide which one you feel comfortable transitioning to."),(0,r.kt)("h2",{id:"vanilla"},"Vanilla"),(0,r.kt)("h3",{id:"state-pseudo"},"State Pseudo"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));\nlocal PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui");\n\nlocal DemoUI = Instance.new("ScreenGui");\nDemoUI.Name = "Demo-Ui";\nDemoUI.Parent = PlayerGui;\n\nlocal ClickState = PowerHorseEngine.new("State");\nClickState.State = 0;\n\nlocal Button = PowerHorseEngine.new("Button");\nButton.Position = UDim2.fromScale(.5,.5);\nButton.AnchorPoint = Vector2.new(.5,.5);\nButton.Parent = DemoUI;\n\nButton.MouseButton1Down:Connect(function()\n    ClickState.State += 1;\nend)\n\nClickState:useEffect(function(clickCount)\n    local clickCountAsString = tostring(clickCount) or tostring(clickCount()) or tostring(clickCount.State) --\x3e All 3 of these will be the same.\n    Button.Text = "You clicked "..clickCountAsString.." "..(clickCount == 1 and "time" or "times")\nend)\n')),(0,r.kt)("h3",{id:"statelibrary"},"StateLibrary"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));\nlocal State = PowerHorseEngine:Import("State");\nlocal PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui");\n\nlocal DemoUI = Instance.new("ScreenGui");\nDemoUI.Name = "Demo-Ui";\nDemoUI.Parent = PlayerGui;\n\nlocal ClickState,setClickState = State(0);\n\nlocal Button = PowerHorseEngine.new("Button");\nButton.Position = UDim2.fromScale(.5,.5);\nButton.AnchorPoint = Vector2.new(.5,.5);\nButton.Parent = DemoUI;\n\nButton.MouseButton1Down:Connect(function()\n    setClickState(function(oldClickState)\n        return oldClickState+1;\n    end)\n    --[[OR\n        setClickState(oldClickState()+1)\n    ]]\nend)\n\nClickState:useEffect(function(clickCount)\n    local clickCountAsString = tostring(clickCount) or tostring(clickCount()) or tostring(clickCount.State) --\x3e All 3 of these will be the same.\n    Button.Text = "You clicked "..clickCountAsString.." "..(clickCount == 1 and "time" or "times")\nend)\n\n')),(0,r.kt)("h2",{id:"whiplash-library"},"Whiplash Library"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));\nlocal New = PowerHorseEngine.New or PowerHorseEngine:Import("Whiplash").New --\x3e Same Thing\nlocal OnEvent = PowerHorseEngine.OnWhiplashEvent or PowerHorseEngine:Import("Whiplash").OnEvent --\x3e Same thing\nlocal State = PowerHorseEngine:Import("State");\n\nlocal ClickCount,setClickCount = State(0);\nlocal ButtonText,setButtonText = State("");\n\nClickCount:useEffect(function(count)\n    setButtonText("You clicked "..tostring(count).." "..(count == 1 and "time" or "times"));\nend);\n\nNew "ScreenGui" {\n    Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui");\n    Name = "Demo-Ui";\n    New "$Button" {\n        Position = UDim2.fromScale(.5,.5);\n        AnchorPoint = Vector2.new(.5,.5);\n        Text = ButtonText;\n        [OnEvent "MouseButton1Down"] = function()\n            setClickCount(function(oldClickCount)\n                return oldClickCount+1;\n            end)\n        end\n    }\n}\n')))}m.isMDXComponent=!0}}]);