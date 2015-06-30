mob
	player
		Druid
			innate
				verb
					_Unsummon()
						set category="Summon"
						var/thing=list("")
						for(var/mob/player/Druid/summons/S in world)
							if(S.owner==src)
								thing+=S
						thing+="Cancel"
						var/mob/thing2=input("Which creature do you wish to unsummon?") in thing
						if(thing2!="Cancel")
							thing2.HP=0
							deathcheck(thing2)
						else
							return
					Wolf()
						set category="Summon"
						if(src.MP<25)
							usr<<"\yellow<small>System:</small>\black<small><b><small> You need mana for this!"
						else
							if(src.wolves<src.maxwolves)
								var/mob/S = new /mob/player/Druid/summons/Wolf(src.loc)
								src.MP -= 25
								src.wolves++
								S.owner=src
								S.level=src.level
								S.HP=S.maxHP
								src<<"\yellow<small>System:</small>\black<small><b><small> You summon a Wolf!"
							else
								src<<"\yellow<small>System:</small>\black<small><b><small> You have too many Wolves already!"
					Boulder()//mob/M in oview(5))
						set category="Summon"
					//	if(!M.NPC)
						if(src.MP<15)
							usr<<"\yellow<small>System:</small>\black<small><b><small> You need mana for this!"
						else
							var/mob/B = new /mob/Boulder (src.loc)
							B.owner=src
							B.HP=src.level*2
							walk(B,src.dir,6)
							src.MP-=15
							src<<"\yellow<small>System:</small>\black<small><b><small> You create a Boulder!"
			learned
				verb
					Rabbit()
						set category = "Summon"
						if(src.MP<10)
							usr<<"\yellow<small>System:</small>\black<small><b><small> You need mana for this!"
						else
							if(!src.bunny)
								var/mob/S = new /mob/player/Druid/summons/Rabbit(src.loc)
								src.MP-=10
								src.bunny++
								S.owner=src
								S.HP=S.maxHP
								src<<"\yellow<small>System:</small>\black<small><b><small> You summon a Rabbit!"
							else
								src<<"\yellow<small>System:</small>\black<small><b><small> You have a Rabbit already!"

					Dragon()
						set category="Summon"
						if(src.MP<150)
							usr<<"blah"
						else
							if(!src.dragon)
								//new /obj/dragonsummon (temp)
								//sleep(10)
								var/mob/S = new/mob/player/Druid/summons/Dragon(src.loc)
								src.MP -= 150
								src.dragon++
								S.owner=src
								S.HP=S.maxHP
								src<<"\yellow<small>System:</small>\black<small><b><small> You summoned the\red Dragon\black!"
							else
								src<<"\yellow<small>System:</small>\black<small><b><small> You have a\red<small> Dragon\black<small> already!"

			summons
				minion=1
				New()
					.=..()
					for(var/mob/M in world)
						if(src.owner==M)
							M.summons++
				proc
					Wander(var/mob/NPC/enemies/P)
						while(src)
							if(P in oview(5))
								step_towards(src,P)
								for(P in get_step(src,src.dir))
									//AttackProc(P,src.damage)
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


				Wolf
					icon='dog.dmi'
					icon_state="wolf"
					maxHP=115
					maxMP=0


					New()
						step_rand(src)

						.=..()
						spawn()
							Wander()
				Rabbit
					icon='rabbit.dmi'
					maxHP=30


					Wander(var/mob/NPC/enemies/P)
						while(src)
							var/roll2=rand(1,2)
							if(roll2==2)
								step_card(src)
							RabbitHeal()
							for(P in oview(3))
								var/roll=rand(1,2)
								if(roll==1)
									walk_away(src,P,3,5)
							sleep(6)
						spawn(5)
							Wander()

					New()
						step_rand(src)
						.=..()
						spawn()
							Wander()
							RabbitHeal()
					proc
						RabbitHeal()
							for(var/mob/player/Druid/D in world)
								if(src.owner==D)
									D.HP+=D.level*rand(4,6)
									D.MP+=D.level*rand(5,8)
									if(D.MP>D.maxMP)
										D.MP=D.maxMP
									if(D.HP>D.maxHP)
										D.HP=D.maxHP

				Dragon
					icon='dragon.dmi'
					maxHP=500
					maxMP=0

					mage=0

					New()
						step_rand(src)

						.=..()
						spawn()
							Wander()
