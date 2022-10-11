
const MENU_PLAYER_INFO_MSG = "HooXi";
const MENU_TARGET_INFO_MSG = "Score Breakdown";
const MENU_TARGET_MUTE_MSG = "Casters Sound";
const MENU_TARGET_BACK_MSG = "Back to Summary";
const MENU_TARGET_COMPANY_MSG = "Visit Ludeo Platform";
::TARGETS <- 
[
	//# Intro
	{ent = Entities.FindByName(null, "menu_target_player"), txt = MENU_PLAYER_INFO_MSG},
	{ent = Entities.FindByName(null, "menu_target_edge"), txt = MENU_TARGET_COMPANY_MSG},
	{ent = Entities.FindByName(null, "menu_target_player_event"), txt = MENU_PLAYER_INFO_MSG},
	{ent = Entities.FindByName(null, "menu_target_edge_event"), txt = MENU_TARGET_COMPANY_MSG},
	//# Summary + Score Table
	{ent = Entities.FindByName(null, "menu_target_edge_2"), txt = MENU_TARGET_COMPANY_MSG},	
	{ent = Entities.FindByName(null, "menu_target_mute"), txt = MENU_TARGET_MUTE_MSG},	
	{ent = Entities.FindByName(null, "menu_target_switch"), txt = ""},	
]
::IgnoreMenuLookThink <- false;
//think function to display a hudhint based on what the player is looking at


::MenuLookThink<-function()
{
	// ::LookingAtBot();
	// ::player = ToExtendedPlayer(VS.GetPlayerByIndex(1));
	if (!::player || !::hudHint || ::timerRunning)
	{
		return;
	} 
	local displayTooltip = false;
	foreach(target in ::TARGETS)
	{
		try
		{
			local bLooking;
			local eyePos = ::player.EyePosition();
			local origin = target.ent.GetOrigin();
			local bLooking = false;
			local eyePos = ::player.EyePosition();
			local txt = "";
			local name = target.ent.GetName();
			if ( !VS.TraceLine( eyePos, origin, ::player.self, MASK_SOLID ).DidHit() )
			{
				bLooking = VS.IsLookingAt( eyePos, origin, ::player.EyeForward(), 0.999 )
			}
			if (bLooking)
			{
				displayTooltip = true;
				txt = target.txt;
				if(name == "menu_target_switch")
				{
					if(::state.isScoreTableEnabled)
					{
						txt = MENU_TARGET_BACK_MSG;	 		
					}
					else
					{
						txt = MENU_TARGET_INFO_MSG;
					}
				}	
				::ShowHudHint(txt)
			}
		}
		catch(e)
		{
		}
	}
	if(!displayTooltip && !::IgnoreMenuLookThink)
	{
		::HideHudHint();
	}
}

::HideHudHint<-function()
{
	::IgnoreMenuLookThink = false;
	EntFireByHandle( ::hudHint, "HideHudHint", "", 0, ::player.self );
}
::ShowHudHint<-function(s){
    ::hudHint.__KeyValueFromString("message", s.tostring());
    EntFireByHandle(::hudHint, "ShowHudHint", "", 0.0, ::player.self, ::player.self);
}
::OverrideSetMenuLookThink<-function(msg="", delay = 0)
{
	::IgnoreMenuLookThink = true;
	::ShowHudHint(msg);
	EntFire("@script","runscriptcode","::HideHudHint()",delay);
}