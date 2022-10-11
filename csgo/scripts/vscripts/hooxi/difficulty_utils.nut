::DIFF_POPUP_TOOLTIP_DURATION <- 3;
if(!::state.exists("playable_difficulty"))
{
    ::state.playable_difficulty <- ::DEFAULT_PLAYABLE_DIFFICULTY;
}
if(!::state.exists("custom_difficulty"))
{
    ::state.custom_difficulty <- [0,0,0,0,0];
}
if(!::state.exists("show_difficulty_popup"))
{
    ::state.show_difficulty_popup <- false;
}
if(!::state.exists("ignore_difficulty_popup"))
{
    ::state.ignore_difficulty_popup <- false
}
if(!::state.exists("bot_casual_difficulty"))
{   
    ::state.bot_casual_difficulty<-::DIFFICULTY_ARRAYS [0];
}
if(!::state.exists("bot_advanced_difficulty"))
{   
    ::state.bot_advanced_difficulty<-::DIFFICULTY_ARRAYS [1];
}
if(!::state.exists("bot_insane_difficulty"))
{   
    ::state.bot_insane_difficulty<-::DIFFICULTY_ARRAYS [2];
}
if(!::state.exists("showDiffMenu"))
{
    ::state.showDiffMenu <- 
    {
        start = 1,
        popup = 0,
        score = 1
    }
}

// Return difficulty name by number
::GetDifficultyNameByNumber<-function(i)
{
    switch(i)
    {
        case 1: return "Casual";
        case 2: return "Advanced";
        case 3: return "Insane";
        default: return "";
    }
}
// Return color string (hexa) by difficulty number
::GetDifficultyColorByNumber<-function(i)
{
    switch(i)
    {
        case 1:
           return "\x09";
        case 2:
             return "\x10";
        case 3:
             return "\x02";
        default:
          return "\x01";
    }
}
/*
* Prints difficulty message to chat
* Colors the difficulty with the appropriate color
*/
::PrintDifficultyToChat<-function()
{
    local diff = ::state.playable_difficulty;
    Chat( "You've changed to " + GetDifficultyColorByNumber(diff) + (::GetDifficultyNameByNumber(diff)) + "\x01"+" difficulty");
}

::ShowTooltip<-function()
{
    local tooltipMsg = "You've changed to " +  (::GetDifficultyNameByNumber(::state.playable_difficulty))  + " difficulty";
    ::OverrideSetMenuLookThink(tooltipMsg,::DIFF_POPUP_TOOLTIP_DURATION);
}

::ApplyDifficulty<-function(diff)
{
    ::state.playable_difficulty = diff;
    if(!::state.ignore_difficulty_popup) ::state.ignore_difficulty_popup = true;
    if(!::state.isScoreTableEnabled)
    {
        ::SetSummaryDifficulty(diff);
    }
    ::PrintDifficultyToChat();
}
::SelectPopupDifficulty<-function(diff=null)
{
    local _diff = ::state.playable_difficulty;
    ::ApplyDifficulty(diff);
    ::SetPopupDifficulty(diff);
    EntFire("@script","runscriptcode","::HideDifficultyPopup()",0.2);
    if(_diff!=::state.playable_difficulty)
    {
        ::state.CONST_DIFF_RESET = 1;
        EntFire("game_round_end", "EndRound_Draw", 0.01, 0.5);
    }
    
}   
// From summary
::SelectDifficulty<-function(diff=null)
{
    if(!diff || ::state.playable_difficulty == diff) return;
    ::ApplyDifficulty(diff);
    ::SetSummaryDifficulty(diff);
    if(::state.FIRST_START)
    {
        ::SetIntroDifficulty(diff);
    }
    ::state.CONST_DIFF_RESET = 1;
    EntFire("game_round_end", "EndRound_Draw", 0.01, 0.5);
}

// From intro menu only
::SelectIntroDifficulty<-function(diff=null)
{
    if(!diff || ::state.playable_difficulty == diff) return;
    ::ApplyDifficulty(diff);
    ::SetIntroDifficulty(diff);
}
