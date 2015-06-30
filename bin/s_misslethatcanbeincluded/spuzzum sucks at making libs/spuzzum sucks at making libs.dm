/////////////////////////////////////////////////////////////////////////
// Spuzzum's Advanced Projectile Library  - by Jeremy "Spuzzum" Gibson //
/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   At the behest of a certain someone (grr... =), I created this li- //
// brary to replace the venerable missile() proc that ships with BYOND //
// itself.  While my library probably can't equate to the sheer sim-   //
// plicity provided by missile(), it does provide numerous options     //
// that make it slightly preferable over the hard-coded version.       //
//                                                                     //
//   [As I add this footnote weeks later, I would like to comment that //
// my library is less of a replacement than it is a supplement.  The   //
// features enjoyable with both missile() and the spl_missile#()s are  //
// simply too complementary for one to exceed another.]                //
/////////////////////////////////////////////////////////////////////////
//                                                                     //
// CAVEATS:                                                            //
//   This code executes a mathematical processor intensive process     //
// every lag ticks.  Thus, if you have many spl_missile#() procs exe-  //
// cuting at the same time, your world will most likely tend to slow   //
// down.  Use this code sparingly if possible, resorting to missile()  //
// if the need isn't for superb angular accuracy.                      //
/////////////////////////////////////////////////////////////////////////
//                                                                     //
// COPYRIGHT INFO:                                                     //
//   Guess what?  There isn't any!  I created this library with the    //
// intention that you would expand on it, edit it, and break into new  //
// horizons with this code.  I do ask one little favour, though, and   //
// that's to put my name (Spuzzum) in your world's credits... that's   //
// all though, at least I'm not asking for your left kidney! =)        //
//                                                                     //
// Programming -                                                       //
//   Spuzzum (that's me!)                                              //
//   Al (you've taught me a lot...)                                    //
//   Gazoot (thanks, buddy!)                                           //
// Influence -                                                         //
//   Guy T. (aka. a certain someone =)                                 //
/////////////////////////////////////////////////////////////////////////

