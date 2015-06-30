obj
	icon='guns.dmi'
	verb
		Get()
			set src in oview(0)
			set hidden=1
			var/oldloc=src.loc
			src.Move(usr)
			usr<<"You pick up \a [src.name]."
			spawn(75)
				if(src.regen)
					new src.type(oldloc)
	aoknig
		icon_state="SG"
	var
		regen=1
		owner
		//don't want to be hitting ourselves with out own bullets
		power=11
		//power...i'm not too sure about this part
		//maybe make power the largest possible number of tiles + 1
		//a mob will be seeing on the map at any given time
		//that way, every bullet will be affected by movement
		//and the + 1 will make the bullet strength 10 at point blank
		//unless you can think of a better way to handle power??
		force
		//leave the power the same for each bullet, but set the
		//force for each different bullet seperately..
		//i.e. an ak47 bullet, an RPG, a handgun...etc
		rate
		//this will be different for each gun as well,
		//it is simply the rate of fire, or how fast you
		//can shoot the gun in succession
	proc
		Fire()
	guns
		Get()
			set src in oview(0)
			set hidden=1
			var/oldloc=src.loc
			if(istype(src,/obj/guns/handgun))
				if(!usr.hasHG)
					src.Move(usr)
					usr<<"You picked up a [src.name]"
					usr.hasHG=1
					if(usr.autoswitch)
						usr.SwitchToHG()
				else
					usr<<"You already have a [src.name]!"
			if(istype(src,/obj/guns/machinegun))
				if(!usr.hasMG)
					src.Move(usr)
					usr<<"You picked up a [src.name]"
					usr.hasMG=1
					if(usr.autoswitch)
						usr.SwitchToMG()
				else
					usr<<"You already have a [src.name]!"
			if(istype(src,/obj/guns/knife))
				if(!usr.hasKnife)
					src.Move(usr)
					usr<<"You picked up a [src.name]"
					usr.hasKnife=1
					if(usr.autoswitch)
						usr.SwitchToFists()
				else
					usr<<"You already have a [src.name]!"
			if(src.loc==usr)
				spawn(50)
					new src.type(oldloc)
		fists
			name="Fists"
			icon_state="FISTS"
			DblClick()
				if(src in usr)
					usr.SwitchToFists()
			New()
				src.rate=rand(7,15)
			Fire()
				for(var/mob/M in get_step(usr,usr.dir))
					var/damage=rand(3,12)
					M.hp-=damage
					s_damage(M, damage,"red")
					death(M,usr)
		knife
			name="Knife"
			icon_state="KNIFE"
			DblClick()
				if(src in usr)
					usr.SwitchToFists()
			New()
				src.rate=rand(4,7)
			Fire()
				for(var/mob/M in get_step(usr,usr.dir))
					var/obj/KNIFE=/obj/knifeimage
					new KNIFE(M.loc)
					var/damage=rand(8,17)
					M.hp-=damage
					s_damage(M, damage,"red")
					death(M,usr)
		handgun
			name="Hand Gun"
			icon_state="HG"
			rate=7//rate of fire..
			//this is just a variable to change from 0 to 1
			//it will allow the user to shoot based on the
			//rate of the weapon. it's best to define this
			//under each gun, that way, if you fire one weapon,
			//then switch to a new one, you will be able to fire
			//the new one right away

			Fire()
				//just stall the user from shooting too fast
				//using it's rate, and the shooting variable
				//just make a bullet, and send it on it's way
				//the bullet's proc's take care of everything else
				var/obj/B= new /obj/bullets/HGbullet(usr.loc)
				B.owner=usr
				walk(B,usr.dir,1)
				//this will make the bullet move on a path directly
				//in front of the user
			DblClick()
				if(src in usr)
					usr.SwitchToHG()
		machinegun
			name="Machine Gun"
			icon_state="MG"
			rate=2
			DblClick()
				if(src in usr)
					usr.SwitchToMG()
			Fire()
				var/obj/B= new /obj/bullets/MGbullet(usr.loc)
				B.owner=usr
				walk(B,usr.dir,1)
		shotgun
			name="Shotgun"
			icon_state="SG"

	bullets
		//make sure they are dense, so their Bump proc will work
		density=1
		icon_state="bullet"
		Move()
			//for every time it moves, decrease it's power
			//this would make a point blank shot the most powerful
			src.power--
			if(src.power<=0)
				del(src)
			..()
		//using the Bump proc to control damage means you must actually wait for
		//walk() to do it's thing before damage is calculated, instead of a
		//noobish calculation before the "bullet" has even hit it's target.
		Bump(M)
			if(ismob(M))
				var/mob/MOB = M
				if(MOB!=src.owner)
					//well this is the simple equation you wanted,
					//but it's simple because the move proc handles
					//the details. :-/
					var/damage=src.power*src.force
					damage=round(damage/2)
					//world<<"power:[src.power] force:[src.force] damage:[damage]"
					s_damage(MOB, damage,"red")
					MOB.hp-=damage
					death(MOB,src.owner)
					del(src)
				else
					del(src)
			else
				if(istype(M,/obj/bullets))
					src.density=0
					sleep(1)
					src.density=1
				//del(src)
		HGbullet
			force=3
			New()
				..()
				for(var/mob/M in view(src))
					if(M.sound)
						M<<sound("sounds/HG.wav")
		MGbullet
			force=2
			New()
				..()
				for(var/mob/M in view(src))
					if(M.sound)
						M<<sound("sounds/MG.wav")

//images
	knifeimage
		icon_state="KNIFE"
		layer=MOB_LAYER+10
		New()
			src.dir=usr.dir
			..()
			spawn(5)
				del(src)
