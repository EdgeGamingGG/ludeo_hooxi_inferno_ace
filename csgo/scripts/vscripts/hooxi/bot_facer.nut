const frequency = 0.001; //0.0001 //0.02// how often the script calls itself. Higher numbers = called less frequently.
::_playerEntity <- null;

//# Arays suited for actual bots, bot_1, bot_2, etc..
::b_velovities <- 	[2.1, 	1.2, 	-0.3, 	-1.0, 	0.0, 	0.0]
::b_dirRight <- 	[true, 	true, 	true, 	true, 	true, 	true]

//# Arrays suited for difficulties, 0 - 7 (inclusive)
::DEFAULT_ZCORRECTION <- [-16,-16,-16,-16,-16,-16,-16,-16,-16];
::DEFAULT_HSPREAD <- [0,0,0,0,0,0,0,0,0];
::b_zCorrection <- [-16,-16,-16,-16,-16,-16,-16,-16,-16];
::b_hSpread <- [0,0,0,0,0,0,0,0,0];

//# Chance of changing direction
::flipChance <- 0.03
//left right rotation speed
::hspeed <- 0.22;
//max value for speed randomisation to avoid syncronisation
::hspeed_randomizer <- 1.1;

// Set ZCorrection to a bot with ID #
::SetZCorrectionByBotNumber<-function(botid,z)
{
	botid = ::Utils.Clamp(0,4);
	if(::state.custom_difficulty[0]>0)
	{
		::b_zCorrection[::state.custom_difficulty[botid]] = ::Utils.Clamp(z,-1000,1000);
	}
	else
	{
		
		::b_zCorrection[::DIFFICULTY_ARRAYS[::state.playable_difficulty-1][botid]] = ::Utils.Clamp(z,-1000,1000);
	}
}
// Set Hspread to a bot with ID #
::SetHspreadByBotNumber<-function(botid,spread)
{
	botid = ::Utils.Clamp(0,4);
	if(::state.custom_difficulty[0]>0)
	{
		::b_hSpread[::state.custom_difficulty[botid]] = ::Utils.Clamp(z,-1000,1000);
	}
	else
	{
		::b_hSpread[::DIFFICULTY_ARRAYS[::state.playable_difficulty-1][botid]] = ::Utils.Clamp(z,-1000,1000);
	}
}
//# Reset zCorrection for all difficulties with the default one
::ResetZCorrection<-function()
{
	::b_zCorrection = ::DEFAULT_ZCORRECTION;
	if(::AT.ENABLED)
	{
		local str = "";
		foreach(val in ::b_zCorrection)
		{
			str  += '|' + val.tostring() + '|';
		}
		Chat("ZCorrection reset for all bots: " + str);
		
	}
}
//# Reset ResetHspread for all difficulties with the default one
::ResetHspread<-function()
{
	::b_hSpread = ::DEFAULT_HSPREAD;
	if(::AT.ENABLED)
	{
		local str = "";
		foreach(val in ::b_hSpread)
		{
			str  += '|' + val.tostring() + '|';
		}
		Chat("Hspread reset for all bots: " + str);
		
	}
}
/*
* Start the bot facer script
*/
::StartBotFacer<-function()
{
	::_playerEntity = null;
	::FaceAllBotsTowardsPlayer();
}

// Function to make all bots in the level face the player at all times
::FaceAllBotsTowardsPlayer<-function()
{
	if (::timerRunning)
	{
		local bot;
		// Loop over the bots to change their looking angles.
		while (bot = Entities.FindByClassname(bot, "cs_bot")) 
		{		
			local target, angles_new, angles_old
			if (bot != null)
			{		
				try
				{
					local botid = split(split(bot.tostring(),"]")[0],"[")[1].tointeger();
					botid-=2;
					local diffArr = ::DIFFICULTY_ARRAYS[::state.playable_difficulty-1];
					local botDifficulty = diffArr[botid];
					target = ::player.self.GetOrigin()
					angles_old = bot.GetAngles()
					angles_new = VS.GetAngle( bot.GetOrigin(), Vector(target.x, target.y, (target.z + ::b_zCorrection[botDifficulty] )) ) 

					if(!target){
						printl("Facer- failed to get player origin");
						return;
					}
					if(!angles_old){
						printl("Facer- failed to get bot angles");
						return;
					}
					if(!angles_new){
						printl("Facer- failed to create vector");
						return;
					}
					if(bot.GetHealth() > 0)
					{
						if( diffArr[botid] > 3)
						{
							bot.SetAngles( 	angles_new.x, angles_new.y, angles_old.z )
						}
						else
						{
							bot.SetAngles( 	angles_new.x, angles_new.y + ::b_velovities[botid], angles_old.z )
						}
						if(::b_dirRight[botid] == true)
						{
							::b_velovities[botid] += hspeed + RandomFloat(0,hspeed_randomizer)
							if(::b_velovities[botid] > ::b_hSpread[botDifficulty]){::b_dirRight[botid] = false}
						}
						else
						{
							::b_velovities[botid] -= hspeed + RandomFloat(0,hspeed_randomizer)
							if(::b_velovities[botid] < 0- ::b_hSpread[botDifficulty]){::b_dirRight[botid] = true}
						}
						//random flip direction
						local randomint = RandomFloat(0.0, 1.0)
						if(randomint <= flipChance)
						{
							::b_dirRight[botid] = !::b_dirRight[botid]
						}
					}
				}
				catch(e)
				{
					printl("Facer- caught error: "+e);
				}
			}else{
				printl("Facer- bot is null");
			}
		}   
		EntFire("@script", "runscriptcode", "::FaceAllBotsTowardsPlayer()", frequency, null);
	}
}














