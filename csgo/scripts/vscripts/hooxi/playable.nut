/*
* Variables
*/
::player <- null;
::timerRunning <- 0;
::pre_round <- false;
if(!::state.exists("consecutiveLosses"))
{
	::state.consecutiveLosses <- 0;
}

::TIMERS  <- 
{
	roundStart = 0,
	secondsPassed = 0,
	secondsPassedPlant = 0,
}

//# Playable Variables

::COUNTERS <-
{
	headShoots = 0,
	health = 0,
	bots_dead = 0,
	killTimeStamps = [],
	killtime = 0,
}

::FLAGS <-
{
	playerWon = false
	botsDamaged = [0,0,0,0,0]
	botsDied = [0,0,0,0,0]
}
// 1 - available
// - unavailable
if(!::state.exists("SCREENS"))
{
	::state.SCREENS <- 
	{
		intro = 1,
		event_intro = 1,
		event_end = 0,
		new_score = 0
	}
}
if(!::state.exists("precached_sound"))
{
	::state.precached_sound <- false;
}
if(!::state.exists("loaded"))
{
	::state.loaded <- false;
}
/*
* Init the script
*/
::InitializeScript<-function()
{
	printl("[Ludeo] - Initializing script.. ");
	EntFire("@script","runscriptcode","::GetServerData()");
	::CreateGameRoundEnd();
	::CoopInit();
	::CreatePlayerSpawn();
	::CreateHudHint();
	::CreateCommands();
	PrecacheScriptSound(::TIMER_HURRY_UP_SOUND);
	if(!::state.precached_sound )
	{
		::state.precached_sound = true;
		PrecacheScriptSound(::WIN_SOUND);
		PrecacheScriptSound(::PARTY_HORN);
	}
	::SetHUDTimer();
	::SetEventTimer();
	EntFire("@script", "runscriptcode", "::ShowPlatformTip()", ::EDGE_TIP_MSG_DELAY_SPAWN , null);
	EntFire("@script", "runscriptcode", "::ShowResetRoundTip()",  ::RESET_ROUND_REMINDER_DELAY, null);
}


/*
* Restart the round after player's reset or suicide pre-start
*/
::RestartRound<-function()
{
	printl("[Ludeo] - Restart Round");
	::timerRunning = 0;
	::ResetSummaryBoard();
	Chat(::RESTARTING_ROUND_MSG);
	EntFire("game_round_end", "EndRound_Draw", ::RESET_ROUND_DELAY);
}

::SetDoorSpeed<-function(door,speed)
{
	local introMenu = Entities.FindByName(null, door);
	introMenu.__KeyValueFromInt("speed", speed);
}

/**
* Function executed on script initialize
* Handles everything pre-player interaction with the playable such as score text or magic ropes
*/
::PrepareRound<-function()
{
	::pre_round = true;
	::EventTimer()
	::SetStartClipStatus(true);
	EntFire("trigger_spawn","Disable");
	SendToConsoleBoth("sv_infinite_ammo 1");
	try{::player.self.SetAngles(0,270,0);} catch(e){};
	//# Intro Screens

	::SetBotSpawnsStatus(true);
    EntFire("@script", "runscriptcode", "::SpawnWave(::BOTS_KILL_QUOTA)", 0.1 , null);
    ::SetBotSpawnsStatus(false,2);

	if(::state.CONST_DIFF_RESET)
    {
		::state.CONST_DIFF_RESET = 0;
        ::ShowTooltip();
    }
	
	if(::state.SERVER_DATA && ::state.SERVER_DATA.challenge_id)
	{
		::SetDisplayText("menu_challenge_id", ::state.challenge_id);
		::HideSummaryMenu();
		::state.consecutiveLosses = 0;
		if(::state.event_chat_welcome)
		{
			Chat(::EVENT_START_MSG);
			::state.event_chat_welcome = 0;
		}
		if(::state.SCREENS.event_intro)
		{
			//::SwitchToWeaponSlot(2);
			::ShowEventIntroMenu(::state.playable_difficulty);
			::ShowScoreMenu();
		}		
		else if(::state.SCREENS.new_score == 1) // event ended screen is up
		{
			::state.SCREENS.new_score = 2;
			::ShowNewScorePopup();
			::state.isScoreTableEnabled ? ::ShowScoreMenu() : ::ShowEventSummaryMenu(::state.playable_difficulty);
		}
		else if(::state.SCREENS.event_end)
		{
			::state.isScoreTableEnabled ? ::ShowScoreMenu() : ::ShowSummaryMenu(::state.playable_difficulty);
		}
		else
		{
			::SetStartClipStatus(false);
			::state.isScoreTableEnabled ? ::ShowScoreMenu() : ::ShowEventSummaryMenu(::state.playable_difficulty);
		}
	}
	else
	{
		if(::state.SCREENS.intro) // first time playing
		{
			//::SwitchToWeaponSlot(2);
			::ShowIntroMenu(::state.playable_difficulty);
			::ShowScoreMenu();
		}
		else
		{
			::HideEventSummaryMenu();
			::state.isScoreTableEnabled ? ::ShowScoreMenu() : ::ShowSummaryMenu(::state.playable_difficulty);
			 if(::state.SCREENS.new_score == 1)
			{
				::state.SCREENS.new_score = 2;
				::ShowNewScorePopup();
			}
			else if(::state.SCREENS.event_end)
			{
				::ShowEventEndPopup();
			}
			else if(!::state.ignore_difficulty_popup && ::state.consecutiveLosses >= ::DIFFICULTY_CONSECUTIVE_LOSSES)
			{
				::ShowDifficultyPopup(::state.playable_difficulty);
			}
			else // (End Of popups, always be last)
			{
				::HideDifficultyPopup();
				::SetStartClipStatus(false);
			}
		}
	}
	//# Events
	if(!::state.loaded)
	{
	    ::Event_PlayableLoading();
	}

	::SetPlayerEquipment();
	::SetPersonalMenuScores();
	::GiveBotsWeapons();


	//# Admin Tools
	// if(::state.custom_difficulty[0]>0)
	// {
	// 	::SetEnemySpawnDifficulties(::state.custom_difficulty);
	// }
	// else
	// {
	::SetEnemySpawnDifficulties(::DIFFICULTY_ARRAYS[::state.playable_difficulty-1]);
	// }

}

