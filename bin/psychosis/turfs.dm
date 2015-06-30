
turf
	thing
		icon='thing.dmi'
		icon_state="omg"
	title
		icon='title.png'
		Click()
			usr.CharacterStuff()
	black
		icon='thing.dmi'
		icon_state="black"
		opacity=1
		density=1
	NoBullets
		Entered(M)
			if(istype(M,/obj/bullets))
				del(M)