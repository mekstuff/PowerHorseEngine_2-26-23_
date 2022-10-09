## Where to Place

It is important to know where you should place `PowerHorseEngine` into your projects.

=== "Game Development"
    
    The `PowerHorseEngine` module should be placed into `ServerScriptServices`. It will end up inside of `ReplicatedStorage` in runtime so to access it you will use
    ```lua
    game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine");
    ```

    !!! warning "Do not use:"
        ```lua
        game:GetService("ServerScriptService"):WaitForChild("PowerHorseEngine");
        ```

    This will inject the `PowerHorseEngine` packages into your game and give your game core features, like access to `NotificationService` and more.

=== "Plugin Development"

    It is recommended to place the `PowerHorseEngine` into the root of your plugin.

    !!! tip
        `Packages` are not released in plugin mode.

=== "Miscs"

    PowerHorseEngine can also be used as a standalone module in runtime if you do not sync it into `ServerScriptService`

    !!! bug "Unstable"
        This is unstable and not recommended

---

## .content

Before PowerHorseEngine can work properly, it requires a `.content` folder to be synced into its root folder.

=== "Setup with Rojo"

    Within your project, create a folder called `.content` and sync it into the root folder of `PowerHorseEngine`

    ```json
        {
            "name": "demo",
            "ServerScriptServices":{
                "PowerHorseEngine": {
                    "$path": "../path/to/PowerHorseEngine",
                    ".content": {
                        "$path": "../path/to/contentfolder"
                    }
                }
            }
        }
    ```
=== "Setup in studio"

    Create a new folder inside the `PowerHorseEngine` module and rename it to `.content`

The `.content` folder is you interact with PowerHorseEngine based on your project. Below are important folders that can be placed into the .content folder

!!! warning
    without some of these folders you can experience warnings and errors


### ico

