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
