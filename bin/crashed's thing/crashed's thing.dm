mob
	icon='thing.dmi'
	icon_state="mob"
	npc
	npc2

obj
	icon='thing.dmi'
	icon_state="bullet"
	var
		power=10
		//power...i'm not too sure about this part
		//maybe make power the largest possible number of tiles
		//a mob will be seeing on the map at any given time
		//that way, every bullet will be affected by movement
		//unless you can think of a better way to handle power??
		force
		//leave the power the same for each bullet, but set the
		//force for each different bullet seperately..
		//i.e. an ak47 bullet, an RPG, a handgun...etc
	handgun
		icon_state="gun"
		verb
			Get()
				set src in oview(1)
				src.Move(usr)
			Shoot()//mob/M in world)//you probably will want to change this to in oview(src)
				//just make a bullet, and send it on it's way
				//the bullet's proc's take care of everything else
				var/obj/B= new /obj/HGbullet(usr)
				walk(B,usr.dir,3)
				//s_missile(B,usr,M,3)

	HGbullet
		force=3
		//make sure they are dense, so their Bump proc will work
		density=1
		Move()
			//for every time it moves, decrease it's power
			//this would make a point blank shot the most powerful
			src.power--
			..()
			/*if(src.x==world.maxx||src.y==world.maxy)
				if(src.dir==NORTH||src.dir==EAST)
					sleep(4)
					del(src)
			if(src.x==1||src.y==1)
				if(src.dir==SOUTH||src.dir==WEST)
					sleep(6)
					del(src)*/
		//using the Bump proc to control damage means you must actually wait for
		//s_missile to do it's thing before damage is calculated, instead of a
		//noobish calculation before the "bullet" has even hit it's target.
		Bump(mob/M)
			if(ismob(M))
				//well this is the simple equation you wanted,
				//but it's simple because the move proc handles
				//the details. :-/
				var/damage=src.power*src.force
				for(var/mob/Q in world)
					Q<<"power:[src.power] force:[src.force] damage:[damage]"
				del(src)
			else
				del(src)


/*
var/list/Nuke_Nation=list()
obj/Nuke
	icon='thing.dmi'
	icon_state="bullet"
mob
	verb
		Launch_Nuke()
			Nuke_Nation=list("")
			for(var/mob/MOB in world)
				Nuke_Nation+=MOB.Nation
			var/mob/M=input("Who would you like to launch a nuclear missile at?") in Nuke_Nation
			switch(input("Are you sure you wish to launch a nuclear missile to [M]?") in list ("Yes","No"))
				if("Yes")
					missile(/obj/Nuke, src,M.loc)
					return 0
				else return

*/