The `ico` is a very important folder that is used by alot of core scripts. It is a folder that the image provider uses to access images. learn about the [ImageProvider](#) here

!!!tip
    It is recommended that all your projects should contain a mdi ico module, the mdi module is a ico module for Material Design Icons by Google (rbx img urls by qweery)

    To add Material Design Icons to your project, within the `ico` folder, create a `ModuleScript` named `mdi` and paste the following script into the module

    ??? note "mdi source"

        ```lua
        -- Written by Olanzo James @ Lanzo, Inc.
        -- Saturday, September 24 2022 @ 08:50:06
        -- Credit to Google Inc and Qweery
        -- Core icons uses mdi, removing this from your experience will make some icons not be shown.
        -- Cached.

        local mdipackage = 11024471495;
        local InsertService = game:GetService("InsertService");
        local package;
        local RunService = game:GetService("RunService");
        local IsRunning,IsClient = RunService:IsRunning(),RunService:IsClient();


        --> loads from external source to lower Engine's size (only use the package when needed, sorta better
            local s,r = pcall(function()
                if(IsRunning and IsClient)then 
                    return nil;
                end;
                return InsertService:LoadAsset(mdipackage):GetChildren()[1];
            end);
            if(not s)then
                warn("mdi FATAL ERROR: ",r);
                return {} --> icons will not load, you will get warnings like: (could not find ico path ico-mdi@communication/list_alt failed @ communication)
            end;
            if(IsRunning)then
                if(IsClient)then
                    --> this module should not exist/replicate onto clients. if so then your icons will fail until the proper module is loaded
                    script.Parent = nil;
                    script:Destroy();
                    -- print("Destroyed",script.Parent)
                    return "$wait";
                end
                --> In game, we load the actual module, this way it is replicated to clients. A corescript does this for us on start.
                local icons = r.Icons;
                icons.Name = script.Name;
                icons.Parent = script.Parent;
                script:Destroy();
                return require(icons);
            end;
            package = require(r.Icons);
        return package;
        ```

    Some CoreScripts may also want to use local ROBLOX icons, to add this then add another `ModuleScript` to the `ico` folder and name it `rbx` and paste the follow code inside

    ??? note "rbx source"

        ```lua
        -- Written by Olanzo James @ Lanzo, Inc.
        -- Tuesday, September 06 2022 @ 19:41:10
        -- This icon pack uses roblox's /content/textures folder in local directory
        -- This icon pack can only be used in ROBLOX studio, so plugin use only.
        -- Built mainly for PowerHorseEngine projects

        return function (uri)
            local fileType = uri:match("%.%w+$") and "" or ".png";
            local link = "rbxasset://textures/"..uri..fileType;
            return link;
        end
        ```

---

### libs

The `libs` folder is used by the engine to import `cloud` libraries. Learn about importing them [here](#)


### Config

The config `module` is used to configure settings about your project

??? abstract "Config Source Template"

    ```lua

    return {

        
        PHePanel = {																																			--[[

                                                    PHE PANEL RANKING
                                    +--------+---------------+----------------------+
                                    | Rank # | Rank Name     | Rank Command Access  |
                                    +--------+---------------+----------------------+
                                    | 3      | Owner         | All commands         |
                                    +--------+---------------+----------------------+
                                    | 2      | Administrator | Majority of commands |
                                    +--------+---------------+----------------------+
                                    | 1      | Moderator     | Limited commands     |
                                    +--------+---------------+----------------------+
                                    | 0      | Player        | No Commands          |
                                    +--------+---------------+----------------------+
                                    
            You do not need to include yourself as an owner
                                                                                                                        ]]
            Ranks = {
                {3, "Owner", 			{330520900}},
                {2, "Admin",			{}},
                {1, "Mod", 				{}},
                {0, "Player", 			{}},
            },
            
            Groups = {
                [0]={
                    [254] = "Admin",
                };
            },	
            ExecuteCommandsFromChat = true;
            ChatPrefixSyntax = ":" --< :Command variable1 variable2
        };
        
            ------------------------------------ [ Game ] ----------------------------------------------
        Game = {
            AmbientMusic = false;
            ------------------------------------ [ SOUNDS ] ----------------------------------------------
            Sound = {
                ------------------------------------ [ Effects ] ----------------------------------------------
                Effects = {
                    Buttons = {
                        --MouseEnter = 6324790483;
                        --MouseLeave = 6324790483;
                        --Mouse1Down = 6324790483;
                        --Mouse1Up = 6324790483;
                    };	
                    NotificationService = {
                        --Low = 6026984224;
                        --Medium = 8055713313;
                        --High = 4590662766;
                        --Critical = 6462214457;
                    };
                };
                ------------------------------------ [ Music ] ----------------------------------------------
                Music = {
                    Ambient = {
                        {Name = "TickleBrain", SoundId = 1839746621};
                        {Name = "TickleBrain2", SoundId = 1845419243};			
                    }	
                };
            };

            ------------------------------------ [ Startup ] ----------------------------------------------
            Startup = {
                disableStartup = true;
                StartupColor = Color3.fromRGB(255, 255, 255);
                SplashScreen = {
                    Enabled = true;
                    Screens = {
                        --{Logo = "LogoGoesHere"};
                    }
                }
            };


        };
        
        --DO NOT EDIT
        v = "0.1.0";
        
    }
    ```

#### PHePanel Custom Commands

You can also create PHePanel custom commands here aswell, to prevent cluster from the config source, you'll create a new Folder and call it `CustomCMDS` and place it into your Config Module. You can then create `ModuleScripts` inside the folder with the name of the command

??? abstract "Command Template"
    ```lua
    return {
        cmd = "Command"; --// Name of the command (cannot be an existing command)
        desc = "Description"; --// Description of the command
        req = "Admin";--// Rank of the command, ("Owner", "Admin", "Mod", "Player")
        args = { --//arguments that are needed for command
            {
                --//name of argument
                var="name",
                --//type of argument
                type="string",
                --//is this argument required?
                req=false,
                --//description of argument (can be nil)
                desc="awesome description",
                --//default value of this argument (can be nil)
                default="awesome sauce"};
        };
        --//executable that is triggered when the command is called. (will run on the server)
        exe = function(argument1)
            print(argument1); -->"awesome sauce"
        end,
    }
    ```