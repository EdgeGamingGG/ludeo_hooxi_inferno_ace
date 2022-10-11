if(!::state.exists("isScoreTableEnabled"))
{
    ::state.isScoreTableEnabled <- true;
}
::SwitchMenus<-function()
{
    if(::state.isScoreTableEnabled)
    {
        if(::state.SERVER_DATA && ::state.SERVER_DATA.challenge_id)
        {
            ::ShowEventSummaryMenu(::state.playable_difficulty);
        }
        else
        {
            ::ShowSummaryMenu(::state.playable_difficulty);
        }
    }
    else
    {
        ::ShowScoreMenu();
    }
}
//############ Intro
::ShowIntroMenu<-function(diff=null)
{
	::SetDoorSpeed("menu_panel_home",20000);
    EntFire("menu_panel_home", "Close");
     EntFire("intro_difficulty_button_*", "unlock");
    ::ShowScoreMenu();
    EntFire("@script","runscriptcode","::SetDoorSpeed(\"menu_panel_home\",350)",1);
    ::SetIntroDifficulty(diff);
}
::HideIntroMenu<-function()
{
    ::Event_StartButton();
    EntFire("menu_panel_home", "Open");
    EntFire("menu_ag_click", "PlaySound");
    ::state.FIRST_START = 0;
    ::state.SCREENS.intro = 0;
    ::state.showDiffMenu.start = 0;
    ::SetStartClipStatus(false);
    EntFire("intro_difficulty_button_*", "Disable");
    EntFire("intro_difficulty_*", "Disable");
}

::ShowEventIntroMenu<-function(diff)
{
    if(diff && ::IsPopupValid("event_intro"))
    {
        ::Event_IntroScreenViewed();
        ::state.ignore_difficulty_popup = true;
        ::SetDoorSpeed("menu_panel_event",20000);
        EntFire("intro_difficulty_button_*", "lock");
        EntFire("menu_panel_event", "Close");
        EntFire("@script","runscriptcode","::SetDoorSpeed(\"menu_panel_event\",350)",1);
       ::SetEventIntroDifficulty(diff);
    }
}
::OnStartEventButton<-function()
{
    ::Event_IntroScreenClicked();
    ::SetStartClipStatus(false);
    ::HideEventIntroMenu();
}
::HideEventIntroMenu<-function()
{
    EntFire("event_intro_difficulty_*", "Disable");
    EntFire("menu_panel_event", "Open");
    ::state.SCREENS.event_intro = 0;
}

::ShowScoreMenu<-function()
{
    ::HideSummaryMenu();
    ::HideEventSummaryMenu();
    EntFire("menu_panel_scoretable","Enable");
    ::state.isScoreTableEnabled = true;
}
::HideScoreMenu<-function()
{
    EntFire("menu_panel_scoretable","Disable");
    ::state.isScoreTableEnabled = false;
}
::ShowSummaryMenu<-function(diff=null)
{
    ::HideScoreMenu();
    EntFire("menu_ag_click","PlaySound");
    EntFire("summary_difficulty_button_*","Enable");
    EntFire("menu_panel_summary","Enable");
    EntFire("score_row_*","Enable");
    EntFire("summary_difficulty_button_*", "unlock");
    ::SetSummaryDifficulty(diff);
}

::HideSummaryMenu<-function()
{
    EntFire("menu_ag_click","PlaySound");
    EntFire("menu_panel_summary","Disable");
    EntFire("score_row_*","Disable");
    EntFire("summary_difficulty_button_*", "lock");
    EntFire("summary_difficulty_*","Disable");
}
//############# Popups
::ShowNewScorePopup<-function()
{
    ::SetStartClipStatus(true);
    EntFire("new_score_popup","close");
    EntFire("menu_popup_particle", "start"); 
    EntFire("menu_popup_particle", "stop", "", 1); 
    EntFire("@script","runscriptcode","::PlayWinSound()",0.25);
    EntFire("new_score_button","Unlock");
}
::HideNewScorePopup<-function()
{
    EntFire("new_score_button","Lock");
    EntFire("new_score_popup","open");
    if(::state.SCREENS.event_end)
    {
        EntFire("game_round_end", "EndRound_Draw", 0.01, 0.2);
    }
    else
    {
        ::SetStartClipStatus(false);
    }
}

