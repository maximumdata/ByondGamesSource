mob
	proc
		checklevel(mob/M)
			if(M.exp>=M.exptolvl)
				M<<"\yellow<small>System:</small>\black<small><I><B><small>You gained a level!"
				M.level++
				M.maxHP += rand(4,8) * M.level
				M.maxMP += rand(2,3) * M.level
				M.exptolvl=round(M.exptolvl*1.5)
				M.HP = M.maxHP  //Reset their HP stats back to full...  In other words, completely heal them.
				M.MP = M.maxMP
				spellcheck(M)
		RegenMP(mob/M)
			while(M.gold != -1)
				var/thing=rand(1,10)
				if(thing==5)
					M.MP+=rand(3,10)
				else ++M.MP
				if(M.MP>M.maxMP)
					M.MP=M.maxMP
				if(M.level<25)
					sleep(25)
				else if(M.level< 50 && M.level>= 25)
					sleep(20)
				else if(M.level>= 50)
					sleep(15)

//13,6,2
		Preattacking(mob/M)    //This will be used if say, the mob has thorns.  In the mob's coding, you set it's Preattacking setting to damage usr.

		Postattacking(mob/M)   //Same, but this time it will do it after damage was dealt and the damage messages are sent.


		deathcheck(mob/M)
			if(M.HP<= 0 || !M.HP)
				if(M.client)
					world<<"\yellow<small>System:</small>\black<small><i><font color = \"[M.fontcolor]\">[M]</font> has been slain by <font color = \"[src.fontcolor]\">[src]</font>'s [src.weapname]!!!"
					src.exp+=round(M.exptolvl/4)
					checklevel(src)
					M.loc=locate(1,1,1)
					M.HP = M.maxHP
				else
					for(var/obj/DROP in M.drops)
						new DROP(M.loc)
					if(M.minion && istype(M,/mob/player/Necro/summons/))
						for(var/mob/player/Necro/Q in world)
							if(M.owner==Q)
								if(istype(M,/mob/player/Necro/summons/Skeleton))
									Q.skeletons--
									Q<<"\yellow<small>System:</small>\black<small><small> You have lost one of your Skeletons!"
								if(istype(M,/mob/player/Necro/summons/ShadowMage))
									Q.mages--
									Q<<"\yellow<small>System:</small>\black<small><small> You have lost one of your\red<small><b> Shadow Mages\black <small><b>has died!"
								if(istype(M,/mob/player/Necro/summons/Reaper))
									Q.reaper--
									Q<<"\yellow<small>System:</small>\black<small><small> You have lost your\red<b> Reaper\black<small><b>!"
								del(M)
								return
					if(M.minion && istype(M,/mob/player/Druid/summons/))
						for(var/mob/player/Druid/Q in world)
							if(M.owner==Q)
								if(istype(M,/mob/player/Druid/summons/Wolf))
									Q.wolves--
									Q<<"\yellow<small>System:</small>\black<small><small> You have lost one of your Wolves!"
								if(istype(M,/mob/player/Druid/summons/Rabbit))
									Q.bunny--
									Q<<"\yellow<small>System:</small>\black<small><small> You have lost your Rabbit!"
								if(istype(M,/mob/player/Druid/summons/Dragon))
									Q.dragon--
									Q<<"\yellow<small>System:</small>\black<small><small> You have lost your\red<small><b> Dragon!"
								del(M)
								return
					if(src.minion)
						for(var/mob/player/Necro/N in world)
							if(src.owner==N)
								N.exp+=M.expgive
								checklevel(N)
								if(M.corpse)
									new /obj/corpse(M.loc)
								del(M)
								checklevel(N)
								return
						for(var/mob/player/Druid/D in world)
							if(src.owner==D)
								D.exp+=M.expgive
								checklevel(D)
								if(M.corpse)
									new /obj/corpse(M.loc)
								del(M)
								checklevel(D)
								return
					if(!src.party)
						src.exp+=M.expgive
						s_damage(src,M.expgive,colour2html(src.fontcolor))
						checklevel(usr)
						src<<"\yellow<small>System:</small>\black<small><small><b> You have slain [M] for [M.expgive] exp!"
						if(M.corpse)
							new /obj/corpse(M.loc)
						del(M)
					else
						var/Groupies = list()       //This will be a list of your group members.
						for(var/mob/player/Pc in world)   //This will check all the PCs in the world.
							if(Pc.party == usr.party)  //If both their party vars are the same (it only is if they are in each other's group..."
								Groupies += Pc          //Add that group member to the Groupies list.
						var/newexp = round(M.expgive / length(Groupies))     //This will define a new var called "newexp."  It is the mobs given experience divided by how ever many group members you have.
						for(var/mob/player/Pc in Groupies)    //For everyone in your group, give them experience like you did when it was just you:
							Pc<<"\yellow<small>System:</small>\black<small><small><b>\red PARTY:\black <small>[src] has slain [M] for [M.expgive] exp, and you get [newexp] of it."
							Pc.exp += newexp
							s_damage(Pc,newexp,colour2html(Pc.fontcolor))
							checklevel(Pc)
							if(Pc.exp >= Pc.exptolvl)
								Pc.exp -= Pc.exptolvl
								Pc.checklevel()
								while(Pc.exp >= Pc.exptolvl)  //Say if you kill a huge mob when your level 1, and the mob's exp_Give is enough to level you 12 times... Well, this is where it works.
									Pc.exp -= Pc.exptolvl  //It takes it down the amount of exp that was needed.
									Pc.checklevel()  //Wow!  You leveled up again!
						if(M.corpse)
							new /obj/corpse(M.loc)
						del(M)

