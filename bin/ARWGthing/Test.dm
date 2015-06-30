#define CRASHED CRASH

mob/Login()
	world<<"[src] came in."
	..()
	if(src.key=="Forgetme"||src.key=="Crashed")
		src.verbs+=typesof(/mob/GM/verb)
mob/Logout()
	 world<<"[src] left us."
	 del src

mob/var
	Player
	mute=0
	votes=0
	wins=0
	definition=""
	voted=0
var
	Players
	Start


mob/verb/Join()
	if(!Start)
		Players++
		Player=Players
		world<<"<b>[src] joined the game as Player [Player]!"
		src.verbs -= /mob/verb/Join
		src.verbs += /mob/leave/verb/Leave
		if(Player==1)								//first person to join gets host controls
			src.verbs += typesof(/mob/host/verb)
			src.verbs -= /mob/host/verb/End_Game	//you only get this once the game starts

mob/leave/verb/Leave()
	if(src.Player)
		world<<"<b>[src.name] left!"
		for(var/mob/M in world)
			if(M.Player>src.Player)
				M.Player--
				world<<"[M.name] is now [M.Player]"
		src.Player=null
		for(var/obj/Character/c in world)
			if(c.owner==usr)del c
		Players--
		src.verbs -= /mob/leave/verb/Leave
		src.verbs += /mob/verb/Join
		src.verbs -= typesof(/mob/host/verb)
		if(Players==0)
			EndGame()

mob/leave/New()
	del(src)	//should never be an instance of mob/leave
	CRASHED("Instance of /mob/leave detected!")


client/command_text="say \""
mob/verb/Say(T as text)
	set hidden=1
	if(!T || src.mute)
		return
	else
		if(src.Player)
			world<<"[src.name](Player [src.Player]) says: [T]"
		else
			world<<"[src.name](Spec) says: [T]"
mob/verb/Tell(mob/M, msg as text)
	if(M==src)
		src<<"<i>Talking to yourself is the first sign of insanity."
		return
	if(!msg || src.mute)
		return
	else
		src<<"<i>You tell [M.name]: [msg]"
		M<<"<i>[src.name] tells you: [msg]"

//BEGIN UHHHH STAT THINGS, I GUESS

mob
	Stat()
		if(!Start)
			statpanel("Players")
			stat("Players in Game","")
			if(Players)
				for(var/mob/M in world)
					if(M.Player)
						stat("Player [M.Player]: [M.name]")
			else
				stat("")
			stat("Spectators","")
			for(var/mob/S in world)
				if(!S.Player)
					stat("[S.name]")
		else
			statpanel("Game")
			stat("Times:","")
			stat("Time to Define: [(timeDefine-timeleft)/10]")
			stat("Time to Vote: [(timeVote-votetime)/10]")
			stat("Playing:","")
			for(var/mob/Q in world)
				if(Q.Player)
					stat("Player [Q.Player]: [Q.name]")
					stat("     Votes: [Q.votes]")
			stat("Spectating:","")
			for(var/mob/W in world)
				if(!W.Player)
					stat("[W.name]")
			statpanel("Scores")
			for(var/mob/M in world)
				if(M.Player)
					stat("Player [M.Player]:","[M.wins]")



	/*for(var/obj/Character/c in world)
		if(c.owner==usr)del c
	TexttoMap("[key]: [T]",usr)

mob/verb/Test(T as text)
	set hidden=1
	//ayer++
	if(Player>9)
		Player=1
		for(var/obj/Character/c in world)
			del c
	TexttoMap(T,usr)
	Player++
	TexttoMap(key,usr)*/
