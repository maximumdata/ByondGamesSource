
//just some lame commands i thought of. none of these will be very necessary at all.

mob/GM/verb
	End_With_Forced_Winner(mob/M in world)
		set category="GM"
		if(Start)
			if(alert(src,"Are you sure?","Force [M] to win","Yes","No")=="Yes")
				EndGame(M)
			else
				alert(src,"INDECISIVE DIPSHIT!!! >:D")
		else
			alert(src,"There isn't a game for [M.name] to win! Ass!")

	Mute(mob/M in world)
		set category="GM"
		if(M==src)
			src<<"<b>Can't mute yourself!"
			return
		if(!M.mute)
			M.mute++
			world<<"<b>[src.name] muted [M.name]!"
		else
			M.mute--
			world<<"<b>[src.name] unmuted [M.name]."

