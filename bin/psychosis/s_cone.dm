//Credit to: Spuzzum
//Contributed by: Spuzzum
//Special thanks to: Foomer (for suggesting its creation)


//This proc returns a "cone" in a given direction -- that is,
// when you use the cone proc, it'll return a list of all objects
// within a certain distance inside a cone leading from the source
// out to that distance.

//For example:
// cone(usr, NORTH)
// would produce a cone like so:

// X X X X X X X X X  | X = included space
//   X X X X X X X    | O = user
//     X X X X X      |
//       X X X        |
//         O          |

//You can tweak the cone's acceptable list as desired.  For
// example:
// cone(usr, NORTH, range(usr))
// would make a cone from all objects within range().
//The default is view().

//To make a cone out three spaces, just use:
// cone(usr, NORTH, list = view(3))

//And so on and so forth.


proc/cone(atom/center = usr, dir = NORTH, list/list = view(center))

	var/list/dirs = list(dir, turn(dir,45), turn(dir,-45))

	switch(dir)
		if(NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST)
			for(var/atom/O in list)
				if(!dirs.Find(get_dir(center, O)))
					list -= O
			return(list)

		if(NORTH, SOUTH)
			//Definition:
			//An object to the NORTH or SOUTH is something where the absolute
			// value of the y value is greater than or equal to the abs of the
			// x value.  The object must also have a get_dir(usr, O) equal to
			// NORTH/SOUTH, NORTHEAST/SOUTHEAST, or NORTHWEST/SOUTHWEST.

			for(var/atom/O in list)
				if(!get_dist(center,O)) continue //include the origin of the cone
				if(!dirs.Find(get_dir(center, O))) //if it's not in the right directions
					list -= O //remove it
					continue
				if(abs(O.x - center.x) > abs(O.y - center.y))
					list -= O //remove it

			return(list) //all that remain will be good to go

		if(EAST, WEST)
			//This is similar to NORTH/SOUTH, except the abs value check is
			// in the opposite direction.

			for(var/atom/O in list)
				if(!get_dist(center,O)) continue //include the origin of the cone
				if(!dirs.Find(get_dir(center, O))) //if it's not in the right directions
					list -= O //remove it
					continue
				if(abs(O.y - center.y) > abs(O.x - center.x)) //if it's not in the proper arc
					list -= O //remove it

			return(list) //all that remain will be good to go
