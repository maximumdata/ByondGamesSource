obj
	icon='objs.dmi'
	var
		cost
		itemdesc

	items
		armor
			icon_state="armor"
			itemdesc="Entry level armor."
			cost=25
		guns
			var/maxammo=25
			gun1
				name="Energy Gun"
				icon_state="gun1"
				itemdesc="Entry level gun"
				cost=50
		bombs
			light_grenade
				name="Light Grenade"
				icon_state="nade"
				var/nades=10
				proc/Update()
					sleep(10)
					src.suffix="[src.nades]"
					src.Update()
				New()
					spawn(5)
						if(src.nades)
							src.Update()
				verb
					setnade()
						set hidden = 1
						set src in usr
						if(src.nades)
							var/obj/LG = new /obj/items/bombs/light_grenade(usr.loc)
							LG:nades=null
							src.nades-=1
							sleep(rand(25,30))
							if(LG)
								LG.icon_state=null
								Explode(LG.loc, 2)
								for(var/mob/OMG in view(2,LG))
									//Quake_Effect(OMG,5)
									var/multdam=get_dist(OMG,LG)
									var/damage=rand(5,9)
									switch(multdam)
										if(0)
											damage*=3
										if(1)
											damage*=2
										if(2)
											damage*=1
									sleep(2)
									if(OMG)
										OMG.hp -= damage
										s_damage(OMG,damage,"#FF0000")
										OMG.death(OMG)
								del(LG)
						else
							usr<<"You don't have any grenades to set!"

