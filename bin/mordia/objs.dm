
//objs
turf
	roof
		icon = 'Turfs.dmi'
		icon_state="roof"
		invisibility = 1
		layer = 10
		opacity=1
mob
	Boulder
		icon='boulder.dmi'
		layer=MOB_LAYER+9
		Bump(mob/M)
			if(!istype(M,/mob))
				del(src)
			else
				if(M.NPC)
					for(var/mob/H)
						if(src.owner==H)
							H<<"\yellow<small>System:</small>\black<small><b><small>You can't attack an NPC!!!</b>"
					del(src)
				else
					var/damage = usr.level*rand(4,12)
					M.HP -= damage
					s_damage(M, damage, "red")
					M << "\yellow<small>System:</small>\black<small><small> You were hit for \red<small>[damage]<small>\black<small> points by <font color=\"[src.fontcolor]\">[src]</font>'s boulder!</i></small>"
					for(var/mob/H)
						if(src.owner==H)
							H<<"\yellow<small>System:</small>\black<small><small> Your boulder hit <font color=\"[M.fontcolor]\">[M]</font> for <small>\red<small>[damage]\black<small> points!</small>"
					deathcheck(M)
					del(src)
obj
	fire
		icon='fire.dmi'
		icon_state="2"
		layer=MOB_LAYER+9
		New()
			..()
			sleep(8)
			del(src)
	Flame
		icon='fire.dmi'
		layer=MOB_LAYER+9
	reapersummon
		density=1
		icon='reaper.dmi'
		icon_state="summoned"
		New()
			.=..()
			//for(var/mob/P in view())
				//P<<sound('reapergrowl.wav',0,0,2)
			sleep(15)
			del(src)
	corpse
		icon='corpse.dmi'
		icon_state="DEAD"

	attack
		icon='attack.dmi'

	var
		equipped=0


	weapons

	gold
		var/value
		New()
			..()
			src.value = rand(rand(3,rand(10,rand(12,rand(35,54)))),rand(10,rand(14,rand(24,rand(40,100)))))
		name = "Gold"
		icon='boulder.dmi'
		verb
			Get()
				set src in oview(1)
				set category="Actions"
				if(!usr.party)
					usr.gold += src.value
					usr<<"\yellow<small>System:</small>\black<small> <B>You picked up [src.value] piece\s of gold!</b>"
				else
					var/partymembers=list()
					for(var/mob/player/Pc in world)   //This will check all the PCs in the world.
						if(Pc.party == usr.party)  //If both their party vars are the same (it only is if they are in each other's group..."
							partymembers += Pc
					var/newval=round(src.value / length(partymembers))
					for(var/mob/player/PC in partymembers)
						PC.gold+=newval
						if(PC!=usr)
							PC<<"\yellow<small>System:</small>\black<small><small> [usr] picked up [src.value] piece\s of gold, and you get [newval]!</b>"
						else
							PC<<"\yellow<small>System:</small>\black<small><small> You picked up [src.value] piece\s of gold, and you get [newval] after sharing with the party!</b>"
				del(src)

	items
		var
			dur=10
			maxdur=10
		verb
			Drop()
				set category="Actions"
				if(src.equipped)
					usr<<"\yellow<small>System:</small>\black<small> You can't drop this if it's equipped!"
				else
					usr << "\yellow<small>System:</small>\black<small> You drop the [src]!"
					src.loc = usr.loc
			Get()
				set category="Actions"
				set src in oview(1)
				usr << "\yellow<small>System:</small>\black<small> You get the [src]!"
				usr.contents += src
	/*	armor
			var
				hitloc
				AC = 15
				namehold

				pierce_deflection = 20 //20 % deflection
				pierce_reduction = 3   //3 point reduction
				pierce_absorption = 20 //20 % absorption

				MAGIC_deflection = 0   //0 % deflection
				MAGIC_reduction = 0
				MAGIC_absorption = 0

				blunt_deflection = 30
				blunt_reduction = 5
				blunt_absorption = 40

				slash_deflection = 50
				slash_reduction = 10
				slash_absorption = 6


			verb
				Equip()
					set category="Actions"

					if(src.dur)
						if (src.equipped == 1)
							usr << "\yellow<small>System:</small>\black<small> You already have this equipped!"
						else
							if(usr.armor)
								usr<<"\yellow<small>System:</small>\black<small> You are already wearing armor! Remove that one first!"
							else
								src.namehold=src.name
								usr << "\yellow<small>System:</small>\black<small> You wear the [src]."
								src.name = src.name+" \[Equipped]"
								usr.defense += src.AC
								src.equipped = 1
								usr.equiplist+=src
								usr.armor=1
					else
						usr<<"\yellow<small>System:</small>\black<small> You must repair this first!!!"

				Unequip(obj/items/armor/O in usr.equiplist)
					set category="Actions"

					if (O.equipped == 1)
						O.name = src.namehold
						usr << "\yellow<small>System:</small>\black<small> You remove the [O]."
						usr.defense -= O.AC
						O.equipped = 0
						usr.equiplist-=O
						usr.armor=0
					else
						usr << "\yellow<small>System:</small>\black<small> You aren't wearing that!"

			fullplate
				name = "Full Plate"
				icon = 'armor.dmi'
				icon_state = "fullplate"
				hitloc="torso"
				dur = 100
				maxdur=100

				pierce_deflection = 30 //20 % deflection
				pierce_reduction = 25 //3 point reduction
				pierce_absorption = 25 //20 % absorption

				MAGIC_deflection =10   //0 % deflection
				MAGIC_reduction = 15
				MAGIC_absorption = 5

				blunt_deflection = 45
				blunt_reduction = 34
				blunt_absorption = 60

				slash_deflection = 50
				slash_reduction = 28
				slash_absorption = 45



*/