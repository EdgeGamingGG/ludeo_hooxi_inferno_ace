/**
* Toggle admin tools on/off
* Can only be toggled via console
*/
::AdminTools<-function()
{
    ::state.AT.ENABLED = !::state.AT.ENABLED;
    printl("Admin tools is " + (::state.AT.ENABLED ? "Enabled" : "Disabled"));
    Chat("Admin tools is now " + (::state.AT.ENABLED ? (TextColor.Award+"Enabled") : (TextColor.Red+"Disabled")));
    if(::state.AT.ENABLED)
    {
        ::ChatHelp();
    }
}
//
// Set difficulty for all info_enemy_terrorist_spawn entities
//
::SetEnemySpawnDifficulties<-function(a=[],silent=false)
{
    if ( typeof(a) != "array" || !a.len() )
    {
        printl("[AT] - Invalid array parameter");
        return;
    }
    local botSpawns = ::GetBotSpawns();
    local difficulty = 7
    foreach (i, v in a)
    {
        if ( i == botSpawns.len()){ 
            break
        }

        try 
        {
            difficulty = v.tointeger()
        } 
        catch(exception)
        {
            difficulty=7
        }

        // ::state.custom_difficulty[i] = difficulty.tointeger();
        SetEnemySpawnDifficulty( ::state.AT.BOT_SPAWNS[i], difficulty.tointeger());
        if(::state.AT.ENABLED && !silent)
        {
            Chat( "\xA" + "Set difficulty for spawn " + "\x6" + (i+1) + "\xA" + " to " + "\x4" + difficulty);
        }
    }
}

/*
* Returns an array of all bot spawn entities
*/
::GetBotSpawns<-function()
{
    if( !::state.AT.BOT_SPAWNS.len())
    {
        local classname = "info_enemy_terrorist_spawn"
        for(local e; e = Entities.FindByClassname(e, classname);)
        {
            ::state.AT.BOT_SPAWNS.append(e)
        }
        ::state.AT.BOT_SPAWNS.sort( ::Utils.SortByTargetname )
    }
    return (::state.AT.BOT_SPAWNS);
}

::SetEnemySpawnDifficulty<-function(ent, bot_difficulty=0){
    ent.__KeyValueFromInt( "bot_difficulty", bot_difficulty.tointeger() )
}
::SetEnemySpawnAgressive<-function(ent, is_agressive=1){
    ent.__KeyValueFromInt( "is_agressive", is_agressive.tointeger() )
}
::SetEnemySpawnBehavior<-function(ent, default_behavior=2){
    ent.__KeyValueFromInt( "default_behavior", default_behavior.tointeger() )
}
::SetEnemySpawnBehaviorFile<-function(ent, behavior_tree_file="scripts/ai/bt_default.kv3"){
    ent.__KeyValueFromString( "behavior_tree_file", behavior_tree_file.tostring() )
}
::SetEnemySpawnArmor<-function(ent, armor_to_give=1){
    ent.__KeyValueFromInt( "armor_to_give", armor_to_give.tointeger() )
}
::SetEnemySpawnWeapons<-function(ent, weapons_to_give="glock,ak47"){
    ent.__KeyValueFromString( "weapons_to_give", weapons_to_give.tostring() )
}
::SetEnemySpawnHideRadius<-function(ent, hide_radius=1000){
    ent.__KeyValueFromInt( "hide_radius", hide_radius.tointeger() )
}
::SetEnemySpawnModel<-function(ent, model_to_use=""){
    ent.__KeyValueFromString( "model_to_use", model_to_use.tostring() )
}


// Prints all commands to the chat
::ChatHelp<-function()
{
    Chat( " " )
    Chat( "Chat Commands:" )
    Chat( "\xA" + "!diff" )
    Chat( "\xA" + "!face")
    Chat( "\xA" + "!weapons" )
    Chat( "\xA" + "!weapon" )
    Chat("\xA"+ "!hspread")
    Chat("\xA"+ "!hp")
    Chat("\xA" + "!help - Write any command as parameter for more info | Example: !help weapon")
    Chat( "\xA" + "!at" )
    Chat("\xA" + "!commands - Print list of commands")
}
// Reset difficulty back to default. Does not integrate with the official difficulty feature
::ResetDifficulty<-function()
{
    ::state.custom_difficulty = [0,0,0,0,0];
   	::SetEnemySpawnDifficulties(::DIFFICULTY_ARRAYS[::state.playable_difficulty-1]);
}
// Function gives weaposn for each bot spawn based on ::state.bots_loadout
::GiveBotsWeapons<-function()
{
    local bots = ::GetBotSpawns();
    local counter = 0;
    try
    {
        foreach(_spawn in bots)
        {
            if(counter>=::BOTS_KILL_QUOTA)
            {
                return;
            }
            try
            {
                _spawn.__KeyValueFromString( "weapons_to_give",  ::state.bots_loadout[counter] );

                if(::state.AT.ENABLED)
                {
                    Chat(TextColor.Award + "Bot " +(counter+1)+ " was given: " + ::state.bots_loadout[counter]);
                }
            }
            catch(e)
            {
                printl("[AT][Error] \n" + e);
                return;
            }
            counter++;
        }
    }
    catch(e)
    {
        printl("[AT][Error] \n" + e);
    }
}
// Reset all admin tool commands
::ResetAdminTools<-function()
{
    Chat("Resetting Admin Tools...");
    ::ResetBotWeapons();
    ::ResetDifficulty();
    ::ResetHspread();
    ::ResetZCorrection();
    ::ResetPlayerHealth();
}
// Reset player health to playable defualt
::ResetPlayerHealth<-function()
{
    ::player.SetHealth(::PLAYER_STARTING_HEALTH);
}
// Set bot weapons to playable default
::ResetBotWeapons<-function()
{
    ::state.bots_loadout = ::DEFAULT_BOT_EQUIPMENT;
    ::GiveBotsWeapons();
}
