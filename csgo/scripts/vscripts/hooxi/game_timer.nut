if(!::state.exists("challenge_chat_reminder_counter"))
{
    ::state.challenge_chat_reminder_counter <- 0;
}
::didPlayReminderAudio <- false;
::didRoundStart <- false;
/*
* Update the round time
* Trigger by logic_timer timer_roundtime
*/
::TimerRun<-function()
{
	if( ::timerRunning )
	{
		::TIMERS.secondsPassed = ::Utils.Round(Time()-::TIMERS.roundStart,2);
		
		local time_left = ::Utils.Round((::ROUND_TIME - ::TIMERS.secondsPassed),1);
		if (::player && ::player.self && time_left <= ::ROUND_TIME && time_left >= 0) {
			if (time_left <= ::TIME_RUNNING_OUT_THRESHOLD)
			{			
				if(!::didPlayReminderAudio)
				{
					::didPlayReminderAudio = true;
					::player.EmitSound(::TIMER_HURRY_UP_SOUND);				
				}
				::SetTimerColor("255 0 0");
			} 
			else
			{
				::SetTimerColor("255 255 255");			
			}
		
			::SetTimerText(time_left);

			if(time_left <= 0.1)
			{
				::TIMERS.secondsPassed = ::ROUND_TIME;
				::SetTimerText("0.0");
				::OnPlayerDeath();
			}
		}
		EntFire("@script", "runscriptcode", "::TimerRun()", 0.1 , null);
	}
}


/*
* Update the round time
* Trigger by logic_timer timer_roundtime
*/
::EventTimer<-function()
{
	if(!::state.SERVER_DATA || !::state.SERVER_DATA.challenge_id) return;
	local timePassed = Time();
	local time_left = ::Utils.Round((::state.SERVER_DATA.ends_in_seconds - timePassed),1);
	if (::player && ::player.self ) 
	{
		if(time_left <= ::state.SERVER_DATA.ends_in_seconds && time_left >= 0)
		{
			if(!::timerRunning && time_left <= ::MIN_EVENT_TIME_LEFT_IN_SEOCNDS)
			{
				EntFireByHandle(::event_timer,"SetText",::EVENT_HUD_TEXT_1_MSG + "\n" + ::Utils.GetTimeValues(time_left) ,0.0,::player.self);
				EntFireByHandle( ::event_timer, "Display", "", 0.0, ::player.self );

				if(!::state.challenge_chat_reminder_counter && time_left > ::EVENT_END_REMINDER_DELAY_1)
				{
					::state.challenge_chat_reminder_counter++;
				}
				if(::state.challenge_chat_reminder_counter == 1 )
				{
					if(time_left <= ::EVENT_END_REMINDER_DELAY_1)
					{
						::state.challenge_chat_reminder_counter++;
						Chat(EVENT_END_REMINDER_MSG);
					}
				}
				else if(::state.challenge_chat_reminder_counter == 2 && time_left <= ::EVENT_END_REMINDER_DELAY_2)
				{
					::state.challenge_chat_reminder_counter++;
					Chat(EVENT_END_REMINDER_MSG);
				}
			}
			else
			{
				if(!::didRoundStart)
				{
					::didRoundStart = true;
					EntFireByHandle( ::event_timer, "SetText", "", 0.0, ::player.self );	
					EntFireByHandle( ::event_timer, "Display", "", 0.0, ::player.self );
				}
			}
		}
		else
		{
			if(::state.SERVER_DATA.challenge_id)
			{
				EntFireByHandle( ::event_timer, "SetText", "", 0.0, ::player.self );	
				EntFireByHandle( ::event_timer, "Display", "", 0.0, ::player.self );
				::OnEventEnd();
				return;	
			}
		
		}
		EntFire("@script", "runscriptcode", "::EventTimer()", 0.1 , null);	
	}
}