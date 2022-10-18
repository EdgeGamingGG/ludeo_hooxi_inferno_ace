::hunters <- [0,0,0,0,0];
::released <- [0,0,0,0,0];
::botTimes <- [0,4,5.5,6.5,7.25];

::bot4TargetInfo <- Entities.FindByName(null,"map_bot_runto_target_4");
::bot5TargetInfo <- Entities.FindByName(null,"map_bot_runto_target_5");
/*
* Kill all bots in the map, remove their bodies after
*/
::KillAllBots<-function()
{
	local bots;	
	while (bots = Entities.FindByClassname(bots, "cs_bot"))
	{
		EntFireByHandle(bots, "Kill", "", 0.0, null);			
	}
	::RemoveDeadBodies();
}

/*
* Spawn the next wave
*/
::SpawnWave<-function( amount )
{
	ScriptCoopMissionSpawnNextWave( amount );
}

/*
* Function disables or enables bot entities 
*/
::SetBotSpawnsStatus<-function(newState,delay=0)
{
	local cmd = "setdisabled";
	if(newState)
	{
		cmd = "setenabled";
	}
	for(local i=1 ; i <= ::BOTS_KILL_QUOTA ; i++)
	{
		EntFire("bot_"+i, cmd, "", delay , null);
	}
}

/**
* Function disables bot clips (jail) and pushes them to trigger behavior
*/
::TriggerBotClips<-function()
{
	local jailTime = 0;
	for(local i=1; i<=::BOTS_KILL_QUOTA; i++)
	{
		local _time = botTimes[i-1];
		try
		{
			::ReleaseBotClip(i,_time);
		}
		catch(e)
		{
			printl("[Bot Clips] - ERROR for i = " + i + "\n" + e);
		}	
	}
}

::ReleaseBotClip<-function(i,delay=0)
{
	if(i <1 || i >::BOTS_KILL_QUOTA)
	{
		return;
	}
	if(::released[i-1]) return;
	::released[i-1] = 1;
	try
	{
		EntFire("bot_"+i+"_clip","open","",delay + 0.1);
		printl("release bot "+i+" !!!")
	}
	catch(e)
	{
		printl("[Ludeo] - Error ----------> " + e);
	}
}

::RandomizeInfoTargetPosition<-function(botid)
{
	try
	{
		local target;
		if(botid == 4)
			target = ::bot4TargetInfo;
		else if(botid == 5)
			target = ::bot5TargetInfo;

		if(target)
		{
			target.SetOrigin(target.GetOrigin() + Vector(RandomFloat(-20.0, 20.0),RandomFloat(-20.0, 20.0),0));
		}
	}
	catch(e)
	{
				printl("[Ludeo] - Cant update bot info target " + e);
	}
	EntFire("@script","runscriptcode","::RandomizeInfoTargetPosition(" + botid+ ")",1.0);
}

::BotReleasedFlagUpdate<-function(i=0)
{
	::released[i-1] = 1;
}

::SetHunterActive<-function(botid)
{
	::hunters[botid-1] = 1;
}

::SetTargetInfoOnPlayer<-function(botid)
{
	local pos = Entities.FindByName(null,"map_bot_runto_target_"+botid);
	if(pos)
	{
		pos.SetOrigin(::player.GetOrigin());
	}
}

::HuntPlayerInfoTargetWithoutLastTwoBots<-function()
{
	try
	{
		for(local i=1;i<=::BOTS_KILL_QUOTA-2;i++)
		{
			local pos = Entities.FindByName(null,"map_bot_runto_target_"+i);
			if(pos)
			{
				pos.SetOrigin(::player.GetOrigin());
			}
		}
	}
	catch(e)
	{
	}
	EntFire("@script","runscriptcode","::HuntPlayerInfoTargetWithoutLastTwoBots()",2);
}

// Sets all info targets on player every second
::HuntPlayerInfoTarget<-function()
{
	try
	{
		for(local i=1;i<=::BOTS_KILL_QUOTA;i++)
		{
			local pos = Entities.FindByName(null,"map_bot_runto_target_"+i);
			if(pos)
			{
				pos.SetOrigin(::player.GetOrigin());
			}
		}
	}
	catch(e)
	{
	}
	EntFire("@script","runscriptcode","::HuntPlayerInfoTarget()",2);
}
/**
* This function fixes an issue where bots can't spawn on first round only after map loads
*/
::SpawnFirstBots<-function()
{
	ScriptCoopMissionSpawnNextWave(::BOTS_KILL_QUOTA)
	EntFire("@script","runscriptcode","::SetBotSpawnsStatus(false)",0.1);
	EntFire("@script","runscriptcode","::KillAllBots()",0.2);
}

::ReleaseBotWalls<-function(i)
{
	if(i<1 || i>::BOTS_KILL_QUOTA)
	{
		return;
	}
	EntFire("bot_"+i+"_wall","unlock");
	EntFire("bot_"+i+"_wall","Open");
}
::WallBot<-function(i)
{
	EntFire("bot_"+i+"_wall","Close");
}

::ThrowMolotov<-function()
{
	EntFire("molotov_start","trigger","",0.1);
}

::ReleaseAll<-function()
{
	::HuntPlayerInfoTarget();
	EntFire("bot_*_clip","disable");
	EntFire("bot_*_push","disable",2);
	EntFire("bot_*_push","enable");
}

/*
	Returns the current number of bot entities in the map
*/
::GetBotsAlive<-function()
{
	local bot = null;
	local count = 0;
	while (bot = Entities.FindByClassname(bot, "cs_bot")) 
	{	
		if(bot) count++;
	}
	return count;
}