VS.ListenToGameEvent( "player_connect_full", function( event )
{
	::ChangeGameModeToCoopIfNotCorrect()
	EntFire("game_round_end", "EndRound_Draw", 0.01, 0.2);
}, "player_connect_full" );

VS.ListenToGameEvent("item_equip",function(event)
{
	local user = VS.GetPlayerByUserid( event.userid );
	if(::pre_round && ::player && user == ::player.self)
	{
		::lastPlayerWeaponType = event.weptype;
	}
},"item_equip");


VS.ListenToGameEvent( "player_team", function( event )
{
    if(event.team == 3)
	{
		if (!::state.exists("firstBotWave"))
		{
			::state.firstBotsWave <- true;
		}
        ::ChangeGameModeToCoopIfNotCorrect()
		if (::state.firstBotsWave)
		{
			::state.firstBotsWave = false;
			::SetBotSpawnsStatus(true);
			EntFire("@script", "runscriptcode", "::SpawnFirstBots()", 0.5);
		}
    }
}, "player_team" );

/*
* Event listener for weapon shots
*/
VS.ListenToGameEvent("weapon_fire",function(event)
{

}, "weapon_fire");

/*
 * Event listener to catch the chat command !r in order to force restart the round.
 */
VS.ListenToGameEvent( "player_say", function( event )
{
	local ply = VS.GetPlayerByUserid( event.userid );
    local s = event.text.tolower()
    if (s == "!r")
	{
		if(::timerRunning || ::pre_round)
		{
      		::RestartRound();
		}
    }
	else
	{
		::ProcessChat(event)
	}
}, "player_say" );


/*
* Bot / Player damage listener
*/
VS.ListenToGameEvent( "player_hurt", function( event )
{
	if(!::timerRunning)
	{
		::player.SetHealth(::PLAYER_STARTING_HEALTH);
		return;
	}
	local victim = VS.GetPlayerByUserid( event.userid );
	local attacker = VS.GetPlayerByUserid( event.attacker );
	local botid = split(split(victim.tostring(),"]")[0],"[")[1].tointeger()-1;
	try // Release bot if damaged
	{
		if(::released[botid-1]) return;
		if(!::FLAGS.botsDamaged[botid-1])
		{
			::ReleaseBotClip(botid);
			::FLAGS.botsDamaged[botid-1] = 1;
		}
		::SetTargetInfoOnPlayer(botid);
	}
	catch(e){printl(e)}
}, "player_hurt" );

/*
* Bot / Player death event listener
*/
VS.ListenToGameEvent( "player_death", function( event )
{
	local victim = VS.GetPlayerByUserid( event.userid );
    local attacker = VS.GetPlayerByUserid( event.attacker );

	if(!::timerRunning)
	{
		//# Player suicide before round begins
		if(::pre_round && ::player && attacker == victim && victim == ::player.self) 
		{
			::RestartRound();
		}
		return;
	}
	
    if (::player && ::player.self == victim) //Bot killed player
	{
        ::OnPlayerDeath();
		return;
    }

	local didBotSuicide = ::player && attacker == victim && victim !=  ::player.self;
	::COUNTERS.bots_dead++;
    if (::player && ::player.self == attacker || didBotSuicide) //# Player killed bot
	{
		try
		{
			local botid = split(split(victim.tostring(),"]")[0],"[")[1].tointeger()-1;
			FLAGS.botsDied[botid-1] = 1;
		
			if(event.headshot)
			{
				::COUNTERS.headShoots++;
			}
			if(event.noscope)
			{
				::COUNTERS.noscope++;
			}
		}
		catch(e)
		{
			printl("-----------------------> CATCH + " + e);
		}
	}
	
    if (::player && attacker == victim && victim == ::player.self) //# Player suicide, ignore death by bomb
	{
		::OnPlayerDeath();
    }

	if (::COUNTERS.bots_dead >= ::BOTS_KILL_QUOTA)
	{
		::COUNTERS.health = ::player.GetHealth();
		::EndRound();
	}	
}, "player_death" );
