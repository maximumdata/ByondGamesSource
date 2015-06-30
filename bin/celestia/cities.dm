#define worldmap 1

turf
//CITIES
	cities
		icon='cities.dmi'
		city1
			tl/icon_state="tl1"
			tl/density=1
			tr/icon_state="tr1"
			tr/density=1
			bl/icon_state="bl1"
			bl/density=1
			br/icon_state="br1"
			layer=MOB_LAYER+10
			Entered(mob/player/M)
				M.movable = 0
				M.Fade_Out()
				sleep(10)
				M.loc=locate(10,10,2)
				M.client.view = world.view
				M.icon_state=M.origicon
				M.Fade_In()
				M.movable=1
		city2
		//	icon_state="city2"
			tl/icon_state="tl2"
			tl/density=1
			tr/icon_state="tr2"
			tr/density=1
			bl/icon_state="bl2"
			bl/density=1
			br/icon_state="br2"
			layer=MOB_LAYER+10
			Entered(mob/player/M)
				M.movable = 0
				M.Fade_Out()
				sleep(10)
				M.loc=locate(10,10,3)
				M.client.view = world.view
				M.icon_state=M.origicon
				M.Fade_In()
				M.movable=1
area
//LEAVING CITIES
	leaves
		leavecity1
			Entered(mob/player/M)
				if(M.client)
					M.density=0
					M.movable = 0
					for(var/mob/Q in M.client.selected)
						Q:pwner=null
						for(var/image/ok in Q:images)
							del(ok)
					M.client.selected=list()
					M.Fade_Out()
					sleep(10)
					M.loc = locate(10,10,worldmap)
					M.client.view=mapview
					M.icon_state=M.icon_state+"sm"
					M.Fade_In()
					M.movable=1
					M.density=1
		leavecity2
			Entered(mob/player/M)
				if(M.client)
					M.density=0
					M.movable = 0
					for(var/mob/Q in M.client.selected)
						Q:pwner=null
						for(var/image/ok in Q:images)
							del(ok)
					M.client.selected=list()
					M.Fade_Out()
					sleep(10)
					M.loc = locate(21,21,worldmap)
					M.client.view=mapview
					M.icon_state=M.icon_state+"sm"
					M.Fade_In()
					M.movable=1
					M.density=1