

mob
	icon='player.dmi'
	var
		ores=0
		forging=0

	Stat()
		//statpanel("ok")
		stat(src.contents)
		if(src.ores)
			statpanel("Ores")
			for(var/obj/ores/O in src.contents)
				stat(O)
		if(src.forging)
			statpanel("Forging")
			for(var/obj/bars/B in src.contents)
				stat(B)

