obj/spawner
	name = "MAGICal mob spawner"
	var/spawntype // mob.type it will spawn IE /mob/spawnbaby
	var/max_spawn = 5 // number at which it will generate no new mobs
	var/spawned = 0 // count of mobs spawned
	var/spawnsleep=100
	var/delflag=0
	var/dellimit=10
	New()
		..()
		// initialize the list of mobs to be spawned
		spawn while (1) // More efficient to put in a loop like Deadron's event loop
			src.check_spawn() // start the spawn calls
			src.spawn_del()
			sleep(spawnsleep)		// wait 10 secs
	proc
		check_spawn() // called periodically to check to see if
						// any new mobs should be generated
			if(spawned < max_spawn)	// make sure we haven't reached limit
				var/mob/M = new spawntype(src.loc) // generate mob
				M.owner = src
				spawned ++ // increment the counter
			if(spawned == max_spawn)
				sleep(50)
				delflag++
		spawn_del()
			if(delflag==dellimit)
				//world<<"pmg ftw"
				del(src)
mob
	var/atom/owner
	Del()
		if (owner && istype(owner, /obj/spawner))
			var/obj/spawner/O = owner
			O.spawned -- // make sure it's spawner is adjusted!
		..()
obj/spawner/orcspawner
	name=""
	spawntype=/mob/NPC/enemies/Orc
	spawnsleep=25
	max_spawn=7