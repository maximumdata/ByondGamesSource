

mob
	Move()//Overwriting the mobs Move verb.
		if(movable == 1)//If /mob/var/movable = 1.
			..()//Then call the default action of Move().
		else//If movable doesn't equal 1.
			return//You can't move.
	var
		movable = 1//This is where movable is defined.
area
	var/list/faders = list()

	New()//When the area's are created.
		..()
		faders["Z"]=new /image('fade.dmi',src,10)//Z's image is solid black.
		faders["Y"]=new /image('fade.dmi',src,"25",10)//Y's image is 25% black.
		faders["X"]=new /image('fade.dmi',src,"50",10)//X's image is 50% black.
		faders["W"]=new /image('fade.dmi',src,"75",10)//W's image is 75% black.
mob
	proc
		Fade_Out()//Here is the fade out procedure.
			var/mob/M = src//M, which represents the mob calling the proc, is set to src.
			M.FO1()//this proc applies the first image of 25%.
			sleep(1)//Waits 1/10th of a second.
			M.FO2()//This proc applies the second image of 50% and deletes the first image.
			sleep(1)//Waits 1/10th of a second.
			M.FO3()///This proc applies the second image of 75% and deletes the second image.
			sleep(1)//Waits 1/10th of a second.
			M.FO4()//This proc applies the second solid black image and deletes the third image.

		FO1()//FO1 = Fade out 1st procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images+=A.faders["Y"]//The Y image is added to the client's view.

		FO2()//FO2 = Fade out 2nd procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images-=A.faders["Y"]//The Y image is removed from the client's view.
				C.images+=A.faders["X"]//The X image is added to the client's view.

		FO3()//FO3 = Fade out 3rd procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images-=A.faders["X"]//The X image is removed from the client's view.
				C.images+=A.faders["W"]//The W image is added to the client's view.

		FO4()//FO4 = Fade out 4th procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images-=A.faders["W"]//The W image is removed from the client's view.
				C.images+=A.faders["Z"]//The Z image is added to the client's view.
		Fade_In()//Here is the fade out procedure.
			var/mob/M = src//M, which represents the mob calling the proc, is set to src.
			M.FI1()//This proc removes the solid black image and adds the 75% image.
			sleep(1)//Waits 1/10th of a second.
			M.FI2()//This proc removes the 75% image and adds the 50% image.
			sleep(1)//Waits 1/10th of a second.
			M.FI3()//This proc removes the 50% image and adds the 25% image.
			sleep(1)//Waits 1/10th of a second.
			M.FI4()//This proc removes the 25% image.

		FI1()//FI1 = Fade in 1st procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images-=A.faders["Z"]//The Z image is removed from the client's view.
				C.images+=A.faders["W"]//The W image is added to the client's view.

		FI2()//FI2 = Fade in 2nd procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images-=A.faders["W"]//The W image is removed from the client's view.
				C.images+=A.faders["X"]//The X image is added to the client's view.

		FI3()//FI3 = Fade in 3rd procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images-=A.faders["X"]//The X image is removed from the client's view.
				C.images+=A.faders["Y"]//The Y image is added to the client's view.

		FI4()//FI4 = Fade in 4th procedure.
			var/client/C//C represents a client in the game.
			for(var/area/A in view())//For all areas in client's view.
				C = src.client//The client C, is set to represent the client calling the procedure.
				C.images-=A.faders["Y"]//The Y image is removed from the client's view.


