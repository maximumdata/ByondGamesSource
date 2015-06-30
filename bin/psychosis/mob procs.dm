
proc
	death(mob/M,mob/killer)
		if(M.hp <=0)
			world<<"[M] done went and died!"
			killer.kills++
			if(!M.client)
				del(M)
			else
				M<<"yeah, you're dead now, i haven't coded the death stuff yet, so....uhm....enjoy?"
				M.hp=M.maxhp
				M.loc=locate(1,1,1)

mob
	proc
		Respond(mob/M,msg as text)
			if(findText(msg, "hi")||findText(msg, "Hi"))
				M.Say("Hello...")
		stamrech()
			if(!src.running)
				if(src.stamina<maxstam)
					src.stamina++
				spawn(rand(6,10)) stamrech()
			else return

		RandMove(mob/M)
			if(!src.ID)
				step_rand(M)
				spawn(5) RandMove(M)


