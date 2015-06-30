world
	hub = "Forgetme.Lexiword"
	loop_checks=0
	turf = /turf/white
	New()
		..()
var
	mapx
	curplaynum=0
	started=0
	host
	players=0
	maxscore=100
	wordlist=list()
	turnlimit=300
	singleplayer=0
	mode="Classic"
	wordtofind=""
var/mob/curusr
var/list/wordsfound=list()
var/list/joined=list()
client
	proc
		Check_Word(word as text)
			var/Caller = curusr
			if(word in specialwords)
				return "special"
			else
				var/http[] = world.Export("http://dictionary.reference.com/search?q=[word]")
				if(!http)
					return 0
				var/F = http["CONTENT"]
				if(F)
					var/Content = file2text(F)
					var/EntriesFound = findtext(Content," entries found for ")
					if(!EntriesFound)
						EntriesFound = findtext(Content,"1 entry found for ")
					if(EntriesFound)
						var/EndDef = findtext(Content,"</LI>")
						var/FirstDef = findtext(Content,"<OL><LI>")
						if(!FirstDef)
							FirstDef = findtext(Content,"<DD>")
							if(!FirstDef)
								var/pos1end = findtext(Content, "</p>", findtext(Content, "<p>", EntriesFound))
								FirstDef = findtext(Content, "<p>", pos1end)
								EndDef = findtext(Content, "</p>",FirstDef)
							else
								EndDef = findtext(Content,"</DD>")
						var/Def = copytext(Content,FirstDef,EndDef)
						if(findtext(Def,"in Acronym Finder"))
							return 0
						else
							if(curusr!=Caller)
								return "turnchange"
							else
								return 1
					else
						return 0

		GenerateLetters()
			for(var/turf/board/B in world)
				if(!B.haspiece)
					var/thing=LetterThing()
					new thing(B)
					B.haspiece=thing
			for(var/mob/O in world)
				if(O.sound)
					O<<sound("coinin.wav")
					O.submitting=0
		ClearBoard()
			for(var/obj/letter/O in world)
				del(O)
			for(var/turf/board/B in world)
				B.haspiece=0
		StartTurn()
			if(started)
				if(mode=="Single Player")	//if there's only one player,
					SinglePlayer()		//make it a single player game!
					return
				else
					if(mode=="Classic")
						curplaynum++
						if(curplaynum>length(joined))
							curplaynum=1
						if(curusr)
							curusr.word=""
						for(var/mob/M in world)
							if(joined.Find(M))
								if(M.playnum==curplaynum)
									curusr=M
									curusr.client.ClearBoard()
									curusr.client.GenerateLetters()
									curusr.word=""
									curusr.submitting=0
									spawn(5) M<<"It is now your turn!"
								else
									spawn(5) M<<"It is now [curusr]'s turn!"
							M.timeleft = turnlimit/10
					else if(mode=="Party")
						for(var/mob/m in world)
							m.timeleft=turnlimit/10
							m.word=""
							m.submitting=0
						usr.submitting=0
						usr.client.ClearBoard()
						usr.client.GenerateLetters()

		SinglePlayer()
			curusr=src.mob
			src.GenerateLetters()
		Options()
			var/mapthinger
			SCOREthing
				var/scorething=input("Enter the score needed to win","Options","150") as num
				if(scorething<100||scorething>1000)
					alert(usr,"Please enter a value between 100 and 1000!")
					goto SCOREthing
				else
					maxscore=scorething
					goto MODEthing
			MODEthing
				if(joined.len>1)
					mode=input("What game mode would you like?","Options") in list("Classic","Party")//,"Search")
					if(mode=="Classic")
						for(var/mob/m in world)
							m.client.screen+=new/obj/classic
				else
					mode="Single Player"
				goto TTLthing
			TTLthing
				if(mode=="Classic")
					var/TTL =alert("What should the time limit for a turn be (in seconds)?","Options","30","45")
					switch(TTL)
						if("30")
							TTL=300
						if("45")
							TTL=450
					turnlimit=TTL
					goto mapthing
				else
					if(mode=="Party")
						turnlimit=300
						goto mapthing
					else
						goto mapthing
			mapthing
				var/map = input("Which board shape would you like to use?","Options","5. Heart") in list("1. Square","2. Chopped Square","3. Checkerboard","4. Chopped Star","5. Heart","6. Bug","7. Alien")
				switch(map)
					if("1. Square")
						//usr.z = 1
						mapx=1
					if("2. Chopped Square")
						//usr.z=2
						mapx=2
					if("3. Checkerboard")
						//usr.z=3
						mapx=3
					if("4. Chopped Star")
						//usr.z=4
						mapx=4
					if("5. Heart")
						//usr.z=5
						mapx=5
					if("6. Bug")
						mapx=6
					if("7. Alien")
						mapx=7
				mapthinger=map
				for(var/mob/M in world)
					M.loc=locate(5,5,mapx)
			if(length(joined)>1&&mode=="Classic")
				var/thing1=alert(usr,"You have chosen the Game Mode [mode], a Max Score of [maxscore], a Time Limit of [turnlimit/10] seconds, and the map [mapthinger]. Is this OK?","Options","Yes","No")
				switch(thing1)
					if("No")
						Options()
					else
						world<<"\red [host] has chosen the Game Mode [mode], a Max Score of [maxscore], and the map #[mapthinger]!"

			else
				var/thing2=alert(usr,"You have chosen the Game Mode [mode], a Max Score of [maxscore], and the map [mapthinger]. Is this OK?","Options","Yes","No")
				switch(thing2)
					if("No")
						Options()
					else
						world<<"\red [host] has chosen the Game Mode [mode], a Max Score of [maxscore], and the map #[mapthinger]!"
		SpecialPoints(word as text)
			var/points
			if(length(word)<=5)
				points=round(length(word)*5*rand(2,2.5))
			else
				points=length(word)*5+rand(5,25)
				points+=2
			return points
		CheckScores()
			for(var/mob/M in joined)
				if(M.score >= maxscore)
					Win(M)
		Warn()
			if(started)
				spawn(turnlimit-100)
					curusr<<"\red You have 10 seconds left!"
		LetterThing(number)
			if(!number)
				var/thing=rand(1,26)
				switch(thing)
					if(1)
						return /obj/letter/a
					if(2)
						return /obj/letter/b
					if(3)
						return /obj/letter/c
					if(4)
						return /obj/letter/d
					if(5)
						return /obj/letter/e
					if(6)
						return /obj/letter/f
					if(7)
						return /obj/letter/g
					if(8)
						return /obj/letter/h
					if(9)
						return /obj/letter/i
					if(10)
						return /obj/letter/j
					if(11)
						return /obj/letter/k
					if(12)
						return /obj/letter/l
					if(13)
						return /obj/letter/m
					if(14)
						return /obj/letter/n
					if(15)
						return /obj/letter/o
					if(16)
						return /obj/letter/p
					if(17)
						return /obj/letter/q
					if(18)
						return /obj/letter/r
					if(19)
						return /obj/letter/s
					if(20)
						return /obj/letter/t
					if(21)
						return /obj/letter/u
					if(22)
						return /obj/letter/v
					if(23)
						return /obj/letter/w
					if(24)
						return /obj/letter/x
					if(25)
						return /obj/letter/y
					if(26)
						return /obj/letter/z
			else
				switch(number)
					if(1)
						return /obj/letter/a
					if(2)
						return /obj/letter/b
					if(3)
						return /obj/letter/c
					if(4)
						return /obj/letter/d
					if(5)
						return /obj/letter/e
					if(6)
						return /obj/letter/f
					if(7)
						return /obj/letter/g
					if(8)
						return /obj/letter/h
					if(9)
						return /obj/letter/i
					if(10)
						return /obj/letter/j
					if(11)
						return /obj/letter/k
					if(12)
						return /obj/letter/l
					if(13)
						return /obj/letter/m
					if(14)
						return /obj/letter/n
					if(15)
						return /obj/letter/o
					if(16)
						return /obj/letter/p
					if(17)
						return /obj/letter/q
					if(18)
						return /obj/letter/r
					if(19)
						return /obj/letter/s
					if(20)
						return /obj/letter/t
					if(21)
						return /obj/letter/u
					if(22)
						return /obj/letter/v
					if(23)
						return /obj/letter/w
					if(24)
						return /obj/letter/x
					if(25)
						return /obj/letter/y
					if(26)
						return /obj/letter/z
