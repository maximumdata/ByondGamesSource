/*
	unterra.monstoro.SimpleLocks library -- by Gughunter


	Behold! One simple library can handle movement delays, spam protection, time-consuming
	actions like attacking or spell-casting, and imagining world peace.

	The idea is simple. Every mob gets a built-in list of locks. There can be as many or as few
	locks as you like. Whenever the mob tries to do something that it can only do every so often,
	you simply try to set the appropriate lock. If it's already set, well, try again later.

	"Duration" is the number of ticks the lock will be in effect. If you use a duration of 0,
	you will not set the lock -- you will just get a result that indicates whether
	the lock is currently available.

	All procs listed below return 0 to indicate a failure. See the descriptions below for
	information about the return values for successes.

	Please check out the included demo for numerous examples of how you can use this library.


	umsl_ObtainLock(lockName, duration)
		Tries to set a single lock.
		If successful, returns lockName.

	umsl_ObtainMultiLock(list/lockNames, duration)
		Tries to set all locks in the list. This is an all-or-nothing operation! No locks
		in the list will be set unless they can all be set.
		If successful, returns the list.

	umsl_ObtainAnyOneLock(list/lockNames, duration)
		Tries to set each lock in the list until one succeeds.
		If successful, returns the name of the lock that succeeded.


//////demos

	verb/say(T as text)
		if(umsl_ObtainLock("mouth", 30)) world << "[src]: [T]"
		else src << "Spam protection is enabled. You must wait at least 3 seconds between utterances."


	verb/cast()
		var/obj/groat_cluster/G = locate() in src
		if(G)
			if(umsl_ObtainMultiLock(list("left hand", "right hand"), 50))
				usr << "You cast a spell! Hooray for you!"
				del G
			else
				usr << "You must have two free hands to cast a spell."
		else usr << "How can you cast a spell without groat clusters?!"


	verb/pick_nose()
		var/result = umsl_ObtainAnyOneLock(list("right hand", "left hand"), 30)
		if(result)
			usr << "You pick your nose with your [result], but beware -- there are no winners up there, friend!"
		else
			usr << "You need a free hand to do that."
*/
client
	Move()
		if(!src.mob.running)
			if(!mob.umsl_ObtainMultiLock(list("right leg", "left leg"), 4))
				return null
			else
				return ..()

		else
			if(!mob.umsl_ObtainMultiLock(list("right leg", "left leg"), 2))
				return null
			else
				if(src.mob.stamina)
					src.mob.stamina--
					return ..()
				else
					src.mob<<"You can't run! You're exhausted!"
					src.mob.running=0
					src.mob.stamrech()
					..()


mob
	var/list/umsl_locks = list()


	proc/umsl_ObtainLock(lockName, duration)
		var/curStatus = umsl_locks[lockName]

		if(curStatus <= world.time)
			if(duration > 0) //Duration 0 signifies a non-lock-reserving status check
				umsl_locks[lockName] = world.time + duration
			return lockName
		else return 0


	proc/umsl_ObtainMultiLock(list/lockNames, duration)
		var/lockName
		for(lockName in lockNames)
			if(!umsl_ObtainLock(lockName, 0)) return 0
		for(lockName in lockNames)
			umsl_ObtainLock(lockName, duration)
		return lockNames


	proc/umsl_ObtainAnyOneLock(list/lockNames, duration)
		var/lockName
		for(lockName in lockNames)
			var/result = umsl_ObtainLock(lockName, duration)
			if(result) return lockName
		return 0
