
::ResetSummaryBoard<-function()
{
	::state.CONST_TIME  = 0;
	::state.CONST_NOSCOPE =  0;
	::state.CONST_HEADSHOTS = 0;
	::state.CONST_HP = 0;
	::state.CONST_SCORE = 0;
	::SetDisplayText("menu_score_time", 0);
	::SetDisplayText("menu_score_noscope",0);
	::SetDisplayText("menu_score_hs", 0);
  	::SetDisplayText("menu_score_hp", 0);
}
/*
 * Calculates the player score
 */
::CalculateScore<-function(win = true)
{
	::state.CONST_TIME  = ::TIMERS.secondsPassed;
	::state.CONST_HEADSHOTS = ::COUNTERS.headShoots;
	::state.CONST_NOSCOPE =  ::COUNTERS.noscope;
	::state.CONST_HP = ::COUNTERS.health;
	::state.CONST_SCORE =
		((::ROUND_TIME - ::TIMERS.secondsPassed) * ::TIME_SCORE) +
		(::COUNTERS.headShoots * ::HEADSHOOTS_SCORE) +
		(::COUNTERS.noscope * ::NOSCOPE_SCORE) +
		(::COUNTERS.health * ::HP_SCORE);

	if(::state.valid_challenge_round)
	{
		::state.CONST_DIFF = ::SERVER_DATA.challenge_difficulty;
		::state.CONST_SCORE *= ::SERVER_DATA.challenge_difficulty;
	}
	else
	{
		::state.CONST_DIFF = ::state.playable_difficulty;
		::state.CONST_SCORE *= ::state.CONST_DIFF;
	}
	::state.CONST_SCORE = floor(::state.CONST_SCORE);
	try
	{
		if(win && ::state.CONST_SCORE > ::state.SERVER_DATA.user_info.max_score)
		{
			::state.SERVER_DATA.user_info.max_score = ::state.CONST_SCORE;
		}
	}
	catch(e){}
	if(!win)
	{
		::state.CONST_SCORE = 0;
	}
	
	local diffStr =  ::GetDifficultyNameByNumber(::state.CONST_DIFF);
	Chat("\n"); 	
	Chat(::SCORE_TIME_CHAT_MSG + ::state.CONST_TIME);
	Chat(::SCORE_NOSCOPE_CHAT_MSG + ::state.CONST_NOSCOPE);
	Chat(::SCORE_HEADSHOTS_CHAT_MSG + ::state.CONST_HEADSHOTS);
	Chat(::SCORE_HP_CHAT_MSG + ::state.CONST_HP); 
	Chat(::SCORE_DIFFICULTY_CHAT_MSG + diffStr);
	Chat(::SCORE_TOTAL_SCORE_CHAT_MSG + ::state.CONST_SCORE);
	try
	{
		if(::state.valid_challenge_round)
		{
			Chat(::SCORE_HIGHEST_SCORE_CHAT_MSG + ::state.SERVER_DATA.user_info.max_score)
		}
	}
	catch(e){}
	::UpdateMenuScores();
}



// Set menu scores at the beginning of the round (display only)
::SetPersonalMenuScores<-function()
{
	if(!::state.exists("CONST_TIME"))
	{
		::state.CONST_TIME = 0;
	}
	local _timeString = ::state.CONST_TIME;
	if(!::state.CONST_TIME)
	{
		_timeString = "0.00";
	}
	local diffStr = "x" + ::state.CONST_DIFF;
	try
	{
		if(::state.SERVER_DATA.challenge_id)
		{
			diffStr = "x" + ::state.SERVER_DATA.challenge_difficulty;
		}
	}	
	catch(e)
	{

	}
	::SetDisplayText("score_row_1", _timeString);
	::SetDisplayText("score_row_2", ::state.exists("CONST_NOSCOPE") ? ::state.CONST_NOSCOPE : 0);
	::SetDisplayText("score_row_3", ::state.exists("CONST_HEADSHOTS") ? ::state.CONST_HEADSHOTS : 0);
	::SetDisplayText("score_row_4", ::state.exists("CONST_HP") ? ::state.CONST_HP : 0);
	::SetDisplayText("score_row_5", diffStr);
	::SetDisplayText("score_row_6",::state.exists("CONST_SCORE") ? ::state.CONST_SCORE : 0);
}

// Updates all menu_score_* for the plugin
::UpdateMenuScores<-function()
{
    ::SetDisplayText("menu_score_time",::state.CONST_TIME);
	::SetDisplayText("menu_score_noscope",::state.CONST_NOSCOPE);
	::SetDisplayText("menu_score_hs",::state.CONST_HEADSHOTS);
    ::SetDisplayText("menu_score_hp", ::state.CONST_HP);
    ::SetDisplayText("menu_score_difficulty", ::state.CONST_DIFF);
	::SetDisplayText("menu_score_total",::state.CONST_SCORE);
    EntFire("@script", "runscriptcode", "::CacheScores()", 0.05, null);
}