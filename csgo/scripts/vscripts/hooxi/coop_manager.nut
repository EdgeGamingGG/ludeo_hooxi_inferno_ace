/*
* Init the game
*/
::CoopInit<-function()
{
	::ChangeGameModeToCoopIfNotCorrect();
	
	ScriptCoopSetBotQuotaAndRefreshSpawns( 0 );
	
	ScriptCoopResetRoundStartTime();
	// Reset the difficulty to normal at start of the round
        ServerCommand("mp_bot_ai_bt \"\"")
        ServerCommand("mp_bot_ai_bt_clear_cache")
        ServerCommand("sv_infinite_ammo 0")
        ServerCommand("sv_hide_roundtime_until_seconds 1")
        ServerCommand("sv_highlight_duration 0")
        ServerCommand("mp_coopmission_bot_difficulty_offset 0")
        ServerCommand("mp_death_drop_gun 0")
        ServerCommand("mp_buy_allow_guns 0")
        ServerCommand("mp_warmuptime 0")
        ServerCommand("mp_freezetime 0")
        ServerCommand("mp_roundtime 60")
        ServerCommand("mp_timelimit 0")
        ServerCommand("mp_weapons_allow_heavy 0")
        ServerCommand("mp_match_restart_delay 1")
        ServerCommand("mp_match_end_changelevel 0")
        ServerCommand("mp_match_end_restart 1")
        ServerCommand("mp_ignore_round_win_conditions 1")       
        ServerCommand("mp_warmuptime_all_players_connected 0")
        ServerCommand("mp_respawn_on_death_t 1")
        ServerCommand("mp_maxrounds 9999")
        ServerCommand("mp_round_restart_delay 2")
        ServerCommand("mp_humanteam CT")
        ServerCommand("mp_do_warmup_period 0")
        ServerCommand("mp_teamcashawards 0")
        ServerCommand("mp_playercashawards 0")
        ServerCommand("mp_suicide_penalty 0")
        ServerCommand("mp_respawn_immunitytime -1")
        ServerCommand("mp_warmup_end")
        ServerCommand("bot_chatter OFF")
        ServerCommand("bot_coop_idle_max_vision_distance 5000")
        ServerCommand("mp_anyone_can_pickup_c4 1")
        ServerCommand("mp_death_drop_c4 0")
        ServerCommand("mp_c4_cannot_be_defused 1");
        ServerCommand("mp_weapons_allow_heavyassaultsuit 1")
	::player = ToExtendedPlayer(VS.GetPlayerByIndex(1));

}
::ServerCommand<-function(s,d=0.0){ EntFire("@servercommand", "Command", s, d, null) }
::ClientCommand<-function(s,d=0.0){ EntFire("@clientcommand", "Command", s, d, null) }

/*
* If the gamemode is not Coop, restart the game in coop
*/
::ChangeGameModeToCoopIfNotCorrect<-function()
{
	// This will change the game mode and game type if the player has not initialized this before starting the map.
        local game_mode = ScriptGetGameMode();
        local game_type = ScriptGetGameType();
        local map = GetMapName();

	if (game_mode != 1 || game_type != 4)
	{
		SendToConsole("game_mode 1; game_type 4; changelevel " + map);
                SendToConsoleServer("game_mode 1; game_type 4; changelevel " + map);
	}
}