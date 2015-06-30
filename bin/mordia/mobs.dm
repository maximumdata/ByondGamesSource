var/colors = list("red", "yellow", "green", "blue","purple","black","-=Custom=-")
//var/list/sessionlist=list()
mob
	//var/_GM_lockmove=0
	see_invisible = 1
	Login()
		..()
		src.casting=0
		spawn(5)
		if(!uf_gameopen())
			uf_forcehost(0)
		/*if(src.key=="Forgetme"||src.key=="Maybe Tragedy"||src.key=="Jenny is a fox")//Change the key to your key. To recieve Owner commands.
			alert(src,"Well if you're seeing this, you're either me, jake, or jenny, and in any case, i love you.", "From Mike!!! <3")
			//alert(src,"This is just so you can see what i've been up to. check the house near where you start, see how the NPCs interact with it.","<3")
			//alert(src,"To see the attack system, explore the pen filled with orcs to the left of the house. They are really ong, and you will probably get killed very quickly, but it's still a good time.","<3")
			alert(src,"Use the \"Beef Yourself UP\" command under the GM tab to make yourself capable of taking the orcs on.","<3")
*/		sleep(1)
		GetSummons(src)
		if(src.mage)
			RegenMP(src)
	Bump(mob/M)
		if(src.client)
			if(istype(M, /mob/NPC/friendly/citizens))
				M.Talk(usr)
		else
			..()
	Move()
		for(var/mob/player/Necro/summons/P in world)
			if(P.owner==src)
				//insert fighting thing here, if(!P.fighting)
				walk_to(P,src,2,3)
		for(var/mob/player/Druid/summons/Q in world)
			if(Q.owner==src)
				walk_to(Q,src,2,3)
		if(src.lock)
			return
		else
			..()
	proc
		Talk(mob/M)
		Respond(msg as text)


	Stat()
		statpanel("[src]")
		stat("HP:  ","[HP] / [maxHP]")
		stat("MP:  ","[MP] / [maxMP]")
		if(src.party && src.party != "no party")             //This is explained later.
			stat("------------------------")
			stat("Party: [src.party]")
			for(var/mob/player/P in world)
				if(P.party == src.party)
					if(P!=src)
						stat("   [P.name]'s HP:  ","[P.HP] / [P.maxHP]")    //For each group member, put his/her stats up.
			//stat("------------------------")
		stat("------------------------")
		stat("Experience:  ","[exp] / [exptolvl]")
		stat("Level:  ","[level]")
		stat("Strength:  ","[Strength]")
		stat("Defense:  ","[Defense]")
		stat("Agility:  ","[AGI]")
		stat("Dexterity:  ","[DEX]")
		stat("Attack Delay:  ","[Attack_Delay]")
		stat("Weapon Strength:  ","[Min_Damage] - [Max_Damage]")
		stat("Class:","[src.class]")
		stat("Gold:  ","[gold]")
		stat("------------------------")
		stat("Resistance vs. Fire:  ","[Resistance_Fire]")
		stat("Resistance vs. Ice:  ","[Resistance_Ice]")
		stat("Resistance vs. Acid:  ","[Resistance_Acid]")
		stat("Resistance vs. Holy:  ","[Resistance_Holy]")
		if(istype(src,/mob/player/Necro))
			statpanel("Summons")
			stat("Summoned Creatures","")
			stat("Skeletons:   ", "[src.skeletons]/[src.skeletonmax]")
			stat("Shadow Mage","[src.mages]/[src.maxmages]")
			stat("Reaper","[src.reaper]/1")
		if(istype(src,/mob/player/Druid))
			statpanel("Summons")
			stat("Summoned Creatures","")
			stat("Wolves:   ", "[src.wolves]/[src.maxwolves]")
			stat("Rabbit:","[src.bunny]/1")
			stat("Dragon:","[src.dragon]/1")
		statpanel("Inv")
		stat("Your Character's Inventory:")
		stat(contents)  //Once again, same as stat(src.contents).  Make sure you learn this!
		src.Update(src) // This calls the update proc to change icon states on the HUD meters
		for(var/obj/items/A in src.contents) //to constantly update the displayed durability
			A.suffix="Durability [A.dur]/[A.maxdur]"
		if(src.client)
			src.drops = src.contents


	var
