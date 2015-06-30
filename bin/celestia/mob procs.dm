mob
	proc
		fight(mob/Q)
			if(!Q)
				var/mob/M=src.curtarget
				if(!src.fighting)
					src.damage=null
					src.damage=src.strength*rand(1,2)
					if(M in oview(1,src))
						src.fighting=1
						M.hp-=src.damage
						if(src.client)
							s_damage(M, src.damage, "#FF0000")
						else
							s_damage(M, src.damage, "#FFFFFF")
						death(M)
						src.curtarget=null
						spawn(src.attackdelay)
							src.fighting=0
			else
				if(!src.fighting)
					src.damage=null
					src.damage=src.strength*rand(1,2)
					if(Q in oview(1,src))
						src.fighting=1
						Q.hp-=src.damage
						if(src.client)
							s_damage(Q, src.damage, "#FF0000")
						else
							s_damage(Q, src.damage, "#FFFFFF")
						death(Q)
						spawn(src.attackdelay)
							src.fighting=0
		death(mob/M)
			if(M.hp <= 0)
				if(M.client)
					M.loc=locate(5,5,2)
					M.hp=M.maxhp
					M.client.view=world.view
					M.umsl_locks -= list("right leg", "left leg")
					if(M!=src)
						world<<"<big>\red [M] was killed by [src]"
					else
						world<<"<big>\red [M] killed \himself"
				else
					if(M!=src)
						if(src.client)
							src<<"\yellow You killed \a [M]"
						else
							src:pwner<<"\yellow A unit under your control killed \a [M]"
						del(M)
					else
						M<<"You have killed yourself!"


