::BOTS_KILL_QUOTA <- 5;
::TIMER_START_SOUND <- "tr.TimerBell";
::WIN_SOUND <- "win_sound.mp3";
::TIMER_HURRY_UP_SOUND <- "separatist.radio.letsgo11";
::PARTY_HORN <- "weapons/party_horn_01.wav";
::EVENT_HUD_TEXT_1_MSG <- "Event ends in:";
::ROUND_TIME <- 30;
::BOMB_TIME <- 40;
::TIME_RUNNING_OUT_THRESHOLD <- 5;
::DEFAULT_PLAYABLE_DIFFICULTY <- 2;
//# EQUIPMENT
::PLAYER_EQUIPMENT <- 
[
    ["item_kevlar",1],
    ["weapon_famas",90],
    ["weapon_usp_silencer",24],
    ["weapon_knife",1]
]

::DEFAULT_BOT_EQUIPMENT <-
[
    "item_kevlar,ak47,knife",
    "item_kevlar,ak47,knife",
    "item_kevlar,ak47,knife",
    "item_kevlar,ak47,knife",
    "item_kevlar,galilar,knife",
]

::DIFFICULTY_ARRAYS <-
[
    [1,1,1,2,2],
    [3,3,4,4,4],
    [4,5,5,5,6],
]

//# SCORE VALUES
::TIME_SCORE <- 150;
::KILLTIME_SCORE <- 50;
::HEADSHOOTS_SCORE <- 100;
::HP_SCORE <- 5;

::DIFFICULTY_CONSECUTIVE_LOSSES <- 30;

//# PLAYER
::PLAYER_STARTING_HEALTH <- 100;
::PLAYER_STARTING_AMMO <- 115;

//# DELAYS
::RESET_ROUND_DELAY <- 1;
::RESET_ROUND_REMINDER_DELAY <- 120;
::EDGE_TIP_MSG_DELAY <- 120;
::EDGE_TIP_MSG_DELAY_SPAWN <- 30;
::ROUND_END_DELAY <- 3;
::EVENT_END_REMINDER_DELAY_1 <- 600;
::EVENT_END_REMINDER_DELAY_2 <- 300; 

//# CHAT MESSAGES
::RESET_ROUND_TIP_MSG <- "\x01" + "Type " + TextColor.Red + "!r" + "\x01" + " in chat to reset the map";
::DIFFICULTY_REMINDER_MSG <- "\x01" + "Your current difficulty is: ";
::EDGE_TIP_MSG <- TextColor.Common + "Visit" + TextColor.Uncommon + " Ludeo Platform" + TextColor.Common + " for leaderboard, rewards, and many more ludeos";
::RESTARTING_ROUND_MSG <- TextColor.Red + "Restarting!";
::SOUND_EFFECTS_OFF_MSG <-  "Casters Sound " + TextColor.Red + "Disabled";
::SOUND_EFFECTS_ON_MSG <-  "Casters Sound " + TextColor.Award + "Enabled";

//# SCORE CHAT MESSAGES
::SCORE_TIME_CHAT_MSG <-   TextColor.Award + "Time: " + TextColor.Normal;
::SCORE_KILLTIME_CHAT_MSG <-   TextColor.Award + "Kill Time: " + TextColor.Normal;
::SCORE_HEADSHOTS_CHAT_MSG <-  TextColor.Award + "Headshots: " + TextColor.Normal;
::SCORE_HP_CHAT_MSG <- TextColor.Award + "Health: " + TextColor.Normal;
::SCORE_DIFFICULTY_CHAT_MSG <- TextColor.Award + "Difficulty: " + TextColor.Normal;
::SCORE_TOTAL_SCORE_CHAT_MSG <-  TextColor.Rare + "Total Score: " + TextColor.Normal;

//# CHALLENGES MESSAGES
::SCORE_HIGHEST_SCORE_CHAT_MSG <- TextColor.Rare + "Highest Score: " + TextColor.Normal;
::EVENT_START_MSG <- "You're participating in a " + TextColor.Uncommon + "Ludeo Event";
::EVENT_END_REMINDER_MSG <- TextColor.Rare + "Live Event will end soon" + TextColor.Normal;
::EVENT_END_MSG <- TextColor.Rare + "Live Event has ended";