#define deficon icon='icon.dmi'

world/turf = /turf/back
world/mob = /mob/aeris
obj
	ledge
		deficon
		icon_state="ledge"
	health
		deficon
		icon_state="3"
		screen_loc = "7,8"
turf
	density=1
	deficon
	back
		density=0
		icon_state="back"
	ledgeb
		icon_state="ledgeb"
	ledgebl
		icon_state="ledgebl"
	ledgebr
		icon_state="ledgebr"
	ledgebl1
		icon_state="ledgebl1"
	ledgebl2
		icon_state="ledgebl2"
	ledgebr2
		icon_state="ledgebr2"

mob
	var/HP=3
	Login()
		..()
		src.loc=locate(1,3,1)
		src.client.screen+= new /obj/health
	deficon
	proc/death(mob/m)
		if(m.HP<=0)
			m<<"loser."
			del(m)
	aeris
		icon_state="aeris"
	seph
		name="Sephiroth"
		icon_state="seph"
		Bump(m)
			..()
			Bumped(m)
		proc/Bumped(m)
			if(ismob(m))
				for(var/mob/M in world)
					if(M == m)
						M.HP--
				death(m)
			del(src)
		New()
			..()
			src.icon_state=null
			src.loc=locate(rand(1,8),8,1)
			src.icon_state="seph"
			movedown()
		proc/movedown()
			loop:
				walk(src,SOUTH,rand(2))
				spawn(rand(5,15))
				goto loop
	spawner
		New()
			..()
			niggerpant()

		proc/niggerpant()
			loop:
				new /mob/seph(src.x+1,src.y,src.z)
				spawn(rand(3,5))
					goto loop
	Stat()
		if(src.client)
			src.update()
	proc/update()
		for(var/obj/health/HP in src.client.screen)
			HP.icon_state = src.HP

client/North()
	return null