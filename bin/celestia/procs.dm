


proc
	Explode(atom/location,distance as num)
		var/x
		for(x=0;x<=distance;x++)
			for(var/turf/T in view(location,x))
				for(var/mob/M in view(location,x))
					Quake_Effect(M,4)
				if(!isdense(T))
					if(istype(T,/turf/floors/metal))
						new /turf/misc/burn/burntmetal(T)
					if(istype(T,/turf/floors/outsidemetal))
						new /turf/misc/burn/burntoutside(T)
			sleep(1)
	/*
		for(var/mob/OMG in view(2,location))
			Quake_Effect(OMG,5)
			var/multdam=get_dist(OMG,location)
			var/damage=rand(5,9)
			switch(multdam)
				if(0)
					damage*=3
				if(1)
					damage*=2
				if(2)
					damage*=1
			OMG.hp -= damage
			s_damage(OMG,damage,"#FF0000")
			OMG.death(OMG)
*/