/*
  Quoting Deadron:
      "Prefixes can often be ugly, but are necessary to avoid name
      collisions[...]  This way my functions will never collide with
      BYOND-provided functions or anything in your own code."

  With regards to prefixes, this library uses a generic "s_" prefix
in front of every proc and object.  Though two letters can sometimes
be a pain to type out every time you have code, the code will never
interfere with any of your functions, or any of BYOND's hard-coded
functions.  If they do conflict, it is such a rare circumstance as to
be considered nearly impossible, and is usually the result of an
intentional attempt to MAKE a conflict.

Function overview:

  s_missile(*)
      Fires a missile from a certain point on the map to another point
    on the map.  It will automatically delete itself when it arrives.
    Though the effect is not in all respects completely graphical, the
    object certainly has no effect on any events unless checked for
    (such as obj/O).
      There are four separate argument types for these procs.  The first
    follows this format:

        s_missile(icon,icon_state="",ref,trg,lag=1,homing=0)

      This will generate a new missile in ref's location, and move it
    rapidly to trg's location.  It will have an icon of icon, an
    icon_state of icon_state, and will precede each of its movements
    with lag number of ticks before moving again.  If homing is set, it
    will instead follow trg, regardless of trg's new position.

      The second format involves an object reference, hence:

        s_missile(ref,start,end,lag=1,homing=0)

      This will move ref to start's location, and move it rapidly to
    end's location.  It will precede each of its movements with lag
    number of ticks before moving again.  If homing is set, it will
    instead follow end, regardless of end's new position.

      Be careful with the second usage; if you accidentally specify
    a player mob as ref, the player will be thrown from start to end
    and then deleted when they arrive.  This might be intentional
    (like falling off a cliff, etc.), but usually it will not be.

      This is useful if you want to define dense projectiles that
    have more of an effect on their terrain.  Obviously, the second
    usage is designed to have more than a simple graphical effect.

      The third format is like the first but without an icon state:

        s_missile(icon,ref,trg,lag=1,homing=0)

      It functions in all respects like the first format.

      The fourth format accepts an object type:

        s_missile(/obj/spl_projectile,ref,trg,lag=1,homing=0)

      This, unlike the standard missile(), will physically create an
    object of that type.  This is useful because it allows you to
    fire off different projectiles with minimal effort on your part.
    Instead of having to create them yourself, why not automate it
    and fire off an object type, which will have all of its settings
    defined in obj.New()?  Note that the object type can be either
    a mob or an object, but not anything else.

  walk_line(ref,trg,lag)
      Will move ref on a straight line to its trg destination, preceding
    each step with lag ticks of inactivity.  Ref must be an obj or
    mob; turfs and areas do not have Move() procs.
      Will not check for dense objects; if you walk_line something
    somewhere, it will fly straight, not steering to avoid obstacles,
    mimicking real projectiles.  If it collides with something, it will
    most likely simply stop, unless you define content for ref.Bump()

  The missiles provided in this code will immediately return and then
process in the background, which is a safety measure in case you insert
sleep statements in the code that calls a missile.  To override the
default "graphical" projectile (i.e. the first/third usage), overwrite
/obj/spl_projectile to your whims.  Normally, however, you should
create a projectile object, change it's settings as appropriate, use
the second usage to move it to your target, and leave obj/spl_projectile
untouched.  This promotes Object-Oriented behavior, and still allows you
to use the default "graphical" version when you see fit.

  Due to slight limitations in BYOND, the error checking of s_missile()
is unable to give you the precise location of where you call the proc
that gives you the error.  Whenever the crash occurs, it will point to
the library instead of your world.  For this purpose, you should refer
to the call stack and check each proc included in the list for erroneous
calls to s_missile().  The error message itself should be ignored.

  Note that this makes no provision whether a target will actually be on
the map.  If the target is in nilspace, it'll confuse the missile,
causing a proc crash.  The checking is not provided in this library
as that is code the designer should take care of in case of special
circumstances.  Of course, s_missile is completely useless in
non-graphical MUDs or games.

  I can be emailed at spuzzum@mail.com, if you have any comments/
questions/suggestions.  You can also contact me on ICQ at 43112724.

  Remember, you can always feel free to add something; just include
my alias (Spuzzum) and email address (spuzzum@mail.com), and send me
a copy so I can put it on my webpage.  Thanks!

                                                     Spuzzum
                                         mailto:spuzzum@spuzzum.byond.com
                                             http://spuzzum.byond.com

Known Bugs:
- the included demo seems to slow down after a while... there's probably
  a memory leak somewhere, but as far as I can tell I can't find it.

*/



#define SPL_DEBUG 0
//#define SPL_DEBUG 1


obj/spl_projectile
	name = ""
	layer = 5
	Click()
		..()
		var/M
		var/layer = 1
		for(M in src.loc)
			if(M:layer > 1)
				layer = M:layer
		for(M in src.loc)
			if(M:layer == layer && M != src)
				M:Click()
				break


proc
	s_missile()
		var/obj/ref
		var/turf/start
		var/end
		var/homing
		var/lag
		if(isloc(args[1]))
			ref = args[1]

			start = args[2]

			if(isobj(start) || ismob(start))
				start = start:loc

			end = args[3]

			if(!homing) //if it isn't a homing projectile
				if(ismob(end) || isobj(end)) //target the loc if it is a mob|obj
					end = end:loc

			if(args.len >= 4)
				lag = args[4]
			else
				lag = 1

			if(args.len >= 5)
				homing = args[5]
			else
				homing = 0

		else if(isicon(args[1]))
			if(istext(args[2]))
				ref = new /obj/spl_projectile
				ref.icon = args[1]
				ref.icon_state = args[2]

				start = args[3]

				if(isobj(start) || ismob(start))
					start = start:loc

				end = args[4]

				if(!homing) //if it isn't a homing projectile
					if(ismob(end) || isobj(end)) //target the loc if it is a mob|obj
						end = end:loc

				if(args.len >= 5)
					lag = args[5]
				else
					lag = 1

				if(args.len >= 6)
					homing = args[6]
				else
					homing = 0

			else
				ref = new /obj/spl_projectile
				ref.icon = args[1]

				start = args[2]

				if(isobj(start) || ismob(start))
					start = start:loc

				end = args[3]

				if(!homing) //if it isn't a homing projectile
					if(ismob(end) || isobj(end)) //target the loc if it is a mob|obj
						end = end:loc

				if(args.len >= 4)
					lag = args[4]
				else
					lag = 1

				if(args.len >= 5)
					homing = args[5]
				else
					homing = 0
		else
			var/type = args[1]
			ref = new type

			start = args[2]

			if(isobj(start) || ismob(start))
				start = start:loc

			end = args[3]

			if(!homing) //if it isn't a homing projectile
				if(ismob(end) || isobj(end)) //target the loc if it is a mob|obj
					end = end:loc

			if(args.len >= 4)
				lag = args[4]
			else
				lag = 1

			if(args.len >= 5)
				homing = args[5]
			else
				homing = 0

		ref.loc = start

		spawn() s_walk_line(ref,end,lag)
		spawn() s_delwithinrange(ref,end)

