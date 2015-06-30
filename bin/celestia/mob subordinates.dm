
mob
	proc/SubordWalk(mob/M)
		if(!src:pwner)
			for(var/mob/A in oview(4,src))
				if(A.race!= src.race)
					if(!M.curtarget)
						M.curtarget=A
						walk_to(M,A,1,3)
						M.fight()
		else
			if(M:canattack)
				for(var/mob/A in oview(4,src))
					if(A.race!= src.race)
						if(!M.curtarget)
							M.curtarget=A
							walk_to(M,A,1,3)
							M.fight()
		if(!src.curtarget)
			step_card(M)
		spawn(rand(30,45))
			if(M.curtarget)
				M.curtarget=null
			SubordWalk(src)
	player
		subord
			New()
				..()
				src.strength=rand(3,7)
				SubordWalk(src)
			var
				pwner
				canattack=1
			Verrisk
				name="Verrisk Soldier"
				icon_state="verrisk"
				race="Verrisk"
			Gra
				name="Gra Soldier"
				icon_state="gra"
				race="Gra"
			Homulid
				name="Homulid Soldier"
				icon_state="homulid"
				race="Homulid"
		var/thing=0
		verb
			MoveTo()
				set hidden = 1
				for(var/mob/player/subord/T in src.client.selected)
					var/newloc=locate(src.cmdx,src.cmdy,T.z)
					walk_to(T,newloc,1,3)
			TroopAttack()
				set hidden=1
				for(var/mob/player/subord/S in src.client.selected)
					if(curtarget in oview(1,S))
						S.fight(src.curtarget)

			SetAttack()
				set hidden = 1
				for(var/mob/player/subord/Q in src.client.selected)
					if(!src.thing)
						Q.canattack=0
						src<<"Selected unit will no longer attack on sight while selected"
					else
						Q.canattack=1
						src<<"Selected unit will now attack on sight while selected"
				if(!src.thing)
					src.thing=1
				else
					src.thing=0