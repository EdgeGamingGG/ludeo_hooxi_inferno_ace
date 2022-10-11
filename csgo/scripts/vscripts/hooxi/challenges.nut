//# Globals
if(!::state.exists("challenge_id"))
{
    ::state.challenge_id <- 0;
}
if(!::state.exists("SERVER_DATA"))
{
    ::state.SERVER_DATA <- 
    {
        challenge_id = 0,
    };
}
if(!::state.exists("valid_challenge_round"))
{
    ::state.valid_challenge_round <- 0;
}
if(!::state.exists("event_chat_welcome"))
{
    ::state.event_chat_welcome <- 1;
}
if(!::state.exists("SERVER_DATA_INITIALIZED"))
{
    ::state.SERVER_DATA_INITIALIZED <- false;
}
::PLAYABLE_NAME <- "ludeo_hooxi_inferno_ace.nut";
::MIN_EVENT_TIME_LEFT_IN_SEOCNDS <- 1800 // seconds

/*
* Include server data file
*/
::GetServerData<-function()
{
    printl("[Ludeo] - Fetch Server Data");
  
    if(::state.SERVER_DATA_INITIALIZED)
    {
       printl("[Ludeo] - Server data already fetched")
       return;
    }
 
     // Fake server data.
    // ::SERVER_DATA <-
    // {
    //    challenge_difficulty = 2,
    //    challenge_id = 10,
    //    ends_in_seconds = 20,
    //    user_info = { name = "aaddccc", max_score = 410 }
    // }
    // Get server data.
    try
    {
       IncludeScript(::PLAYABLE_NAME,null);
    }
    catch(e){printl("[Ludeo] - Error - " + e); return;}



    ::InitializeServerData();
}
/*
* Integrate data from server into the playable 
*/
::InitializeServerData<-function()
{
    printl("[Ludeo] - Initializing server data")
    ::state.SERVER_DATA = ::SERVER_DATA;
    if(::state.SERVER_DATA.challenge_id)
    {
        ::state.SCREENS.intro = 0;
        ::state.SERVER_DATA_INITIALIZED = true;
        ::state.challenge_id = ::state.SERVER_DATA.challenge_id;
        if(::state.SERVER_DATA.user_info.max_score)
        {
            ::state.SCREENS.new_score = 2;
        }
        if(::state.SERVER_DATA.challenge_difficulty) 
        {
            ::state.playable_difficulty = ::state.SERVER_DATA.challenge_difficulty;
        }
    }
}

/*
* Handles end of event. Triggered by event timer
*/
::OnEventEnd<-function()
{
    Chat(::EVENT_END_MSG);
    EntFire("trigger_roundstart","disable");
    ::HideEventIntroMenu();
    ::state.playable_difficulty = DEFAULT_PLAYABLE_DIFFICULTY
    ::state.SERVER_DATA.ends_in_seconds = 0;
    ::state.SCREENS.event_end = 1;
    ::state.SCREENS.event_intro = 0;
    ::state.ignore_difficulty_popup = false;
    ::state.isScoreTableEnabled = false;
    ::state.consecutiveLosses = 0;
    if(::state.SERVER_DATA.challenge_id)
    {
        ::state.SERVER_DATA.challenge_id = 0;
        if(::pre_round) // Restart round immediately if event ended and start line hasn't been crossed yet
        {
            EntFire("game_round_end", "EndRound_Draw", 0.01, 0.2);
            ::SetStartClipStatus(true);
        }
    }
}
/*
* Returns playable to regular state and ends all event screens
* Triggered by event end popup
*/
::OnButtonEndEvent<-function()
{
    ::Event_EndScreenClicked();
    ::HideEventEndPopup();
    ::state.SCREENS.event_end = 0;
    ::state.SCREENS.intro = 0;
    EntFire("game_round_end", "EndRound_Draw", 0.01, 0.2);
}

