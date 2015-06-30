
proc
	Gravity(var/mob/per)
		if(per.dir == EAST)
			if(per.inair == 1)
				var/turf/check = locate(per.x,per.y-1,per.z)
				if(check.density == 1)
					per.inair = 0
					return
				else
					per.loc=locate(per.x,per.y-1,per.z)
					sleep(2)
					Gravity(per)
			else
				return 0
		if(per.dir == WEST)
			if(per.inair == 1)
				var/turf/check = locate(per.x,per.y-1,per.z)
				if(check.density == 1)
					per.inair = 0
					return
				else
					per.loc=locate(per.x,per.y-1,per.z)
					sleep(2)
					Gravity(per)
			else
				return 0

world
	turf = /turf/grass
	mob = /mob/crashed
	loop_checks=0
	name = "Crashed: A Day In The Life"

turf
	grass
		icon = 'grass.dmi'
	wall
		icon = 'wall.dmi'
		density = 1
	black
		icon = 'black.dmi'
		density = 1
		name = ""
	win
		Entered(mob/M)
			..()
			world<<"FUCKING [M] FUCKING WON SHIT"
			M.loc = locate(2,1,1)
mob
	var
		inair
	crashed
		icon = 'mob.dmi'
	Login()
		src.client.mob.dir = EAST
		src.inair = 0
		src.loc=locate(1,2,1)

client
	Northeast()
		return
	Northwest()
		return
	Southeast()
		return
	Southwest()
		return
	North()
		if(src.mob.dir == EAST)
			if(src.mob.inair == 0)
				src.mob.inair = 1
				for(var/i=1,i<4,i++)
					src.Move(locate(src.mob.x,src.mob.y+1,src.mob.z),NORTH)
					src.mob.dir = EAST
					sleep(2)
				Gravity(src.mob)
				return
			else
				return
		if(src.mob.dir == WEST)
			if(src.mob.inair == 0)
				src.mob.inair = 1
				for(var/i=1,i<4,i++)
					src.Move(locate(src.mob.x,src.mob.y+1,src.mob.z),NORTH)
					src.mob.dir = WEST
					sleep(2)
				Gravity(src.mob)
				return
			else
				return
	East()
		..()
		if(src.mob.inair == 0)
			var/turf/checkdense = locate(src.mob.x,src.mob.y-1,src.mob.z)
			if(checkdense.density == 0)
				src.mob.inair = 1
				Gravity(src.mob)
			return

	West()
		..()
		if(src.mob.inair == 0)
			var/turf/checkdense = locate(src.mob.x,src.mob.y-1,src.mob.z)
			if(checkdense.density == 0)
				src.mob.inair = 1
				Gravity(src.mob)
			return
	South()
		if(src.mob.inair == 1)
			return
