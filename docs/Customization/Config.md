# Config

Config is expected to be a module, it should contain base information about your experience.

Config Template:

```lua
return {

        ------------------------------------ [ Theme ] ----------------------------------------------
    Theme = {
        Font = Enum.Font.FredokaOne;
    };

    PHePanel = { 
        Disabled = false;
                                                                                                                                                    --[[

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
            {3, "Owner",            {330520900}},
            {2, "Admin",            {}},
            {1, "Mod",              {}},
            {0, "Player",           {}},
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

    ------------------------------------ [ -flags ] ----------------------------------------------
    ["-flags"] = {
        -- "force-env {game}"
    },
}

```