/*
* Starts the round with a new timer etc
*/
::StartRound<-function()
{
	if(!::timerRunning && ::pre_round)
	{
		printl("[Ludeo] - Start Round");
		if(::GetBotsAlive()<::BOTS_KILL_QUOTA)
        {
            printl("[Ludeo] - Invalid round!");
            ::timerRunning = 0;
            ::RestartRound();
        }	
		try
		{
			if(::state.SERVER_DATA.challenge_id)
			{
				::state.valid_challenge_round = 1;
			} 
			else
			{
				::state.valid_challenge_round = 0;
			}
		}
		catch(e){printl("------------ > " + e); ::state.valid_challenge_round = 0;}
		::SetBotOnSpawn();
		::TriggerBotClips();
		::state.isScoreTableEnabled = false;
		SendToConsoleBoth("sv_infinite_ammo 0");
		::pre_round = false;
		EntFire("menu_button_*","Lock");
		EntFire("summary_difficulty_button_*","lock");
		::TIMERS.roundStart = Time();
		::TIMERS.secondsPassed = 0;
		::state.CONST_SCORE = 0;
		::timerRunning = 1;
		::StartBotFacer();
		//::GivePlayerHEGrenade();
		EntFire("@script", "runscriptcode", "::TimerRun()", 0 , null);
		activator.EmitSound(::TIMER_START_SOUND);	
		EntFire("@script", "runscriptcode", "::Event_StartRound()", 0, null);

		EntFire("@script","runscriptcode","::HuntPlayerInfoTarget()",4);
	}

}

::ClearRound<-function()
{
	return;
	printl("[Ludeo] - Clear Round");
	::RemoveDeadBodies();
	EntFire("@clientcommand", "Command", "r_cleardecals"); 
}
/*
* Function to finish the round
*/
::EndRound<-function() 
{
	printl("[Ludeo] - End Round");
	::state.ignore_difficulty_popup = true;
	::timerRunning = 0;
	::state.consecutiveLosses = 0;
	// if(::state.SOUND)
	// {
	// 	local ent = null;
	// 	while ( ent = Entities.FindByClassname(ent, "player") )
	// 	{
	// 		ent.EmitSound(::WIN_SOUND);
	// 	}
	// }
	if(!::state.SCREENS.new_score)
	{
		::state.SCREENS.new_score = 1;
	}
	::CalculateScore();
	EntFire("menu_relay_postgame", "Trigger", 0);
	EntFire("game_round_end", "EndRound_Draw", 0.01, ::ROUND_END_DELAY + 1);
}

/**
* Function handles all post-player death triggers and resets
*/
::OnPlayerDeath<-function()
{
	if(!::timerRunning)
	{
		return;
	}
	::state.consecutiveLosses++;
	::timerRunning = 0;
	::state.CONST_SCORE = 0;
	::CalculateScore(false);
	::ClearRound();
	EntFire("game_round_end", "EndRound_TerroristsWin", ::ROUND_END_DELAY);	
}

::SetBotOnSpawn<-function()
{
        local bot;
        while (bot = Entities.FindByClassname(bot, "cs_bot")) 
        {       
            if (bot != null)
            {       
                try
                {
                    local botid = split(split(bot.tostring(),"]")[0],"[")[1].tointeger();
                    if(botid<2) continue;
                    botid-=1;
					EntFire("@script","runscriptcode","::TeleportBotPosition("+botid+")",botTimes[botid-1]);
                }
                catch(e)
                {
                    printl(e);
                }
            }
        }
}

::TeleportBotPosition<-function(botid)
{
	local bot;
	while (bot = Entities.FindByClassname(bot, "cs_bot")) 
	{       
	    if (bot != null)
	    {       
	        try
	        {
	            local currantbotid = split(split(bot.tostring(),"]")[0],"[")[1].tointeger();
	            if(currantbotid<2) continue;
	            currantbotid-=1;
				if(currantbotid == botid)
				{
					local dest = Entities.FindByName(null,"bot_"+botid+"_spawn");
					bot.SetOrigin(dest.GetOrigin());
					break;
				}
	        }
	        catch(e)
	        {
	            printl(e);
	        }
	    }
	}
}