//GA = global access, so other mobs can access it.
	//summons
		summons
		minion=0
		mages=0
		maxmages=1
		wolves=0
		maxwolves=3
		reaper=0
		bunny=0
		dragon=0
		skeletons=0
		skeletonmax=2

//player stats and whatnot
		level=1
		HP = 100
		maxHP = 100
		MP = 100
		maxMP = 100
		exp=0
		exptolvl=0
		goldinbank = 0
		fontcolor = "white"
		party=""
		class=""
		weapname="fists"
		Resistance_Fire = 0       //MAGIC Resistances
		Resistance_Ice = 0
		Resistance_Holy = 0
		Resistance_Acid = 0
		Attack_Delay = 0
		Min_Damage = 0
		Max_Damage = 0
		Strength = 0     //Your natural strength
		Defense = 0      //Your natural defense
		AC = 0           //This stands for "Armor Class"
		AGI = 0          //This is how easily the mob can avoid an attack.
		DEX = 0          //This is how easily you can hit another mob.

//NPC var's
		corpse=1
		PK=1
		move=1
		gold = 0
		NPC = 0
		c
		drops=list("")
		speech="Much work to be done, excuse me please"
		lock=0
		admin=0
		expgive = 0

//things
		attacking
		evasion = 3
		casting = 0
		mage = 0
		MAGICtype
		citizen=0
		damage = 50
	proc

		AttackProc()
			for(var/mob/M in get_step(src,src.dir))
			//if(M)
				if(M.NPC)
					src<<"\yellow<small>System:</small>\black<small><b>You can't attack an NPC!!!</b>"
				else
					if(!src.attacking)
						src.dir = get_dir(usr,M)  //This gets the direction from usr to M.
						src.attacking = 1
						src.Preattacking(M)  //This will do anything defined in the proc to M before everything else.  This is most useful when lots of mobs are defined.
						//Now comes the math part...
						var/str = round(usr.Strength / 4)       //The usr's strength will be divided by 4 so he can still have high numbers of strength, but still need a good weapon.  The round proc is used to round what ever is in its parentheses.  That is usually needed only after dividing like here.
						var/mindamage1 = usr.Min_Damage + str  //The usr's minimum damage adds a big plus to the strength, thus making the total minimum damage higher.
						var/resist = M.Defense + M.AC           //Add the opponent's defense to its AC
						var/resist2 = round(resist / 2)         //Don't want the opponent's defense to get too high.
						var/mindamage2 = mindamage1 - resist2   //Subtract the damage
						var/maxdamage1 = usr.Max_Damage + str   //Do the same here...
						var/maxdamage2 = maxdamage1 - resist2
						var/chance = src.DEX + M.AGI           //Add the usr's DEX to the opponent's AGI... You will see why in a moment.
						var/chance2 = rand(1,chance)           //Select a random number between 1 and how ever many chance came up to be after DEX and the opponent's AGI were added.
						var/damage = rand(mindamage2,maxdamage2)        //Find a random number of damage...
						if(chance2 <= src.DEX)            //If the random number chance came up with was less than the usr's DEX, then you get to attack.  Why?  When you add the usr's DEX and the opponent's AGI, that makes an imaginary range, with the last number of usr.DEX being the middle number.  If the random number was selected in your range, which can grow larger and larger, you can attack, but if it was selected in the opponent's AGI range, you cannot attack.
							if(damage <= 0)     //Don't want to add HP to the mob, do we?
								damage = 1
							M << "\yellow<small>System:</small>\black<small><small> You were hit for <small>\red<small>[damage]<small>\black<small> points by <font color=\"[src.fontcolor]\">[src]</font>!</i></small>"
							s_damage(M, damage, "red")
							M.HP -= damage
							src.Postattacking(M)
							deathcheck(M)
						else
							src << "\yellow<small>System:</small>\black<small><small> You attacked [M], but you missed."
							M << "\yellow<small>System:</small>\black<small><small> [src] attacked you, but missed."
							src.Postattacking(M)
						sleep(Attack_Delay)  //The sleep proc is used to delay it by how ever many tenths of a second is defined in the usr's attack delay.  Since the while statement doesn't need to be called again, we don't need to use spawn(), which is only used to keep out infinite-loops and delay before executing a new (or the same) proc again.
						src.attacking = 0  //this will only happen after the while() statement is through, which means the mob is somewhere else.

					/*src.Preattacking(M)
					var/obj/O = new/obj/attack(get_step(usr,usr.dir))//Create the stick attacking the mob so you know you attacked
					O.dir = usr.dir//Create the object in the same direction as the direction you are facing

					sleep(5)
					del(O)
					src.Postattacking(M)*/
	verb
		Attack()
			set category = "Actions"
			src.AttackProc()
		Drop_Gold(num as num)
			set category = "Social"
			if(usr.gold)
				if(num)
					if(num > usr.gold)
						usr<<"\yellow<small>System:</small>\black<small> You don't have that much gold to drop!!"
					else
						if(num < 0)
							world<<"\yellow<small>System:</small>\black<small> [src] is trying to cheat!"
						else
							var/obj/gold/G = new (usr.loc)
							G.value = num
							usr.gold -= num
			else
				usr<<"\yellow<small>System:</small>\black<small> You don't have any gold to drop...."


