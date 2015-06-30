#define state icon_state
#define worldmap 1

atom
	icon='icon.dmi'
	var/mapview=13

world
	view=5
	mob=/mob/player

mob/player/state="mob"
mob/var/origstate="mob"

mob/Login()
	src.loc=locate(1,1,2)

turf
	dense
		density=1
		opacity=1
		state = "black"
	city1
		state="city1"
		Entered(mob/player/M)
			M.loc=locate(1,1,2)
			M.client.view = world.view
			M.state=M.origstate
	city2
		state="city2"
		Entered(mob/player/M)
			M.loc=locate(1,1,3)
			M.client.view = world.view
			M.state=M.origstate
area
	leavecity1
		Entered(mob/player/M)
			M.loc = locate(10,10,worldmap)
			M.client.view=mapview
			M.state=M.state+"sm"
	leavecity2
		Entered(mob/player/M)
			M.loc = locate(15,15,worldmap)
			M.client.view=mapview
			M.state=M.state+"sm"