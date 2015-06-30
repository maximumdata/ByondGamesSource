/*
/*

This is just an example of how mouse selection can work in BYOND

Feel free to make changes, test it out, or figure out how it works

Run it to test

*/


// Two very usefull libraries made by Deadron are included to help the demo

#include <deadron/eventloop>
#include <deadron/pathfinding>







mob

// The following variables are used in movement of the units


	var/tmp
		destination          // The destination to try to reach
		last_destination     // Used in case of a bump
		next_walk_time       // When is the next time for us to walk?
		walking_delay = 5    // How long between movement?
		range = 3            // How close to destination do we have to be?

	Unit  // Units players can control


		Bump(atom/movable/O)

			if(ismob(O))  // if we bump another unit(ours), swap positions and continue pathfinding
				if(get_dist(usr,usr.destination) <= usr.range)
					return
				var/old = usr.loc
				usr.loc = O.loc
				O.loc = old

				usr.destination = usr.last_destination

		base_EventCycle()  // From Pathfinding demo

			// This gets called once each tick.

			if (next_walk_time <= world.time)

				// It's time for us to walk if given an order
				if (destination)

					var/reached_dest = base_StepTowards(destination)

					if (reached_dest)

						// We reached the destination or got as close as we could
						destination = null


				// Set the next walk time.
				next_walk_time = world.time + walking_delay

			return


client

	var/tmp

		Select[]=list()  // list of selected units
		imageslist[]=list()  // list of selection images
		turf/start  // grid start
		turf/end  //grid end

	verb/Deselect()

		// if something is selected
		if(Select.len)

			// deselect it/them
			for(var/mob/Unit/U in Select)
				Select -= U
			for(var/i in src.imageslist)
				del(i)

	Click(atom/movable/object, location)

		// if something is selected
		if(Select.len)

			// give it/them a destination, if the destination is valid
			if(isloc(object.loc))

				world << "<i>Destination set to [object] at current [object.x],[object.y]</i>"

				for(var/mob/Unit/U in Select)
					U.destination = object
					U.last_destination = U.destination

		return ..()

	DblClick(atom/movable/object, location)

		// an order is given on the first click

		src.Deselect()  // now deselect units

	MouseDown(object,location)


		// if nothing is selected, draw the grid
		if(!Select.len)

			src.Draw_Grid(location,location)

		..()

	MouseUp(object,location)

		// if there is a selection box, select!
		if(start)

			End_Grid()

		..()

	MouseDrag(src_object,over_object,src_location,over_location)

		// if there is a grid started, expand it
		if(start)

			Draw_Grid(start,over_location)

		..()

	proc/Draw_Grid(S,E)

		if(!isloc(S,E)) //if mouse is now at a valid loc return
			return

		// if there is no start location, set it
		if(!start)

			start = S

		end = E  // current mouse location

		// delete old grid
		for(var/image/I in src.imageslist)

			del(I)

		// vars set to the difference between 2 corners of box
		var/xd = end.x-start.x
		var/yd = end.y-start.y

		// 4 corners of grid are given are displayed to the user
		src.imageslist += new/image ('Selecting.dmi',locate(start.x,start.y,start.z),"2")
		src.imageslist += new/image ('Selecting.dmi',end,"2")
		src.imageslist += new/image ('Selecting.dmi',locate(start.x,start.y+yd,start.z),"2")
		src.imageslist += new/image ('Selecting.dmi',locate(start.x+xd,start.y,start.z),"2")

		for(var/image/I in src.imageslist)

			src << I

	proc/End_Grid()

		var

			// variables used to determine selection area
			max_X=max(start.x,end.x)
			min_X=min(start.x,end.x)
			max_Y=max(start.y,end.y)
			min_Y=min(start.y,end.y)

		// selection box is deleted
		for(var/image/I in src.imageslist)

			del(I)

		// turfs in box are checked for units
		for(var/turf/T in block(locate(min_X,min_Y,1),locate(max_X,max_Y,1)))

			// if you want to enable selecting more then one unit per turf, use a for() loop
			var/mob/Unit/M = locate() in T

			if(M)

				// a unit was found at this location, select it
				var/image/I = new('Selecting.dmi',M,"1")
				Select+=M
				src.imageslist+=I
				src << I

		start = null
		end = null

*/