::ShowDifficultyPopup<-function(diff=null)
{
    if(::state.ignore_difficulty_popup) return;
    ::SetStartClipStatus(true);
    ::state.consecutiveLosses = 0;
    ::state.ignore_difficulty_popup = true;
    EntFire("difficulty_popup","Close");
    EntFire("difficulty_popup_difficulty_*","disable");
    EntFire("difficulty_popup_difficulty_"+diff,"enable");
}
::HideDifficultyPopup<-function()
{
    EntFire("difficulty_popup","open");
    EntFire("difficulty_popup_difficulty_*","disable");
    ::SetStartClipStatus(false);
}
::ShowEventSummaryMenu<-function(diff=null)
{
    if(!diff || !::IsPopupValid("event_summary")) return;

    ::HideScoreMenu();
    ::HideSummaryMenu();
    EntFire("summary_difficulty_button_*", "lock");
    EntFire("event_row_*","enable");
    EntFire("menu_panel_summary_event","enable");
    EntFire("event_summary_background","enable");
    try
    {
        if(::state.SERVER_DATA.challenge_id)
        {
            ::SetDisplayText("event_row_1",  ::state.SERVER_DATA.user_info.max_score);
        }
    }
    catch(e)
    {
    }
    EntFire("event_summary_difficulty_*","disable");
    EntFire("event_summary_difficulty_"+diff,"enable");
    EntFire("score_row_*","Enable");
}
::HideEventSummaryMenu<-function()
{
    EntFire("event_row_*","disable");
    EntFire("menu_score_7","disable");
    EntFire("menu_panel_summary_event","disable");
    EntFire("event_summary_difficulty_*","disable");
    EntFire("event_summary_background","disable");
}
::ShowEventEndPopup<-function()
{
    ::Event_EndScreenViewed();
    ::SetStartClipStatus(true);
    EntFire("popup_event_end","close");
    EntFire("popup_event_end_button","unlock",0.5);
}
::HideEventEndPopup<-function()
{
    EntFire("popup_event_end_button","lock");
    EntFire("popup_event_end","open");
}
//############# Utils
::PlayWinSound<-function()
{
    ::player.EmitSound(::PARTY_HORN);
}

::SetIntroDifficulty<-function(diff=null)
{
    if(diff && ::IsPopupValid("intro"))
    {
        EntFire("intro_difficulty_*", "Disable");
        EntFire("intro_difficulty_"+diff, "Enable");
        EntFire("intro_difficulty_button_"+diff, "Enable");
    }
}
::SetEventIntroDifficulty<-function(diff=null)
{
    EntFire("event_intro_difficulty_*", "Disable");
    EntFire("event_intro_difficulty_"+diff, "Enable",0.1);
}
::SetSummaryDifficulty<-function(diff=null)
{
    if(diff && ::IsPopupValid("summary"))
    {
        EntFire("summary_difficulty_*","Disable");
        EntFire("summary_difficulty_button_"+diff, "Enable");
        EntFire("summary_difficulty_"+diff,"enable");
    }
}
::SetPopupDifficulty<-function(diff=null)
{
    if(diff && ::IsPopupValid("popup"))
    {
        EntFire("difficulty_popup_difficulty_*","disable");
        EntFire("difficulty_popup_difficulty_"+diff,"enable");
    }
}

::IsPopupValid<-function(name)
{  
    switch(name)
    {
        case "intro": return (!::state.SCREENS.event_end && ::state.SCREENS.intro);
        case "popup": return (!::state.SCREENS.event_end);
        case "event_intro": return (::state.SCREENS.event_intro);
        case "event_end": return (::state.SCREENS.event_end);
        case "event_summary": return (!::state.SCREENS.event_end) ? true:false;
    }
    return true;
}
