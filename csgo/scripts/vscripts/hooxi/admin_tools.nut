/* 
############### READ ME ###############

## Install & Requirements

  1) Copy and include the file with:
       IncludeScript("admin_tools.nut")

  2) Add the function at the end of your event function, and pass the correct `event_data` argument for the chat commands to work.
       ::state.AT.event.player_say(data)

  4) Make sure targetnames of the info_enemy_terrorist_spawn are sortable.
       OK       : `bot.1.spawn` to `bot.5.spawn` or `bot_1` to `bot_5`
       NOT OK   : `bot_one` or `bot1`, `bot2` (disabled), `bot2b`, `bot3` ..

## Usage

  Note:
    - Chat commands are disabled by default, unless the AdminTools() are enabled.

  Toggle with:
    script AdminTools()

*/

if(!::state.exists("bots_loadout"))
{
    ::state.bots_loadout <- ::DEFAULT_BOT_EQUIPMENT;
}
if(!::state.exists("AT"))
{
    ::state.AT <-
    {
        BOT_SPAWNS = [],
        ENABLED = false,
    }
}
::HELP <-
{
    hp = "Set player health between 1 and 1000. Commands: [ !hp <number> | !hp r | !hp reset ]",
    weapons = "Print all available weapons into console",
    weapon = "Set bot weapons. No need to write knife. Commands: [ !weapon ak47 deagle p90 | !weapon r | !weapon reset ]",
    at = "Reset admin tool",
    face = "Set facer value between -1000 and 1000. Commands: [!face <bot_number> <facer_value> | !face r | !face reset",
    hspread = "Set hspread value between -1000 and 1000. Commands: [!hspread <bot_number> <hspread value>] | !hspread r | !hspread reset",
    diff = "Set bot difficulty. Commands: [ !diff 1 2 3 4 5 ]",
    help = "Use !help and any availabe command to know more about that command, like !help hp",
}

::GiveArmorDelay<-function(bot)
{
    local armorEnt = Entities.CreateByClassname("item_heavyassaultsuit");
    armorEnt.SetOrigin(bot.GetOrigin());
    printl("Armor ent given coordinates " + bot.GetOrigin());
}
//
// Chat Commands
//
::ProcessChat<-function(event)
{
    if(!::state.AT.ENABLED)
    {
        return;
    }
    local s,args,cmd,argsCount;
    try
    {
        s = event.text.tolower()
        args = split(s, " ")
        cmd = args.remove(0)
        argsCount = args.len()
    }
    catch(e)
    {
        return;
    }
    switch(cmd)
    {
        case "!commands":
        {
            ::ChatHelp();
            break;
        }
        case "!help":
        {
            Chat(::HELP[args[0]]);
            break;
        }
        case "!at": 
        {
            if(args[0] == "reset" || args[0] == "r")
            {
                ::ResetAdminTools();
                break;
            }
            break;
        }
        case "!face":
        {
            if(args[0] == "reset" || args[0] == "r")
            {
                ::ResetZCorrection();
                break;
            }
            if(argsCount<2)
            {
                Chat(TextColor.Red + "Not enough variables. Please specify bot number and facer value");
                break;
            }
            ::SetZCorrectionByBotNumber(args[0],args[1]);
            break;
        }
        case "!hspread":
        {
               if(args[0] == "reset" || args[0] == "r")
            {
                ::ResetHspread();
                break;
            }
            if(argsCount<2)
            {
                Chat(TextColor.Red + "Not enough variables. Please specify bot number and hspread value");
                break;
            }
            ::SetHspreadByBotNumber(args[0],args[1]);
            {
            }
             break;   
        }
        case "!weapons":
        {
            Chat(TextColor.Common + "Weapons printed in console!");
            ::Utils.PrintObject(::DEBUG_WEAPONS);
            break;   
        }
        case "!weapon":
        {
            if( args[0]== "reset" || args[0]=="r")
            {
                ::ResetBotWeapons();
                break;
            }
            try 
            {
                for(local i=0;i<argsCount;i++)
                {
                    local equipment = args[i].tostring();
                    ::state.bots_loadout[i] = equipment + ",knife";
                    if(::state.AT.ENABLED)
                    {
                        Chat("Bot #"+(i+1) + " was given " +::state.bots_loadout[i]);
                    }
                }
            }
            catch(e)
            {
                Chat(TextColor.Red + " Invalid parameters");
                printl(e);
                break;
            }
            break;   
        }
        // case "!armor":
        // {
        //     if( args[0]== "reset" || args[0]=="r")
        //     {
        //         ::ResetBotWeapons();
        //         break;
        //     }
        //     try 
        //     {
        //         for(local i=0;i<argsCount;i++)
        //         {
        //             local armor = args[i].tostring();
        //             if(armor == "kevlar" || armor == "suit" || armor == "heavy")
        //             {
        //                 switch(armor)
        //                 {
        //                     case "kevlar": armor = "item_kevlar"; break;
        //                     case "suit": armor = "item_assaultsuit"; break;
        //                     case "heavy": armor = "item_heavyassaultsuit"; break;
        //                 }
        //                 local bot = null;
        //                 local i = 0;
        //                 while (bot = Entities.FindByClassname(bot, "cs_bot")) 
        //                 {
        //                     local str ="GiveArmorDelay("+bot+")";
        //                     EntFire("@script","runscriptcode",str,i+0.1);
        //                     i++;
                           
        //                 }

        //                 if(::state.AT.ENABLED)
        //                 {
        //                     Chat("Bot #"+(i+1) + " was given " + armor);
        //                 }
        //             }
        //             else
        //             {
        //                 Chat(TextColor.Red + "Bot " + i + " was given a wrong type of armor \n Please use item_kevlar or item_assaultsuit");
        //             }
        //         }
        //     }
        //     catch(e)
        //     {
        //         Chat(TextColor.Red + " Invalid parameters");
        //         printl(e);
        //         break;
        //     }
        //     break;   
        // }
        case "!hp":
        {
            if(!argsCount || args[0] == "r" || args[0] == "reset")
            {
                ::ResetPlayerHealth();
                break;
            }
            else
            {
                try
                {
                    local finalHealth = ::Utils.Clamp(args[0].tointeger(),1,1000);
                    ::player.SetHealth(finalHealth);
                    Chat(TextColor.Award + "Health set to " + finalHealth);
                }
                catch(e)
                {
                    Chat(TextColor.Red + "Invalid health value");
                }
            }
            break;   
        }
        case "!diff":
        {
            printl("user chat diff")
            if( args[0] == "reset" || args[0] == "r")
            {
                printl("-1")
                ::ResetDifficulty()
            }
            else
            {
                printl("c-2")
                ::SetEnemySpawnDifficulties(args);
            }
            break;   
        }
    }
}
