

client
	command_text=".alt "
	mouse_pointer_icon='target.dmi'

	verb/Talk(arg as text)
		set hidden =1
		world<<"<small>[src.mob.name] / [src]</small>: [arg]"
	verb/Racetalk(arg as text)
		set hidden = 1
		for(var/mob/M in world)
			if(M.race==src.mob.race)
				M<<"<small>{[src.mob.race]} - [src.mob.name]</small>: \red [arg]"

	Move()
		if(!mob.umsl_ObtainMultiLock(list("right leg", "left leg"), 3))
			return null
		else
			return ..()


//MACROS
	script=\
{"<STYLE>BODY {color:#FFFFFF; font-size: 10pt; background-color: #000000}</STYLE>

macro
	T return "Talk"
	Y return "Racetalk"
	thing1
		set name="."
		return "talk"
	thing2
		set name=","
		return "setnade"
	G return "setnade"

"}
