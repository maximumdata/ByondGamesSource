obj/x
	icon='x.dmi'
	layer=MOB_LAYER+5
	New()
		if(usr.z==16)
			src.icon_state="star"
			src.icon+=rgb(255,000,000)
			spawn(5)
				del(src)
		else
			spawn(5)
				del(src)
turf
	Click()
		new /obj/x(src)

	misc
		icon='turf.dmi'
		dense
			density=1
			name=""
		burn
			name="there must've been an explosion here"
			New()
				src.icon_state="burning"
				spawn(2)
					src.icon_state="burnt"
			burntmetal
				icon='burnmetal.dmi'
			burntoutside
				icon='burnoutside.dmi'
	floors
		icon='turf.dmi'
		outsidemetal
			icon_state="grass"
		metal
			icon_state="metal"