proc
	check(W as text)
		var/flag
		for(var/word in wordsfound)
			if(W==word)
				flag=1
		if(flag)
			return 0
		else
			return 1
	DispWords(winner)
		var/words
		var/endgame
		if(wordsfound)
			for(var/W in wordlist)
				if(W)
					if(W in specialwords)
						words+="<font color=red>[W]</font><br>"
					else
						words+="[W]<br>"
			if(!winner)
				if(words)
					endgame={"
					<html><head><title>Game Over!</title></head>
					<body bgcolor = black text=white><font face = verdana size = 2><center>
					<h1><u><font color=blue>Game Over!</font></h1></u>
					<font size=1>Words displayed in <font color=red>red</font> are special words!</font>
					<br><br>The words found in this game were:<br><font size=1><br>
					[words]
					</font>
					"}
				else
					endgame={"
					<html><head><title>Game Over!</title></head>
					<body bgcolor = black text=white><font face = verdana size = 2><center>
					<h1><u><font color=blue>Game Over!</font></h1></u>
					<font size=2 color=red>No words were found!
					</font>
					"}
			else
				endgame={"
				<html><head><title>Game Over!</title></head>
				<body bgcolor = black text=white><font face = verdana size = 2><center>
				<h1><u><font color=blue>[winner] Wins!</font></h1></u>
				<font size=1>Words displayed in <font color=red>red</font> are special words!</font>
				<br><br>The words found in this game were:<br><font size=1><br>
				[words]
				</font>
				"}
			world << browse(endgame,"window=words")
	Win(mob/M)
		world<<"<b><big>\blue [M] has reached the maximum score ([maxscore]) with [M.score]! [M] wins!"
		DispWords(M)
		//world.Reboot()
		started=0
		curplaynum=0
		started=0
		curplaynum=0
		wordlist=list()
		curusr=""
		singleplayer=0
		wordsfound=list()
		for(var/mob/Q in world)
			joined-=Q
			Q.playnum=0
			Q.score=0
			Q.loc=locate(5,5,11)
			//Q.client.screen -= /obj/classic
			//if(M.key==host)
			//	M.client.screen-=/obj/hud/end
				//M.client.screen+=new/obj/hud/start
	End()
		world<<"<b><big>\blue The game has ended with no winner!"
		DispWords()
		//world.Reboot()
		started=0
		curplaynum=0
		started=0
		curplaynum=0
		wordlist=list()
		curusr=""
		singleplayer=0
		wordsfound=list()
		for(var/mob/M in world)
			joined-=M
			M.playnum=0
			M.score=0
			M.loc=locate(5,5,11)
			//M.client.screen -= /obj/classic
			//if(M.key==host)
				//M.client.screen-=/obj/hud/end
				//M.client.screen+=new/obj/hud/start
var/list/AdminList=list("Forgetme","AZA","Crashed","Jenny is a fox")
client/Topic(href,href_list[])
	if(href_list["Tell"])
		var/mob/M=locate(href_list["Tell"])//input("Who do you want to send a private message to?", "Private Message")as mob in world
		var/msg = input("What would you like to tell [M]?","Private Message") as text|null
		msg=s_smileys(msg)
		msg=Link_Filters(msg)
		if(msg)
			M<<"<a href='?src=\ref[M];Tell=\ref[src.mob]'>[src.mob]</a> tells you: [s_smileys(msg)]"
			src.mob<<"You tell <a href='?src=\ref[src.mob];Tell=\ref[M]'>[M]</a>: [s_smileys(msg)]"
client
	command_text = ".alt "
	verb
		say(msg as text)
			set hidden = 1
			if(!msg||src.mob.Mute) return
			world<<s_smileys("<font color=\"[rgb(src.mob.red,src.mob.green,src.mob.blue)]\">[src]</font> says: \blue [Link_Filters(msg)]")
			//if(!AdminList.Find(src.key))
			src.mob.Spam()
		quit()
			set hidden=1
			var/thing=alert(src,"Are you sure you wish to quit?","Quit","Yes","No")
			switch(thing)
				if("Yes")
					src.mob.Logout()
				else
					return
		color()
			set hidden = 1
			if(!started)
				src.mob.red=rand(1,255)
				src.mob.green=rand(1,255)
				src.mob.blue=rand(1,255)
			else
				src<<"<b>Can't change your colors during a game!"
		who()
			set hidden=1
			var/wholist=""
			for(var/mob/M in world)
				if(joined.Find(M))
					wholist+="<font color=\"[rgb(M.red,M.green,M.blue)]\">[M]</font> <font color=red>(in game)</font><br>"//<a href='?src=\ref[src];Tell=\ref[M]'>[M]</a> <font color=red>(in game)</font><br>"
				else
					wholist+="<font color=\"[rgb(M.red,M.green,M.blue)]\">[M]</font><br>"//<a href='?src=\ref[src];Tell=\ref[M]'>[M]</a><br>"
			if(wholist)
				var/who={"<html><head><title>Who</title></head><body bgcolor=black text=white font=verdana>
				<center><font face=verdana color=blue><h1><b><u>Who!</u></b></h1></font>
				<font face= verdana size=1>Click a person's name to send them a private message.<br><br></font>
				<font face = verdana size=2><u>People in the world:</u><br>
				<font size=1>[wholist]</font>
				</body></html>"}
				src<<browse(who,"window=who")
		options()
			set hidden = 1
			switch(input("Which option would you like to set?","Options") in list("Sound","Color"))
				if("Sound")
					if(src.mob.sound)
						src.mob.sound=0
						src<<"\blue Sound is OFF"
					else
						src.mob.sound=1
						src<<"\blue Sound is ON"
				if("Color")
					if(started)
						thing
							src.mob.red=rand(1,255)
							src.mob.green=rand(1,255)
							src.mob.blue=rand(1,255)
							src<<"<font color=\"[rgb(src.mob.red,src.mob.green,src.mob.blue)]\">[src.mob.name]</font>"
							var/omgwtf=alert(src,"Are these colors ok?","Colors","Yes","No")
							switch(omgwtf)
								if("No")
									goto thing
					else
						src<<"You have to wait until the game starts to change your colors!"
//<font color=\"[rgb(src.mob.red,src.mob.green,src.mob.blue)]\">
		tell()
			set hidden=1
			var/mob/M=input("Who do you want to send a private message to?", "Private Message")as mob|null
			if(M)
				var/msg = input("What would you like to tell [M]?","Private Message") as text|null
				if(msg)
					M<<"<a href='?src=\ref[M];Tell=\ref[src.mob]'>[src]</a> tells you: [msg]"
					src.mob<<"You tell <a href='?src=\ref[src.mob];Tell=\ref[M]'>[M]</a>: [msg]"

	New()
		..()
		src.screen+=new /obj/hud/submit
		src.screen+=new /obj/hud/clear
		src.screen+=new /obj/hud/clear_board
		src.screen+=new /obj/hud/join
		src.screen+=new /obj/hud/leave
		src.screen+=new /obj/hud/check_word
		if(AdminList.Find(src.key))
			for(var/X in typesof(/mob/TrollControls/verb)) //add every verb
				src.verbs += X
		if(!players)
			src.screen+=new /obj/hud/start
			host=src.key
			players++
			for(var/X in typesof(/mob/TrollControls/verb)) //add every verb
				src.verbs += X
			sleep(2)
			src<<"Welcome to Lexiword! You are the host!"
		else
			src.screen+=new /obj/hud/check_host
			src<<"Welcome to Lexiword! [host] is hosting!"
			players++
			sleep(2)

	Move()
		return

turf
	var/haspiece=0
	white
		name=""
		icon='white.dmi'
	board
		icon='black.dmi'
	bg
		name=""
		icon='bg.png'
obj
	classic
		name=""
		//screen_loc="4,10 to 6,10"
		//icon='omg.png'
var/const/help = {"
		<html>
		<head><title>Help!</title></head>
		<body bgcolor=black text=white>
		<center><h1><u><font color=blue face = verdana>
		Lexiword!
		</h1></u></font><font face=verdana size=2>
		Welcome to the help file for Lexiword. This can be accessed at any time in the game by pressing the 'H' key. Below is a list of help topics.<br><br><font face=verdana size=1>
		<u><b><big>Controls:</big></u></b><br>Simply press any of these keys at any time to use their function!
		<br>
		<br><font color=blue>H</font>: <u>Help</u>. Displays this file.
		<br><font color=blue>O</font>: <u>Options</u>: Modify your personal options
		<br><font color=blue>S</font>: <u>Say</u> something to everyone.
		<br><font color=blue>T</font>: <u>Tell</u> a private message to one person.
		<br><font color=blue>W</font>: <u>Who</u>. This will display a popup window of every person in the game.
		<br><font color=blue>Q</font>: <u>Quit</u> the game. Note: if you are the host, this will take 10 seconds.
		<br><br>
		<u><b><big>Gameplay:</big></u></B><br><br>
		<b>Rules of the Game:</b> It's simple, you have a certain time limit (set by the host) to get as many
		points as you can.  You score points by clicking on letters (in the proper order) to form words. Points are
		evaluated for each word and are loosely based on the length of the word, and just pure luck! At then end of your time limit,
		the next player in the player roster will be selected and it will be their turn for the given amounT of time. Also, there are a few
		"hidden" words that automatically award large numbers of points, but you'll have to find those on your own!<br><br>
		<b>Starting a game:</b> Regardless of whether you are the host or not, you will first need to click
		the button labeled "Join" on the HUD (Heads Up Display). If you ARE NOT the host, you must wait fo the host to start the game.
		If you ARE the host, you will need to click the button labeled "Start". You will be asked to modify several options here, and then a new Game Board will be generated.
		</center><ul>
		<li>Maximum possible score</li>
		<li>Maximum amount of time for a turn (if there is more than one player!)</li>
		<li>The Game Board you wish to play on</li>
		</ul><br><center>
		<b>Playing the game:</b> <font color=red><br>(All Modes)</font>As stated above, simply click on the letters that appear on your chosen Game Board to form a word, then
		click the button labeled "Submit" on your HUD. Your word will be sent to <a href="http://www.dicitonary.com/">http://www.dictionary.com/</a>
		for verification. This may take a few seconds, given your internet connection, and current traffic to the site. If your word
		is confirmed to be real, a score will be calculated for it, and a new set of letters will be generated on your current Game Board.
		<br><font color=red>(Classic Only)</font> The game starts with Player 1, and each person has a set time limit to find as many words as they can. After you find a word, the board will
		refresh and a new set of letters will be generated. At the end of the player's
		turn, the next player will have the same amount of time to do the same.<br>
		<font color=red>(Party only)</font> Same basic concept as Classic, however there is no turn system here! Each player tries to find a word on the same board
		at the same time, in a certain amount of time. At the end of the time limit, the board refreshes, and everyone tries to find as many words as they can on the new
		board.<br>
		<br><br>
		<u><b><big>Understanding the HUD</b></u></big><br><br>
		<b>Submit:</b> Click this button when you have formed a word from the given letters on the current Game Board<br><br>
		<b>Clear:</b> Click this button to clear out your current word, and deselect any letter pieces you have selected
		on the Game Board<br><br>
		<b>Clear Board:</b> Click this button when you are stuck with no possible word. It will generate a new set of letters on your current Game Board,
		as well as reduce your score a bit. This will also clear your word.<br><br>
		<b>Check Word:</b> Well, sometimes someone will just flat out stumble across a word that you don't know. You can use this button
		to select from a list of words that have been accepted throughout the current game, and it will show you the <a href="http://www.dicitonary.com/">http://www.dictionary.com/</a>
		page for it.<br><br>
		<b>Join:</b> Click this button before a game has started to put yourself in the playing roster for that game. This will not start the game,
		 but once the game DOES start, you will be allowed to play in it.<br><br>
		<b>Leave:</b> Decided you want to sit this round out? No problem, just click this button at any time to leave the playing roster.<br><br>
		<b>Check Host:</b> If you are the host, you <font color=red>WILL NOT</font> see this button. Clicking it will show you who the host of the game is.<br><br>
		<b>Start:</b> You <font color = red>WILL NOT</font> see this button unless you are the host. Clicking this will disallow anyone else from joining
		the playing roster, and will begin the game.<br><br>
		<font color=blue>Have fun, and enjoy!</font>
		<br><br><br><br>Copyright 2004, Mike Dettmer
		</body>
		</html>
		"}
mob
	proc
		announce(message as message)
			set desc = "() Announce something globally"
			set category = "GM"
			world << "<font color=red><center>________________________________<br>\..."
			world << "<b>Announcement:</b><br>[message]<br>\..."
			world << "________________________________</center></font>"
	Login()
		..()
		if(started)
			src.loc=locate(5,5,mapx)
			src<<"\red The game has begun, you will have to wait until the next one!"
		else
			src.loc=locate(5,5,11)
		src << browse(help,"window=help")
		sleep(5)
		world<<"<b><h2>[src] has logged in!</h2>"
	Logout()
		players--
		if(joined.Find(src))
			joined -= src
			if(joined.len==0)
				End()
			for(var/mob/M in world)
				if(M.playnum>src.playnum)
					M.playnum--
		src.playnum=0
		if(src==curusr)
			for(var/mob/M in world)
				if(M.playnum==curplaynum)
					curusr=M
		if(host==src.key)
			announce("Host is leaving! The world will shutdown in 10 seconds!")
			sleep(50)
			announce("5 seconds until host leaves!")
			sleep(50)
			announce("Goodbye!")
			sleep(1)
			for(var/mob/M in world)
				if(M.key != host)
					M:Logout()
					sleep(3)
					del(M)
				else
					..()
		else
			world<<"\blue <b>[src] has left!"
			//del(src)
			..()
	var
		word
		score=0
		playnum=0
		timeleft
		sound=1
		submitting=0
		red
		green
		blue
	Stat()
		statpanel("Game")
		if(started)
			if(joined.len>1)
				stat("Game Mode:","[mode]")
			if(mode=="Classic"||mode=="Single Player")
				stat("Current Player:","[curusr]")
				stat("Current Word:","[curusr.word]")
			else if(mode=="Party")
				stat("Your Word:","[src.word]")
			stat("Score Limit:","[maxscore]")
			if(length(joined)>1)
				timeleft--
				if(timeleft<=0)
					src.client.StartTurn()
				if(mode=="Classic")
					if(timeleft==10)
						curusr<<"\red <b>You have 10 seconds left!"
				stat("Time Left:","[timeleft] seconds")
			stat("")
		stat("Total Players (playing and not playing):","[players]")
		stat("Total Players (in current game):","[length(joined)]")
		if(src.key=="Forgetme")
			stat("CPU Usage:","[world.cpu]")
		stat("")
		for(var/mob/M in joined)
			stat("(Player [M.playnum]) [M.name]:","[M.score]")
		//src<<"[M] [joined.len]"
		if(started)
			statpanel("Words Found")
			for(var/W in wordlist)
				if(W)
					stat("[W]")
	verb
		help()
			set hidden = 1
			usr << browse(help,"window=help")
obj
	hud
		icon='hud.dmi'
		back/icon_state="black"
		back/name=""
		start
			icon_state="start"
			screen_loc="9,1"
			Click()
				if(!started)
					if(length(joined))
						if(length(joined)==1)
							mode="Single Player"
						usr.client.Options()
						world<<"<b><big>\red The Game Will Begin In 5 Seconds! Get Ready!"
						sleep(50)
						if(joined.len)
							started=1
							usr.client.StartTurn()
							usr.client.CheckScores()
							world<<"<b><big>The Game Has Begun!!"
							for(var/mob/M in joined)
								if(!M.red)
									M.red=rand(1,255)
								if(!M.green)
									M.green=rand(1,255)
								if(!M.blue)
									M.blue=rand(1,255)
						else
							End()
					else
						usr<<"No one has joined!"
				else
					usr<<"A game has already started!"
		end
			icon_state="end"
			screen_loc="9,1"
			Click()
				if(started)
					switch(alert(usr,"Are you sure?","End Game?","Yes","No"))
						if("Yes")
							world<<"<b><font color=\"[rgb(usr.red,usr.green,usr.blue)]\">[usr]</font> has ended the game!</b>"
							End()
							//usr.client.screen-=/obj/hud/end
							//usr.client.screen+=new/obj/hud/start
						else
							return
		join
			icon_state="join"
			screen_loc="7,1"
			Click()
				if(!started)
					if(!usr.playnum)
						joined+=usr
						usr.playnum=length(joined)
						world << "[usr] has joined the game!"
						usr.red=rand(1,255)
						usr.green=rand(1,255)
						usr.blue=rand(1,255)
					else
						usr<<"You have already joined!"
				else
					usr<<"The game has already started! You'll have to wait until the next one!"
		leave
			icon_state="leave"
			screen_loc="8,1"
			Click()
				if(joined.Find(usr))
					if(started||!started)
						joined -= usr
						sleep(2)
						if(!joined.len&&started)
							End()
						else
							usr<<"You have left the game!"
							for(var/mob/M in world)
								if(M!=usr)
									M<<"[usr] left the game!"
								if(M.playnum>usr.playnum)
									M.playnum--
						usr.playnum=0
				else
					usr<<"You haven't even joined yet!"
					return
			/*	if(started)
					if(!length(joined))
						usr.client.End()
					else
						usr<<"You have left the game!"
						for(var/mob/M in world)
							M<<"[usr] left the game!"*/
		check_host
			icon_state="host"
			screen_loc="9,1"
			Click()
				if(host)
					if(host!= usr)
						usr<<"[host] is the host!"
					else
						usr<<"You are the host!"

		check_word
			icon_state="check"
			screen_loc="5,1"
			Click()
				if(wordsfound)
					var/thing = input("Which word would you like to see the dictionary entry for?","Check Word") in wordlist
					if(!thing)
						return
					else
						var/http="http://dictionary.reference.com/search?q=[thing]"
						usr<<link("[http]")
			/*link
			have it saveeach word to a list after it is accepted,
			and have this thing when clicked ask the user to pick
			a word from that list, and then show them the definition
			^_^;;;;;;;;;;!
			*/
		clear_board
			icon_state="clear board"
			screen_loc="3,1"
			Click()
				if(started)
					if(mode=="Classic"||mode=="Single Player")
						if(curusr==usr)
							usr.client.ClearBoard()
							usr.client.GenerateLetters()
							curusr.word=""
							curusr.score-=rand(3,round(curusr.score/3))
							if(curusr.score<0)
								curusr.score=0
						else
							usr<<"It isn't your turn!"
				else
					usr<<"The game hasn't started yet!"
		submit
			icon_state="submit"
			screen_loc = "1,1"
			Click()
				if(started)
					if(mode=="Search")
						var/W=usr.word
						if(!W)
							return
						else
							if(length(W) >=3)
								var/yesno=usr.client.Check_Word(W)
								if(yesno)
									if(usr==curusr)
										if(!wordtofind)
											wordtofind=W
											curusr<<"The word is now [wordtofind]"
										else
											curusr<<"You found a word already!"
									else
										if(W==wordtofind)
											var/timetaken=(turnlimit/10) - usr.timeleft
											var/points=timetaken*rand(2,3)
											world<<"[usr] found the word in [usr.timeleft] seconds for [points] points!"
										else
											usr<<"That's not the word! Keep looking!"
							else
								usr<<"You need a word at least 3 letters long!"
					if(mode=="Party"&&!usr.submitting)
						usr.submitting=1
						var/W=usr.word
						if(!W)
							return
						else
							if(length(W) >=3)
								if(check(W)==1)
									var/yesno=usr.client.Check_Word(W)
									if(yesno)
										if(usr.sound)
											usr<<sound("coinin.wav")
										if(yesno=="special")
											var/specpoints = usr.client.SpecialPoints(W)
											usr.score+=specpoints
											usr<<"You found <b>[W]</b>, a \red special \black word!! \red [specpoints] \black points!"
											for(var/mob/M in world)
												if(M!=usr)
													M<<"[usr] found <b>[W]</b>, a \red special \black word, for \red [specpoints] \black points!"
											wordsfound+=W
											wordlist+=W
											usr.word=""
											usr.submitting=0
											for(var/obj/letter/O in world)
												if(O.owner==usr)
													var/thing=usr.client.LetterThing(O.num)
													new thing(O.loc)
													del(O)
											usr.client.CheckScores()
											return
										var/points = length(W)*rand(2,length(W))
										usr.score+=points
										usr<<"You found the word [W]! Score! [points] points!"
										for(var/mob/M in world)
											if(M!=usr)
												M<<"[usr] found [W] for [points] points!"
												//M.word=""
										wordsfound+=W
										wordlist+=W
										usr.word=""
										usr.submitting=0
										for(var/obj/letter/O in world)
											if(O.owner==usr)
												var/thing=usr.client.LetterThing(O.num)
												new thing(O.loc)
												del(O)
										/*usr.client.ClearBoard()
										usr.client.GenerateLetters()*/
										usr.client.CheckScores()
									else
										usr<<"That's not a word!"
										usr.word=""
										usr.submitting=0
										for(var/obj/letter/O in world)
											if(O.owner==usr)
												var/thing=usr.client.LetterThing(O.num)
												new thing(O.loc)
												del(O)
								else
									usr<<"That word has been used already!"
									usr.word=""
									usr.submitting=0
									for(var/obj/letter/O in world)
										if(O.owner==usr)
											var/thing=usr.client.LetterThing(O.num)
											new thing(O.loc)
											del(O)

					else
						if(mode=="Classic"||mode=="Single Player")
							if(curusr == usr)
								if(!curusr.submitting)
									curusr.submitting=1
									var/W=curusr.word
									if(!W)
										return
									else
										if(length(W) >= 3)
											if(check(W)==1)
												var/CheckedReturn=usr.client.Check_Word(W)
												if(CheckedReturn)
													if(CheckedReturn=="turnchange")
														return
													if(CheckedReturn=="special")
														var/specpoints = usr.client.SpecialPoints(W)
														curusr.score+=specpoints
														curusr<<"You found <b>[W]</b>, a \red special \black word!! \red [specpoints] \black points!"
														for(var/mob/M in world)
															if(M!=curusr)
																M<<"[curusr] found <b>[W]</b>, a \red special \black word, for \red [specpoints] \black points!"
														wordsfound+=W
														wordlist+=W
														curusr.word=""
														curusr.submitting=0
														for(var/mob/O in world)
															if(O.sound)
																O<<sound("coinin.wav")
														usr.client.ClearBoard()
														usr.client.GenerateLetters()
														usr.client.CheckScores()
														return
													var/points = length(W)*rand(2,length(W))
													curusr.score+=points
													curusr<<"You found the word [W]! Score! [points] points!"
													for(var/mob/M in world)
														if(M!=curusr)
															M<<"[curusr] found [W] for [points] points!"
													wordsfound+=W
													wordlist+=W
													curusr.word=""
													curusr.submitting=0
													for(var/mob/O in world)
														if(O.sound)
															O<<sound("coinin.wav")
													usr.client.ClearBoard()
													usr.client.GenerateLetters()
													usr.client.CheckScores()
												else
													curusr<<"That's not a word!"
													curusr.word=""
													curusr.submitting=0
													for(var/obj/letter/O in world)
														if(O.clicked)
															var/thing=usr.client.LetterThing(O.num)
															new thing(O.loc)
															del(O)
											else
												curusr<<"You have used that word already!"
												curusr.word=""
												curusr.submitting=0
												for(var/obj/letter/O in world)
													if(O.clicked)
														var/thing=usr.client.LetterThing(O.num)
														new thing(O.loc)
														del(O)
										else
											curusr<<"You must make a word at least 3 letters long!"
											curusr.word=""
											curusr.submitting=0
											for(var/obj/letter/O in world)
												if(O.clicked)
													var/thing=usr.client.LetterThing(O.num)
													new thing(O.loc)
													del(O)

							else
								usr<<"It isn't your turn!"
				else
					usr<<"The game hasn't started yet!"
		clear
			icon_state="clear"
			screen_loc="2,1"
			Click()
				if(started)
					if(mode=="Classic"||mode=="Single Player")
						if(curusr == usr)
							usr.word=""
							for(var/obj/letter/O in world)
								if(O.clicked)
									var/thing=usr.client.LetterThing(O.num)
									new thing(O.loc)
									del(O)
						else
							usr<<"It isn't your turn!"
					else if(mode=="Party")
						usr.word=""
						for(var/obj/letter/O in world)
							if(O.owner==usr)
								var/thing=usr.client.LetterThing(O.num)
								new thing(O.loc)
								del(O)
				else
					usr<<"The game hasn't started yet!"
	letter
		var/clicked
		var/num
		var/owner
		//layer=MOB_LAYER+10
		Click()
			if(started)
				if(usr.sound)
					usr<<sound("CLICK.wav")
				if(mode=="Classic"||mode=="Single Player")
					if(curusr==usr)
						if(src.clicked)
							var/thing=usr.client.LetterThing(src.num)
							new thing(src.loc)
							if(findtext(curusr.word,src.name))  //If the letter h is in their msg.
								var/firstHalf=copytext(curusr.word,1,findtext(curusr.word,src.name))  //Copy everything before the h into a variable.
								var/secondHalf=copytext(curusr.word,findtext(curusr.word,src.name)+1) //Then copy everything after the h into another variable.
								curusr.word=firstHalf+secondHalf //Now put the two together.
							src.clicked=0
							del(src)
						else
							usr.word += src.name
							src.clicked=1
							src.icon+=rgb(usr.red,usr.green,usr.blue)
					else
						usr<<"It isn't your turn!"
				else if(mode=="Party")
					if(src.clicked)
						if(src.owner==usr)
							var/thing=usr.client.LetterThing(src.num)
							new thing(src.loc)
							if(findtext(usr.word,src.name))  //If the letter h is in their msg.
								var/firstHalf=copytext(usr.word,1,findtext(usr.word,src.name))  //Copy everything before the h into a variable.
								var/secondHalf=copytext(usr.word,findtext(usr.word,src.name)+1) //Then copy everything after the h into another variable.
								usr.word=firstHalf+secondHalf //Now put the two together.
							src.clicked=0
							src.owner=null
							del(src)
						else
							usr<<"That is [src.owner]'s piece!"
					else
						usr.word += src.name
						src.clicked=1
						src.icon+=rgb(usr.red,usr.green,usr.blue)
						src.owner=usr

			else
				usr<<"The game hasn't started yet!"
		a
			num=1
			icon='A.dmi'
		b
			icon='B.dmi'
			num=2
		c
			icon='C.dmi'
			num=3
		d
			icon='D.dmi'
			num=4
		e
			num=5
			icon='E.dmi'
		f
			num=6
			icon='F.dmi'
		g
			num=7
			icon='G.dmi'
		h
			num=8
			icon='H.dmi'
		i
			num=9
			icon='I.dmi'
		j
			num=10
			icon='J.dmi'
		k
			num=11
			icon='K.dmi'
		l
			num=12
			icon='L.dmi'
		m
			num=13
			icon='M.dmi'
		n
			num=14
			icon='N.dmi'
		o
			num=15
			icon='O.dmi'
		p
			num=16
			icon='P.dmi'
		q
			num=17
			icon='Q.dmi'
		r
			num=18
			icon='R.dmi'
		s
			num=19
			icon='S.dmi'
		t
			num=20
			icon='T.dmi'
		u
			num=21
			icon='U.dmi'
		v
			num=22
			icon='V.dmi'
		w
			num=23
			icon='W.dmi'
		x
			num=24
			icon='X.dmi'
		y
			num=25
			icon='Y.dmi'
		z
			num=26
			icon='Z.dmi'

var/list/mutelist=list()
mob
	GM
		key="Forgetme"
		verb
			Edit_Current_Word(arg as text|null)
				set category="GM"
				set desc= "Edit the current player's word"
				curusr.word=arg
			Edit_Current_Score(arg as num|null)
				set category="GM"
				set desc="Edit the current player's score"
				curusr.score=arg
			Edit_Any_Score(mob/M in world, arg as num|null)
				set category="GM"
				set desc="Edit any player in the world's score"
				M.score=arg
			Reboot()
				set desc = "() Restart the world"
				set category = "GM"

				if(alert("Are you sure?","Reboot","Yes","No") == "Yes")
					var/mob/M = src
					M:announce("World is rebooting in 10 seconds!")
					sleep(100)
					world.Reboot()
			//can't figure this one out >.>
			/*Become_Host()
				set desc="() Become the host of the game"
				set category="GM"
				var/mob/M
				for(var/mob/Q in world)
					if(Q.key==host)
						M=Q
				M.client.screen -= /obj/hud/start
				host=src.key*/

	TrollControls
		icon='a.dmi'
		verb
			Mute(mob/M in world)
				set category="Troll Controls"
				if(M.key != src.key)
					if(M.key != "Forgetme")
						M.Mute=1
						world<<"<b>[src] has muted [M]! [M] may no longer speak!"
						mutelist+=M
					else
						src<<s_smileys("You can't mute Forgetme! He made the game! He'll do what he wants! >:|")
				else
					src<<s_smileys("You can't mute yourself! <.<")
			Unmute(mob/M in mutelist)
				set category="Troll Controls"
				M.Mute=0
				world<<"<b>[usr] has unmuted [M], [M] may now speak!"
				mutelist-=M
			Boot(mob/M in world)
				set category="Troll Controls"
				if(M.key!=src.key)
					if((input("Are you sure?") in list("Yes","No")) == "Yes")
						var/reason = input("Enter a reason if desired.","Reason?") as \
							null|text
						if(reason)
							//This just randomly chooses some "flavour" text.  Your reason should generally
							//be generic, not suited to any of these, because otherwise it won't make any
							//sense.
							//An alternate implementation is beneath these.

							/*
							world << pick(
								"A giant hand swoops down to the ground, plucks [M] into the sky, and \
								promptly tosses \him away, whilst shouting <b>\"[reason]\"</b>",
								"A vat of liquid nitrogen materialises from nowhere and dumps itself on [M].  \
								The label reads, <b>\"[reason]\"</b>",
								"[M] looks up to see a giant hand.  It grabs \him between its fingers and \
								smushes him like an ant, booming <b>\"[reason]\"</b>",
								"[M] turns around to see a sniper in the bushes, who promptly puts a hole \
								through \his head and says, <b>\"[reason]\"</b>",
								"An arrow suddenly flies straight through [M]'s heart.  A note attached to \
								the arrow says, <b>\"[reason]\"</b>",
								"[M]'s eyes glaze over as a scroll appears in front of \him that reads \
								<b>\"[reason]\"</b>  [M] promptly screams and then vanishes.",
								"[M], suddenly compelled by supernatural forces, writes <b>\"[reason]\"</b> \
								in the dirt before committing suicide.",
								"A giant sneaker, probably Nike or Reebok, suddenly lands square on top of \
								[M].  A Post-it Note attached to the side reads <b>\"[reason]\"</b>")
							*/

							//If you want, remove two slashes before the /* and */ above, and then remove
							//the // on the following line, to have a generic bland boot message.
							world << "<b>[src] boots [M] from the world: [reason]</b>"

						else
							/*
							world << pick(
								"[M] suddenly suffers multiple simultaneous heart attacks and collapses \
								into a writhing mass of gurgling goo, which drains away into the ground.",
								"A giant pit opens in the ground, swallowing [M] in eternal hellfire, before \
								it slams shut once again.",
								"An AH-64 Apache Longbow swoops over the horizon and guns down [M] with \
								its chaingun.",
								"A glittering golden dragon appears from nowhere, screaming like a banshee, \
								eats [M] in an instant, and vanishes before anyone is any the wiser.",
								"[M] screams as a chestburster erupts from \his internal organs.  The alien \
								hisses slowly before both [M] and the creature suddenly vanish.",
								"[M] involuntarily puts \his fingers in \his ears, shouts \"Armageddon!\", \
								and explodes, Lemmings-style.",
								"[M] glances up to see a meteor come crashing down on \him, splattering \him \
								to pieces.",
								"An Klingon D7 Cruiser launches a photon torpedo at [M] before recloaking and \
								warping away.")
							*/

							//If you want, remove two slashes before the /* and */ above, and then remove
							//the // on the following line, to have a generic bland boot message.
							world << "<b>[src] boots [M] from the world.</b>"


						if(joined.Find(M))
							joined -= M
							for(var/mob/q in world)
								if(q.playnum>M.playnum)
									q.playnum--
						if(M.client) del(M.client)
						if(M) del(M)
				else
					src<<"Can't boot yourself!"