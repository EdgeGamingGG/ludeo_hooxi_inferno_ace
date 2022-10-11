::botsPlayerSaw <- [0,0,0,0,0,0,0];
::excludedIds <- [5];
::LookingAtBot<-function()
{
	return;
	if(!::timerRunning) return;
	local bot;
	while (bot = Entities.FindByClassname(bot, "cs_bot")) 
	{	
		if(!::player) break;
		local valid = true;
		local botid = split(split(bot.tostring(),"]")[0],"[")[1].tointeger();
		if(botid<2) continue; // player
		botid-=2; // normalize id to 0 - 4
		for(local i=0;i<::excludedIds.len() && valid;i++)
		{
			if(::excludedIds[i]==(botid+1))
			{
				valid = false;
			}
		}
		if(!valid) continue;
		local bLooking;
		local eyePos = ::player.EyePosition();
		local origin = bot.GetOrigin();
		local bLooking = false;
		local offset = 10; // 20
		local lookAngle = 0.9;
		local positions = 
		[
			Vector(origin.x, origin.y,origin.z),
			
			Vector(origin.x - offset, origin.y - offset, origin.z),
			Vector(origin.x + offset, origin.y + offset, origin.z),
			Vector(origin.x + offset, origin.y - offset, origin.z),
			Vector(origin.x - offset, origin.y + offset, origin.z),

			Vector(origin.x, origin.y - offset, origin.z - offset),
			Vector(origin.x, origin.y + offset, origin.z + offset),
			Vector(origin.x, origin.y - offset, origin.z + offset),
			Vector(origin.x, origin.y + offset, origin.z - offset),

			Vector(origin.x - offset, origin.y , origin.z - offset),
			Vector(origin.x + offset, origin.y , origin.z + offset),
			Vector(origin.x - offset, origin.y , origin.z + offset),
			Vector(origin.x + offset, origin.y , origin.z - offset)
		] 
		foreach(position in positions)
		{
			if(!VS.TraceLine( eyePos, position, ::player.self, MASK_NPCWORLDSTATIC ).DidHit())
			{
				bLooking = VS.IsLookingAt( eyePos, position, ::player.EyeForward(), lookAngle );
			}
		}	
		if (bLooking)
		{
			if(!::botsPlayerSaw[botid])
			{
				
				::botsPlayerSaw[botid] = 1;
                try
                {
					::ReleaseBotClip((botid+1));
                }
                catch(e)
                {
                    printl(e);
                }
			}
		}
	}
	EntFire("@script","runscriptcode","::LookingAtBot()",0.1);
}
