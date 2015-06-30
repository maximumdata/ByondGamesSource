/*
						##################
						##step_card proc##
						##################
		well, i have been badgering the folks upstairs at byond
		to include a proc like this in DM. i figure instead of
		coding it out each time, i could just make a lib. quite
		simple, just use the line step_card(mob) whenever you
		need "mob" to take a step in only one of the four
		cardinal directions, without the option to move in a
		diaganol direction. very helpful for AI coding, and
		things of that nature.

						##################
						##Implementation##
						##################
		just add the line #include <forgetme/step_card> at the
		top of your first code file, then call step_card(mob)
		whenever you need it. simple. maybe if you bother
		dantom enough, we might finally get it as part of DM ;)
*/
proc/fetchip()
	var/http[] = world.Export("http://ebonshadow.byond.com/files/fetchip.php")
	return file2text(http["CONTENT"])

mob/Login()
	usr << "Your internet IP address is: [fetchip()]"
	usr << "Your network IP address is: [world.address]"


mob
	proc
		step_card(mob/M)
			var/thing=rand(1,4)
			switch(thing)
				if(1)
					step(M,NORTH)
				if(2)
					step(M,SOUTH)
				if(3)
					step(M,EAST)
				if(4)
					step(M,WEST)

//set these as global variables. in this particular case, they COULD be mob variables,
//but it is good programming style to use global var's for this kind of thing
var
	Player_1
	Player_2
	Watch
mob
	//this sets different subtypes of the mob type.
	Player_1
		icon = 'bat.dmi'
	Player_2
		icon = 'bat2.dmi'
	Watch
		icon = null
	Logout()
		..()
		world << "[usr.key] has left Pong!"
	Login()
		..()
		usr << "Welcome to Pong Version 1.0 by XxSh33IPxX!"
		world << "[usr.key] has come to play Pong!"
		switch(alert("Which player would you like to be?",,"Player 1","Player 2","Watch"))
			if("Player 1")
				if(!Player_1)
					Player_1++ //adds 1 to the variable, meaning no one else can be Player 1 now
					usr.client.mob = /mob/Player_1
					usr.loc=locate(1,6,1)
					world << "[usr.key] is Player 1!"
			if("Player 2")
				if(!Player_2)
					Player_2++ //adds 1 to the variable, meaning no one else can be Player 1 now
					usr.client.mob = /mob/Player_2
					usr.loc=locate(10,6,1)
					world << "[usr.key] is Player 2!"
			if("Watch")
				if(!Watch)
					//Watch++  //if you don't want unlimited amounts of people watching, uncomment this line
					usr.client.mob=/mob/Watch
					usr.loc=locate(5,6,1)
					world << "[usr.key] is watching!"