/*
		AttackProc(mob/M, damage)
			if(!M.NPC)
				if(src)
					if(src)//!src.attacking)
						src.Preattacking(M)
						//src.attacking=1

						M.HP -= damage //impact the person directly
						s_damage(M, damage, "red")
						M << "\yellow<small>System:</small>\black<small><small> You were hit for <small>\red<small>[damage]<small>\black<small> points by <font color=\"[src.fontcolor]\">[src]</font>!</i></small>"
						src<< "\yellow<small>System:</small>\black<small><small> You hit <font color=\"[M.fontcolor]\">[M]</font> for <small>\red<small>[damage]\black<small> points!</small>"
						goto thing
						thing
							deathcheck(M)
							sleep(rand(2,8))
							//src.attacking=0
							src.Postattacking(M)
							return
			else
				src<<"\yellow<small>System:</small>\black<small> Can't attack an NPC!!"
*/

		GetSummons(mob/M)
			if(src.class=="Necromancer")
				var/x
				for(x=0;x<M.skeletons;x++)
					var/mob/S = new /mob/player/Necro/summons/Skeleton(M.loc)
					step_rand(S)
					S.owner=M
					S.HP=S.maxHP
				var/y
				for(y=0;y<M.mages;y++)
					var/mob/S = new /mob/player/Necro/summons/ShadowMage(M.loc)
					step_rand(S)
					S.owner=M
					S.HP=S.maxHP
				if(M.reaper)
					var/mob/S = new/mob/player/Necro/summons/Reaper(M.loc)
					step_rand(S)
					S.owner=M
					S.HP=S.maxHP
			if(src.class=="Druid")
				var/f
				for(f=0;f<M.wolves;f++)
					var/mob/S = new /mob/player/Druid/summons/Wolf(src.loc)
					S.owner=src
					S.HP=S.maxHP
				if(src.bunny)
					var/mob/S = new /mob/player/Druid/summons/Rabbit(src.loc)
					S.owner=src
					S.HP=S.maxHP
				if(src.dragon)
					var/mob/S = new /mob/player/Druid/summons/Dragon(src.loc)
					S.owner=src
					S.HP=S.maxHP
