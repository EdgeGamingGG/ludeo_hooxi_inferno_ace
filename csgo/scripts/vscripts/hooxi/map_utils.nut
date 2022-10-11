::hudHint <- null;
::PlayerTeleportOrigin <- null;

/*
* Removes player ragdolls
*/
::RemoveDeadBodies<-function()
 {
	local ent = null
	while ( ent = Entities.FindByClassname(ent, "cs_ragdoll") ){
		EntFireByHandle(ent, "Kill", "", 0.0, null);
	}
}


/*
* Show a message to the player how to reset the round every two minutes.
* Triggered by logic_timer: timer_send_reset_round_tip
*/
::ShowResetRoundTip<-function() 
{
	Chat(::RESET_ROUND_TIP_MSG);
	Chat(::DIFFICULTY_REMINDER_MSG + ::GetDifficultyColorByNumber(::state.playable_difficulty) + ::GetDifficultyNameByNumber(::state.playable_difficulty));
    EntFire("@script", "runscriptcode", "::ShowResetRoundTip()", ::RESET_ROUND_REMINDER_DELAY, null);
}

::ShowPlatformTip<-function()
{
	Chat(::EDGE_TIP_MSG);
	EntFire("@script", "runscriptcode", "::ShowPlatformTip()", ::EDGE_TIP_MSG_DELAY, null);
}

/*
* Enables the soundeffects if they are disabled, and disables them if they are enabled
*/
::ToggleSoundEffects<-function()
{
	if (::state.SOUND) 
    {
		::state.SOUND = 0; 
		Chat(::SOUND_EFFECTS_OFF_MSG);
	}
	else 
    {
		::state.SOUND = 1;
		Chat(::SOUND_EFFECTS_ON_MSG);
	}
}


::CreateCommands<-function()
{
    local clientCmd = Entities.CreateByClassname("point_clientcommand");
    local serverCmd = Entities.CreateByClassname("point_servercommand");

    clientCmd.__KeyValueFromString("targetname","@clientcommand");
    serverCmd.__KeyValueFromString("targetname","@servercommand");
}

::CreateHudHint<-function()
{
    ::hudHint = Entities.CreateByClassname("env_hudhint");
    ::hudHint.__KeyValueFromString("targetname","@hudhint");
}


::CreateGameRoundEnd<-function()
{
    local roundEnd = Entities.CreateByClassname("game_round_end");
    roundEnd.__KeyValueFromString("targetname","map_round_end");
}

::SetTimerColor<-function(colorString)
{
	if(!::hud_timer || !::player)
	{
		return;
	}
	EntFireByHandle( ::hud_timer, "SetTextColor", colorString, 0.0, ::player.self );	
}


::SetTimerText<-function(txt)
{
	if(!::hud_timer || !::player)
	{
		return;
	}
	EntFireByHandle( ::hud_timer, "SetText", txt.tostring(), 0.0, ::player.self );			
	EntFireByHandle( ::hud_timer, "Display", "", 0.0, ::player.self );
}


::CreatePlayerSpawn<-function()
{
    local tp = Entities.CreateByClassname("info_teleport_destination");
    tp.__KeyValueFromString("targetname", "map_home_tele_dest");
	::PlayerTeleportOrigin = Entities.FindByName(null,"player_spawn").GetOrigin();
    tp.SetOrigin(::PlayerTeleportOrigin);
	tp.__KeyValueFromString("angles","0 168 0");
}


// function activates SetDisplayText for a given menu_score_* entity
::SetDisplayText<-function(menu, value)
{
    EntFire(menu, "SetDisplayText", value.tostring());
}

::SetStartClipStatus<-function(status)
{
    local _status = status ? "Enable" : "Disable";
    EntFire("menu_panel_clip",_status);
}
