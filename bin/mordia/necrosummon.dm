mob
	player
		Necro
			innate
				verb
					Unsummon_()
						set category="Summon"
						var/thing=list("")
						for(var/mob/player/Necro/summons/S in world)
							if(S.owner==src)
								thing+=S
						thing+="Cancel"
						var/mob/thing2=input("Which creature do you wish to unsummon?") in thing
						if(thing2!="Cancel")
							thing2.HP=0
							deathcheck(thing2)
						else
							return
					Skeleton(obj/corpse/O in oview(5))
						set category= "Summon"
						if(src.MP<10)
							usr<<"\yellow<small>System:</small>\black<small><b><small> You need mana for this!"
						else
							if(src.skeletons<src.skeletonmax)
								var/mob/S = new /mob/player/Necro/summons/Skeleton(O.loc)
								src.MP -= 10
								src.skeletons++
								S.owner=src
								S.level=src.level
								S.HP=S.maxHP
								del(O)
								src<<"\yellow<small>System:</small>\black<small><b><small> You created a Skeleton!"
							else
								src<<"\yellow<small>System:</small>\black<small><b><small> You have too many Skeletons already!"
			learned
				verb
					Shadow_Mage(obj/corpse/O in oview(5))
						set category= "Summon"
						if(src.MP<20)
							usr<<"\yellow<small>System:</small>\black<small><b><small> You need mana for this!"
						else
							if(src.mages<src.maxmages)
								var/mob/S = new /mob/player/Necro/summons/ShadowMage(O.loc)
								src.MP -= 20
								src.mages++
								S.owner=src
								S.HP=S.maxHP
								del(O)
								src<<"\yellow<small>System:</small>\black<small><b><small> You created a Shadow Mage!"
							else
								src<<"\yellow<small>System:</small>\black<small><b><small> You have too many Shadow Mages already!"
					Reaper(obj/corpse/O in oview(5))
						set category="Summon"
						if(src.MP<150)
							usr<<"blah"
						else
							if(!src.reaper)
								var/temp=O.loc
								del(O)
								new /obj/reapersummon (temp)
								sleep(10)
								var/mob/S = new/mob/player/Necro/summons/Reaper(temp)
								src.MP -= 150
								src.reaper++
								S.owner=src
								S.HP=S.maxHP
								src<<"\yellow<small>System:</small>\black<small><b><small> You summoned the\red Reaper\black!"
							else
								src<<"\yellow<small>System:</small>\black<small><b><small> You have a\red Reaper\black already!"


			summons
				New()
					for(var/mob/player/Necro/V in world)
						if(src.owner==V)
							src.level=V
					..()
				minion=1
				proc
					Wander(var/mob/NPC/enemies/P)
						while(src)
							if(P in oview(5))
								step_towards(src,P)
								for(P in get_step(src,src.dir))
								//	AttackProc(P,src.damage)
									break
							else
								var/thing=rand(1,5)
								if(thing==1)
									step_card(src)
								sleep(12)
								for(P in oview(5))
									break
							sleep(7)
						spawn(5)
							Wander()


				ShadowMage
					icon='shadow.dmi'
					maxHP=200
					maxMP=0
					mage=1


					name="Shadow Mage"

					weapname="Fire Storm"
					New()
						.=..()
						spawn()
							Wander()

						var/thing=rand(1,2)
						switch(thing)
							if(1)
								src.MAGICtype = /obj/MAGIC/fireball
							if(2)
								src.MAGICtype = /obj/MAGIC/acidball



				Skeleton
					icon='skeleton warrior.dmi'
					maxHP=75
					maxMP=0

					mage=0

					weapname="Rusted Sword"
					New()

						.=..()
						spawn()
							Wander()
				Reaper
					icon='reaper.dmi'
					maxHP=500
					maxMP=0
					mage=0
					New()

						.=..()
						spawn()
							Wander()