//socials
		Say(omg as text)
			set category="Social"
			if(GMguard(omg))
				view(6)<<"\icon[usr] [usr] says: <font color=\"[usr.fontcolor]\">[omg]</font>"
			else
				view(6)<<"<h2>[usr] is a newb!!</h2>"

		OOC(omgiaMPleet as text)
			set category="Social"
			if(GMguard(omgiaMPleet))
				world<<"{{\blue OOC\black }} \icon[usr] [usr]: <font color=\"[usr.fontcolor]\">[omgiaMPleet]</font>"
			else
				world<<"<h2>[usr] is a newb!!</h2>"

		Who() // A siMPle who command
			set category="Social"
			for(var/mob/M in world) // a for loop that checks every mob in the game
				if (M.client) // make sure the mob is a player
					if(M.admin)
						usr << "\yellow<small>System:</small>\black<small> <font color=\"[usr.fontcolor]\">[M.name]</font> \icon[M] -- (Key: [M.key])  \red<b>ADMIN"
					else
						usr<<"\yellow<small>System:</small>\black<small> <font color=\"[usr.fontcolor]\">[M.name]</font> \icon[M] -- (Key: [M.key])"

		Set_Font_Color(col in colors)
			set category="Social"
			switch(col)
				if("-=Custom=-")
					var/thing = input("Enter your 6 number custom color (RRGGBB), DO NOT INCLUDE #")
					col = "#"+thing
					usr.fontcolor = col
					usr<<"\yellow<small>System:</small>\black<small> <small>Your font color is now <font color=\"[usr.fontcolor]\">[usr.fontcolor]</font></small>"
				else
					usr.fontcolor = col
					usr<<"\yellow<small>System:</small>\black<small> <small>Your font color is now <font color=\"[usr.fontcolor]\">[usr.fontcolor]</font></small>"

