
// Caches scores for data plugin
::CacheScores<-function()
 {
	printl("[Ludeo] - Caching Score");
	SendToConsoleServer("sm_mapshot_cache");
	EntFire("@script","runscriptcode","::PushScores()",0.1);
}

// Pushes cached scores to data plugin
::PushScores<-function()
{
	printl("[Ludeo] - Pushing Score");
	SendToConsoleServer("sm_mapshot_push");
}

// Sends an event for when the player spawns
//## NOTE: Place this in PrepareRound function or equivalent (player fully spawns in playable position)
::Event_PlayerSpawn<-function()
{
	return; // Currently not in use, do not report this event!
	printl("[Ludeo] - Event Player Spawn");
    SendToConsoleServer("sm_mapshot_player_at_spawn");
}

// Sends an event for when the player crosses the starting line and triggers the playable
//## NOTE: Place this in RoundStart function or equivalent (timer starts)
::Event_StartRound<-function()
{
	printl("[Ludeo] - Event Player Start Round");
    SendToConsoleServer("sm_mapshot_playable_start_round");
}
// Sends an event for when the player shoots the intro menu's "Start Playable" button
//## NOTE: Place this in the function which is triggered after activating the start button
//## Call this once per playable
::Event_StartButton<-function()
{
	printl("[Ludeo] - Event Player Start Button");
    SendToConsoleServer("sm_mapshot_playable_start_button");
}

// Sends an event for when the playable is loading
//## NOTE: Call this once per map load. Avoid placing it where the playable auto-loads itself (like coop mode is wrong and then it quickly reloads map)
//## Suggestion: Use ::state variable like ::state.loaded
::Event_PlayableLoading<-function()
{
	printl("[Ludeo] - Event Playable Loading");
    SendToConsoleServer("sm_mapshot_playable_loading");
	::state.loaded = true;
}

// Intro event viewed / displayed
::Event_IntroScreenViewed<-function()
{
	printl("[Ludeo] - Event Intro Screen Viewed");
	SendToConsoleServer("sm_event_intro_screen_viewed");
}
// Intro event clicked (cta)
::Event_IntroScreenClicked<-function()
{
	printl("[Ludeo] - Event Intro Screen Clicked");
	SendToConsoleServer("sm_event_intro_screen_clicked");
}
// Event end screen viewed / displayed
::Event_EndScreenViewed<-function()
{
	printl("[Ludeo] - Event End Screen Viewed");
	SendToConsoleServer("sm_event_end_screen_viewed");
}
// Event end screen clicked (cta)
::Event_EndScreenClicked<-function()
{
	printl("[Ludeo] - Event End Screen Clicked");
	SendToConsoleServer("sm_event_end_screen_clicked");
}
::SendToConsoleBoth<-function(s){ SendToConsole(s); SendToConsoleServer(s) }