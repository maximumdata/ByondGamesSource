mob
	player
		icon='mob.dmi'
		icon_state="player"
	npc
		icon='thing.dmi'
		icon_state="mob"
		Respond(mob/M,msg as text)
			if(findText(msg, "jigger")||findText(msg, "Hi"))
				src.Say("I need it nigga!!")
		npc2

	enemies
		icon='thing.dmi'
		icon_state="mob"
		npc

	var
	//stats
		hp=100
		maxhp=100
		kills=0
		ID=0
	//weapons
		obj/current_weapon=/obj/guns/handgun
		weapname="Hand Gun"
		shooting
		hasHG=0
		hasMG=0
		hasKnife=0
		hasSG=0
	//options
		autoswitch=1
		admin=0
		sound=1
		asking=0
	//movement
		moving=0
		stamina=50
		maxstam=50
		running=0
	//lists
		list


	Stat()
		if(src.ID)
			statpanel("#[src.ID]")
			stat("Current Weapon:","[src.weapname]")
			stat("Health / Max Health:","[src.hp]/[src.maxhp]")
			stat("Stamina:","[src.stamina]/[src.maxstam]")
			stat("Kills:","[src.kills]")
			statpanel("Weapons")
			for(var/obj/guns/GUN in src.contents)
				stat(GUN)
			var/list/ok=list()
			for(var/obj/OK in src.contents)
				if(!istype(OK,/obj/guns))
					ok+=OK
			if(ok.len)
				statpanel("Inventory")
				for(var/obj/OK in ok)
					stat(OK)


	verb
		Shoot()
			set hidden = 1
			var/obj/shooting= new src.current_weapon
			if(src.shooting)
				return
			else
				src.shooting=1
				shooting.Fire()
				sleep(shooting.rate)
				src.shooting=0
			del(shooting)
		SwitchToFists()
			set hidden=1
			if(src.weapname!="Knife"&&src.hasKnife)
				src.weapname="Knife"
				src.current_weapon=/obj/guns/knife
				src<<"Using: Knife"
				src.shooting=0
			else
				if(src.weapname!="Fists")
					src.weapname="Fists"
					src.current_weapon=/obj/guns/fists
					src<<"Using: Fists"
					src.shooting=0
		SwitchToMG()
			set hidden=1
			if(src.hasMG)
				if(src.weapname!="Machine Gun")
					src.current_weapon=/obj/guns/machinegun
					src.weapname="Machine Gun"
					src<<"Using: Machine Gun"
					src.shooting=0
			else
				src<<"You don't have a machine gun!"
		SwitchToHG()
			set hidden = 1
			if(src.hasHG)
				if(src.weapname!="Hand Gun")
					src.current_weapon=/obj/guns/handgun
					src.weapname="Hand Gun"
					src<<"Using: Hand Gun"
					src.shooting=0
			else
				src<<"You don't have a hand gun!"
		Drop()//obj/O in src.contents)
			set hidden=1
			var/obj/list/items=list()
			for(var/obj/K in src.contents)
				if(!istype(K,/obj/guns))
					items+=K
			var/obj/O=input("Which item to drop?","Drop")in items
			if(istype(O,/obj/guns))
				src<<"You can't drop a weapon!"
				return
			if(O)
				src<<"You drop \an [O.name]."
				O.Move(src.loc)
		Run()
			set hidden=1
			if(src.running)
				src.running=0
				src<<"You are now walking"
				stamrech()
			else
				src.running=1
				src<<"You are now running"
	//social
		Say(arg as text)
			set hidden=1
			if(arg)
				if(src.ID)
					//var/msg=specialchars(arg)
					world<<"<b>Patient #[src.ID]<small> ([src.name])</small>:</b> [html_encode(arg)]"//[html_decode(msg)]"
					for(var/mob/M in oview(src))
						if(!istype(M,/mob/player))
							M.Respond(src, arg)
				else
					if(src.z!=11)
						world<<"<b><small>[src.name]</small>:</b> [arg]"


//override base procs here
	Login()
		src.loc = locate(5,5,11) // change to your title screen
		src.shooting=0
		src.icon_state="blank"
		world<<"\red <h2>[src] has joined the madness.<br>"
		RandMove(src)
		..()

	Logout()
		world<<"\red <h2>[src] has left.<br>"
		Save(src)
		..()
/*
	//this is how to use the cone proc. make a flame thrower out of this
	verb
		thing()
			for(var/turf/T in cone(src, src.dir,oview(src)))
				new/obj/bullets/HGbullet(T)*/