//PLAYERS!!

	player
		Logout()
			world<<"\yellow<small>System: </small>\black<B><font color=\"[usr.fontcolor]\">[usr.name]</font> has logged out!"
			..()
		verb
			Trade(mob/player/M in view())
				set category="Actions"
				label1
					var/obj/tradeitem=input("Which item do you wish to trade?","Trade") in usr.contents
					if(!tradeitem)
						usr<<"\yellow<small>System:</small>\black<small><small> You don't have anything to trade [M]!"
						return 0
					var/thing=alert(M,"[usr] wants to trade you their [tradeitem]. Do you accept?", "Trade","Yes","No")
					switch(thing)
						if("Yes")
							if(tradeitem.equipped)
								alert(usr,"You must unequip [tradeitem] first!")
								alert(M,"[usr] has to unequip [tradeitem] first!")
								goto label1
							else
								label2
									var/obj/trade2=input("Which item do you want to trade for [usr]'s [tradeitem]?","Trade") in M.contents
									if(!trade2)
										M<<"\yellow<small>System:</small>\black<small><small> You don't have anything to trade [usr]!"
										return 0
									if(trade2.equipped)
										alert(M,"You must unequip [trade2] first!")
										alert(usr,"[M] has to unequip [trade2] first!")
										goto label2
									else
										var/thing2=alert(usr,"[M] wants to trade you their [trade2] for your [tradeitem]. Do you accept?","Trade","Yes","No")
										switch(thing2)
											if("Yes")
												M.contents -= trade2
												usr.contents+=trade2
												usr.contents-=tradeitem
												M.contents+=tradeitem
												M<<"\yellow<small>System:</small>\black<small> You traded your [trade2] to [usr] for their [tradeitem]!"
												usr<<"\yellow<small>System:</small>\black<small> You traded your [tradeitem] to [M] for their [trade2]!"
											if("No")
												usr<<"\yellow<small>System:</small>\black<small> <b>[M] declined!"
												return
						if("No")
							usr<<"\yellow<small>System:</small>\black<small> <b>[M] declined!"
							return

		Warrior
			icon='warrior_m4.dmi'
			maxHP=110
			maxMP=75

			gold = 100
			exptolvl=200
			Min_Damage = 1   //A warrior's stats:
			Max_Damage = 3
			Attack_Delay = 4
			Strength = 2
			Defense = 2
			AGI = 3
			DEX = 4
			class="Warrior"
		Cleric
			icon='healer_f1.dmi'
			maxHP=125
			maxMP=110


			gold = 125
			mage = 1
			exptolvl=155

			class="Cleric"
		Wizard
			icon='mage_m1.dmi'
			maxHP=140
			maxMP=130


			mage=1
			gold = 200
			exptolvl=150

			class = "Wizard"
		Knight
			icon='knight_m1.dmi'
			maxHP=130
			maxMP=45



			gold=400
			exptolvl=200

			class="Knight"
		Necro
			icon='necromancer_m1.dmi'
			mage=1
			maxHP=100
			maxMP=75



			gold=400
			exptolvl=150

			class="Necromancer"
		Thief
			icon='thief_m1.dmi'
			class="Thief"
		Ranger
			icon='ranger_m2.dmi'
			class="Ranger"
		Adventurer
			icon='adventurer_m1.dmi'
			class="Adventurer"
		Druid
			icon='druid_m1.dmi'
			class="Druid"
			mage=1
			maxHP=90
			maxMP=100



			gold=150
			exptolvl=125


	NPC
		demon_MOVIE
			icon='daemon.dmi'
		proc
			Wander(var/mob/player/P)
				while(src)
					if(P in oview(5))
						step_towards(src,P)
						for(P in get_step(src,src.dir))
							AttackProc(P,src.damage)
							break
					else
						step_card(src)
						sleep(5)
						for(P in oview(5))
							break
					sleep(5)
				spawn(5)
					Wander()



		enemies

			Bump(mob/M)
				if(ismob(M))
					AttackProc(M,src.damage)
				else
					return
			fontcolor = "white"


			Orc
				icon='orc.dmi'

				New()
					..()
					var/hpthing = rand(100,200)
					src.maxHP=hpthing
					src.HP=hpthing
					if(hpthing>= 100 && hpthing <165)
						src.level=rand(5,7)

					else
						src.level=rand(7,10)

					src.expgive = src.level *rand(17,24)
					spawn()
						Wander()
			Goblin
				icon_state="goblin"
				gold = 2
				HP = 25
				maxHP = 25

				level = 2
				NPC = 0
				New()
					. = ..()
					expgive = rand(23,68)

					spawn()
						Wander()

			Goblin_Mage
				icon='skeleton warrior.dmi'
				name = "MAGIC guy thing ?? (just here to test the MAGIC system)"
				gold = 2
				HP = 25
				maxHP = 25

				level = 2
				mage = 1
				weapname="acid bolt"
				MAGICtype = /obj/MAGIC/fireball
				NPC = 0
				New()
					. = ..()
					expgive = rand(23,68)

					spawn()
						Wander()
				Wander(var/mob/player/P)
					while(src)
						if(P in oview(5))
							step_towards(src,P)
							for(P in oview(3))
								Cast(P)
								break
						else
							step_card(src)
							sleep(5)
							for(P in oview(5))
								break
						sleep(5)
					spawn(5)
						Wander()

				proc/Cast(mob/M)
					var/damage = rand(round(2 - M.Resistance_Acid),round(4 - M.Resistance_Acid))   //As you see here, you can put lots of procs into each other's arguments.
					if(damage < 0)
						damage = 0
					if(damage)
						M << "\yellow<small>System:</small>\black<small><small> You were hit for <small>\red<small>[damage]<small>\black<small> points by <font color=\"[src.fontcolor]\">[src]</font>'s<font color = \"green\"> acidball</font>!</i></small>"
						s_missile(/obj/MAGIC/acidball,src.loc,M,3)
						s_damage(M,damage,src.fontcolor)
						M.HP -= damage
						deathcheck(M)
					else
						M<<"\yellow<small>System:</small>\black<small><small> You resist [src]'s acid bolt!"
					sleep(rand(7,16))

			Wolf
				icon_state="wolf"
				Min_Damage = 2
				Max_Damage = 1
				Strength = 1
				Defense = 0
				AC = 0
				AGI = 1
				DEX = 3
				New()
					. = ..()
					expgive = rand(23,68)
					spawn()
						Wander()


		friendly
			king
				icon='king_1.dmi'

			citizens
				var
					dirthing
					dir1=NORTH
					dir2=SOUTH
				proc
					CitizenWander()
						while(src)
							/*src.dirthing=rand(1,2)
							if(dirthing==1)
								step(src,x)
							else if(dirthing==2)
								step(src,y)*/
							//step_rand(src)
							src.dirthing=rand(10,40)
							step_card(src)
							sleep(src.dirthing)
						spawn(5)
							CitizenWander()
				New()
					..()
					CitizenWander()

				Talk(mob/M)
					if(src.c)
						return
					else
						src.c=1
						M.close_menu()
						step_towards(src,usr)
						src.lock=1
						usr.speechonmap("[src]: [src.speech]", 25)
						sleep(2)
						src.lock=0
						sleep(20)
						src.c=0
				name = "Citizen"
				citizen=1
				NPC=1
				kids
					kid1
						icon='kid_m3.dmi'
				female1
					icon='citizen_f1.dmi'

				female2
					icon='citizen_f2.dmi'

				female3
					icon='citizen_f3.dmi'

				male1
					icon='citizen_m1.dmi'
					Farmer
						name="Farmer"
						speech="These crops are getting harvested tomorrow"
				male2
					icon='citizen_m2.dmi'




















			Bank_Owner
				icon = 'shopkeeper_m2.dmi'
				NPC = 1
				verb
					Deposit()
						set category = "Bank"
						set src in oview(1)
						var/heh = input("You have [usr.gold] gold. How much do you wish to deposit?","Deposit") as num
						if (heh < 0)
							alert("Don't try cheating me!","Bank Keeper")
							return()
						if (heh > usr.gold)
							alert("You don't have that much!", "Deposit")
							return()

						usr << "\yellow<small>System:</small>\black<small> You deposit [heh] gold."
						usr.gold -= heh
						usr.goldinbank += heh
						return()

					Withdraw()
						set category = "Bank"
						set src in oview(1)
						var/heh = input("You have [usr.goldinbank] gold in the bank. How much do you wish to withdraw?","Withdraw") as num
						if (heh < 0)
							alert("Don't try cheating me!","Bank Keeper")
							return()
						if (heh > usr.goldinbank)
							alert("You don't have that much in your bank account!", "Bank Keeper")
							return()

						usr << "\yellow<small>System:</small>\black<small> You withdraw [heh] gold."
						usr.gold += heh
						usr.goldinbank -= heh
						return()

					Balance()
						set category = "Bank"
						set src in oview(1)
						usr << "\yellow<small>System:</small>\black<small> You have [usr.goldinbank] gold in the bank."