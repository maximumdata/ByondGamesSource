



/*mob
	var
		heartrate=10
	proc
		heartrate()
			if(src)
				for(var/mob/enemies/M in oview(src))
					if(M)
						src.heartrate--
					else
						src.heartrate=10
				src<<sound("HEART.wav")
				spawn(src.heartrate)
					src.heartrate()
			else
				return 0*/