// S_MISSILE SUPPORT FUNCTIONS
proc
	s_delwithinrange(ref,trg) //deletes the missile when it gets into the spot
		if(get_dist(ref,trg) == 0)
			//world << "Deleted!"
			del ref
			return
		if(!ref || !trg)
			return
		spawn(1) s_delwithinrange(ref,trg)

	s_check_dir(ref,trg,lag=1)
		if(!ref || !trg)
			return 0
		var/dir = get_dir(ref,trg)
		switch(dir)
			if(NORTH,SOUTH,EAST,WEST)
				spawn() s_move_along_dir(ref,trg,lag)
				return 1
			else
				return 0

	s_move_along_dir(ref,trg,lag=1,dir)
		if(!dir)
			dir = get_dir(ref,trg)

		if(!ref)
			return

		var/location
		var/is_a_ref = 0

		if(isturf(trg))
			location = trg
		else
			location = trg:loc

		if(ref:loc != location)
			if(is_a_ref && trg:loc != location)
				world << "Hey!"
				spawn() s_check_dir(ref,location,lag)
				return
			if(!ref || !trg)
				return
			ref:Move(get_step(ref,dir))
			spawn(lag) s_move_along_dir(ref,trg,lag,dir)


// STRAIGHT LINE FUNCTIONS
proc
	s_walk_line(ref,trg,lag=1)
		if(!s_check_dir(ref,trg,lag))
			spawn() s_send_missile(ref,trg,lag)

	s_send_missile(source, target, delay=1)
		// Thanks to Gazoot for the following implementation!

		if(!source || !target)
			return 0

		var/src_x
		var/src_y
		var/trg_x
		var/trg_y
		var/delta_x
		var/delta_y
		var/x_inc
		var/y_inc
		var/error
		var/i
		var/is_a_ref = 0

		var/turf/src_turf
		var/turf/trg_turf

		src_turf = source:loc
		src_x = src_turf.x
		src_y = src_turf.y

		if(!istype(target,/turf))
			trg_turf = target:loc
			is_a_ref = 1
		else
			trg_turf = target

		trg_x = trg_turf.x
		trg_y = trg_turf.y

		delta_x = trg_x - src_x
		delta_y = trg_y - src_y

		if(delta_x >= 0)
			x_inc = 1
		else
			x_inc = -1
			delta_x = -delta_x

		if(delta_y >= 0)
			y_inc = 1
		else
			y_inc = -1
			delta_y = -delta_y

		// Move the missile based on which delta is greater.
		if(delta_x > delta_y)
			for(i = 1, i <= delta_x, i++)
				if(!source || !target)
					return
				if(target:loc != trg_turf && is_a_ref)
					spawn() s_send_missile(source, target, delay)
					return
				error += delta_y
				if(error >= delta_x)
					error -= delta_x
					src_y += y_inc
				src_x += x_inc
				source:Move(locate(src_x,src_y,source:z))
				sleep(delay)

		else
			for(i = 1, i <= delta_y, i++)
				if(!source || !target)
					return
				if(target:loc != trg_turf && is_a_ref)
					spawn() s_send_missile(source, target, delay)
					return
				error += delta_x
				if(error > 0)
					error -= delta_y
					src_x += x_inc
				src_y += y_inc
				source:Move(locate(src_x,src_y,source:z))
				sleep(delay)
