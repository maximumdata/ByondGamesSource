
obj
	MAGIC
		icon='MAGIC.dmi'
		fireball
			icon_state="fireball"
		acidball
			icon_state="acidball"
mob
	player
		Wizard
			MAGIC
				var/lvlreq
				innate
					verb
						Fireball(mob/M in oview(5))
							set category = "Magic"
							if(src.casting)
								src<<"\yellow<small>System:</small>\black<small><b><small>You must wait to cast this again!"
							else
								if(src.MP>=5)
									if(M.NPC)
										src<<"\yellow<small>System:</small>\black<small><b>You can't attack an NPC!!!</b>"
									else
										src.casting=1
										sleep(2)
										s_missile(/obj/MAGIC/fireball,src.loc,M,3)
										var/damage = rand(round(2 - M.Resistance_Fire),round(4 - M.Resistance_Fire))   //As you see here, you can put lots of procs into each other's arguments.
										if(damage < 0)
											damage = 0
										if(damage)
											M.HP-=damage
											M << "\yellow<small>System:</small>\black<small><small> You were hit for <small>\red<small>[damage]<small>\black<small> points by <font color=\"[src.fontcolor]\">[src]</font>'s<font color = \"red\">fireball</font>!</i></small>"
											src<< "\yellow<small>System:</small>\black<small><small> Your <font color=\"red\">fireball</font> hit <font color=\"[M.fontcolor]\">[M]</font> for <small>\red<small>[damage]\black<small> points!</small>"
										else
											M<<"\yellow<small>System:</small>\black<small><small> You resist [src]'s fireball!"
											src<<"\yellow<small>System:</small>\black<small><small> [M] resisted your fireball!"
										src.MP-=5
										deathcheck(M)
										sleep(2)
										src.casting=0
								else
									src<<"\yellow<small>System:</small>\black<small><b>You need\red 5\black mana to cast a spell!</b>"


						Fire_Halo()
							set category="Magic"
							/*
							var/obj/O = new /obj/Flame (T)           //Create a flame on that turf.
							for(var/mob/M in range(0,T))     //For any mobs on where that flame is...
								M.HP -= rand(20,50)
								deathcheck(M)               //These to things are a just for this example.
*/
				learned
					verb
						Acidball(mob/M in oview(5))
							set category="MAGIC"
							if(src.casting)
								src<<"\yellow<small>System:</small>\black<small><b><small>You must wait to cast this again!"
							else
								if(src.MP>=10)
									if(M.NPC)
										src<<"\yellow<small>System:</small>\black<small><b>You can't attack an NPC!!!</b>"
									else
										src.casting=1
										sleep(2)
										s_missile(/obj/MAGIC/acidball,src.loc,M,3)
										var/damage=rand(15,(src.level*2))
										M.HP-=damage
										M << "\yellow<small>System:</small>\black<small><small> You were hit for <small>\red<small>[damage]<small>\black<small> points by <font color=\"[src.fontcolor]\">[src]</font>'s<font color = \"green\">acidball</font>!</i></small>"
										src<< "\yellow<small>System:</small>\black<small><small> Your <font color=\"green\">acidball</font> hit <font color=\"[M.fontcolor]\">[M]</font> for <small>\red<small>[damage]\black<small> points!</small>"
										src.MP-=10
										deathcheck(M)
										sleep(2)
										src.casting=0
								else
									src<<"\yellow<small>System:</small>\black<small><b>You need\red 5\black mana to cast a spell!</b>"