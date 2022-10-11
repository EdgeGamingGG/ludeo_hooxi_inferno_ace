::hud_timer <- null;
::event_timer <- null;
::lastPlayerWeaponType <- 0;
/*
* Force player to use a specific weapon slot
*/
::SwitchToWeaponSlot<-function(slotNumber = 1) 
{
	if (::player)
	{
        local slot = "slot"+slotNumber;
		::player = ToExtendedPlayer(VS.GetPlayerByIndex(1));
		EntFire( "@clientcommand", "Command", slot, 0.0, ::player.self );
	}
}

/*
* Removes all equipment from player and gives them a new set
* Includes weapons, grenades, armor, etc..
*/
::SetPlayerEquipment<-function()
{
    local equipper = Entities.CreateByClassname("game_player_equip");
    equipper.__KeyValueFromInt("spawnflags", 3);
      if (::PLAYER_EQUIPMENT.len() > 0){
        foreach (item in ::PLAYER_EQUIPMENT){
	        equipper.__KeyValueFromInt(item[0], item[1])
        }
    }
    local player = null
	while ( player = Entities.FindByClassname(player, "player") ){
        EntFireByHandle( equipper, "Use", "", 0, player, null );
    }
    // EntFireByHandle( equipper, "Kill", "", 1, null, null );
}


/*
* Create a game_text entity, used as a round timer
*/
::SetHUDTimer<-function()
{
    ::hud_timer = Entities.FindByName(null,"hud_timer");
    if(hud_timer==null)
    {
        ::hud_timer = Entities.CreateByClassname("game_text");
        ::hud_timer.__KeyValueFromInt( "spawnflags",0);
        ::hud_timer.__KeyValueFromString("targetname", "hud_timer");
        ::hud_timer.__KeyValueFromInt( "x", -1);
        ::hud_timer.__KeyValueFromFloat( "y", 0.9);
        ::hud_timer.__KeyValueFromInt( "holdtime", 5);
        ::hud_timer.__KeyValueFromInt( "effect", 0);
        ::hud_timer.__KeyValueFromString( "color", "244 244 244");
        ::hud_timer.__KeyValueFromString( "color2", "244 244 244");
        ::hud_timer.ValidateScriptScope();
    }

}


/*
* Create a game_text entity, used as event timer
*/
::SetEventTimer<-function()
{
    ::event_timer = Entities.FindByName(null,"hud_event_time");
    if(::event_timer==null)
    {
        ::event_timer= Entities.CreateByClassname("game_text");
        ::event_timer.__KeyValueFromInt( "spawnflags",0);
        ::event_timer.__KeyValueFromInt( "channel",1);
        ::event_timer.__KeyValueFromString("targetname", "hud_event_time");
        ::event_timer.__KeyValueFromInt( "x", 0.1);
        ::event_timer.__KeyValueFromFloat( "y", 0.0);
        ::event_timer.__KeyValueFromInt( "holdtime", 5);
        ::event_timer.__KeyValueFromInt( "effect", 0);
        ::event_timer.__KeyValueFromString( "color", "244 244 244");
        ::event_timer.__KeyValueFromString( "color2", "244 244 244");
        ::event_timer.ValidateScriptScope();
    }
}

::GivePlayerHEGrenade<-function()
{
    local equipper = Entities.CreateByClassname("game_player_equip");
    equipper.__KeyValueFromInt("spawnflags", 5);
    equipper.__KeyValueFromInt("weapon_hegrenade", 1);
    local player = null
	while ( player = Entities.FindByClassname(player, "player") ){
        EntFireByHandle( equipper, "Use", "", 0, player, null );
    }
    local wepSlot = ::GetWeaponSlotByType(::lastPlayerWeaponType);
    if(!::lastPlayerWeaponType)
    {
        ::SwitchToWeaponSlot(wepSlot);
    }
    EntFireByHandle( equipper, "Kill", "", 1, null, null );
}

/*
* Returns weapon slot by weapon type
*/
::GetWeaponSlotByType<-function(weptype)
{
    if(!weptype || weptype < 0 || weptype > 9 || weptype == 8) return 3;
    switch(weptype)
    {
        case 1: return 2;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6: return 1;
        case 7: return 5;
        case 9: return 4;
    }
}



