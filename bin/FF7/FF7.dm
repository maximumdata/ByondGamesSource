mob/icon='mob.dmi'
mob/New()
	..()
	name=pick("Jim","Jeff")
mob/verb/blast()
	for(var/obj/blast/B in world)
		if(B.owner==src)
			del(B)
	src.icon_state="blast guy"
	spawn(10)
		src.icon_state=null
	var/obj/blast/one = new /obj/blast(locate(src.x+1,src.y,src.z))
	one.icon_state="blast1"
	one.owner=src
	sleep(1)
	var/obj/blast/two = new /obj/blast(locate(src.x+2,src.y,src.z))
	two.icon_state="blast2"
	one.owner=src
	sleep(1)
	var/obj/blast/three = new /obj/blast(locate(src.x+3,src.y,src.z))
	three.icon_state="blast3"
	three.owner=src
	for(var/mob/m in oview(3,src))
		if(m.x==src.x+3&&src.y==m.y&&src.z==m.z)
			if(three)
				three.Bump(m)
		if(m.x==src.x+2&&src.y==m.y&&src.z==m.z)
			if(two)
				two.Bump(m)
		if(m.x==src.x+1&&src.y==m.y&&src.z==m.z)
			if(one)
				one.Bump(m)
obj/x/icon='turf.dmi'
obj/x/icon_state="x"
/*mob/verb/blast2()
	src.icon_state="blast guy"
	spawn(10)
		src.icon_state=null
	var/obj/blast/B= new /obj/blast(locate(src.x,src.y,src.z))
	B.loc=locate(B.x+1,B.y,B.z)
	B.icon_state="blast1"
	sleep(1)
	B.loc=locate(B.x+1,B.y,B.z)
	B.icon_state="blast2"
	sleep(1)
	B.loc=locate(B.x+1,B.y,B.z)
	B.icon_state="blast3"*/
mob/verb/say(t as text)
	world<<"<b>[src.name]</b>: [t]"
client/command_text="say \""
obj/blast
	icon='blast.dmi'
	density=1
	layer=MOB_LAYER+1
	var/owner
	New()
		..()
		spawn(5)
			del(src)
	Bump(M)
		..()
		if(!ismob(M))
			del src
		if(src.icon_state=="blast3")
			world<<"[M] WAS HIT!"
		else
			world<<"MISSED [M]"

world/turf=/turf/t

turf/t/icon='turf.dmi'