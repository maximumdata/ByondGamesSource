


proc

	isdense(atom/thing)
		if(thing.density)
			return 1
		else
			return 0

	isopaque(atom/thing)
		if(thing.opacity)
			return 1
		else
			return 0




/*						##################
						##step_card proc##
						##################
		well, i have been badgering the folks upstairs at byond
		to include a proc like this in DM. i figure instead of
		coding it out each time, i could just make a lib. quite
		simple, just use the line step_card(mob) whenever you
		need "mob" to take a step in only one of the four
		cardinal directions, without the option to move in a
		diaganol direction. very helpful for AI coding, and
		things of that nature.
*/
mob
	proc
		step_card(mob/M)
			var/thing=rand(1,4)
			switch(thing)
				if(1)
					step(M,NORTH)
				if(2)
					step(M,SOUTH)
				if(3)
					step(M,EAST)
				if(4)
					step(M,WEST)