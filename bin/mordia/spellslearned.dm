

mob
	var
	//DRUID
		dragonlearn=0

	//NECRO
		reaperlearn=0
		shadowlearn=0

	//WIZARD
		acidlearn=0

	proc
		spellcheck(mob/M)
			if(istype(M,/mob/player/Necro))
				if(!M.shadowlearn)
					if(M.level ==2)
						M<<"woot j00 is teh lernt tehz sh4d0w m4g3z"
						M.shadowlearn=1
						M.verbs += /mob/player/Necro/learned/verb/Shadow_Mage
