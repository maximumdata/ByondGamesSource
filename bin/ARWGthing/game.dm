//OPTIONS
var
	numRounds=6
	timeDefine=450
	timeVote=300
	lenWord=0
//VARS FOR CURRENT PART OF ROND
	defining
	voting


//BEGIN GAME CONTROL PROCS

proc	//this is gonna be very sloppy, i bet. forgive me.
	ChooseOptions()
		chooseRounds:
			numRounds=input("What should the number of rounds be? (3-10, Default 6) ","Options") as num
			if(numRounds<3||numRounds>10)
				usr<<"Please chooes a number between <b>3 and 10</b>"
				goto chooseRounds
			else
				goto chooseTimeDef
		chooseTimeDef:
			timeDefine=input("How long (in seconds) should players have to define the acronym? (30-90, Default 45)","Options") as num
			if(timeDefine<30||timeDefine>90)
				usr<<"Please choose a number between <b>30 and 90</b>"
				goto chooseTimeDef
			else
				timeDefine*=10
				goto chooseTimeVote
		chooseTimeVote:
			timeVote=input("How long (in seconds) should players have to vote? (15-45, Default 30)","Options") as num
			if(timeVote<15||timeVote>45)
				usr<<"Please choose a number between <b>15 and 45</b>"
				goto chooseTimeVote
			else
				timeVote*=10
				goto chooseLenWord
		chooseLenWord:
			lenWord=input("How long should each acronym be? Enter 0 for random (2-6, Default \[random 2-6\])","Options") as num
			if(!lenWord)
				goto done
			if(lenWord<2||lenWord>6)
				usr<<"Please choose a number between <b>2 and 6</b>"
				goto chooseLenWord
			else
				goto done
		done:
			Start()

	EndGame(mob/winner, winscore as num)
		if(Start)
			if(!winner&&!winscore)
				world<<"<br><center><b>\red The game has ended with no winner!"
			else
				world<<"<br><center><b>\red [winner.name] has won the game with [winscore]!"
			Start=0
			defining=0
			voting=0
			for(var/mob/M in world)
				if(M.Player)
					M.verbs -= /mob/leave/verb/Leave
					M.verbs += /mob/verb/Join
				M.verbs -= /mob/host/verb/Start_Game
				M.verbs -= /mob/host/verb/End_Game
				M.Player=null
				M.wins=null
				M.votes=null
				M.client.command_text="say \""
			Players=null
			numRounds=6
			timeDefine=450
			timeVote=300
			lenWord=0

	Start()
		world<<"<br><center><b>Starting game in 10 seconds!</b></center>"
		Start=1
		sleep(100)
		if(Start)
			world<<"<center><b>\red The game has begun!"
			usr.verbs -= /mob/host/verb/Start_Game
			usr.verbs += /mob/host/verb/End_Game
			Round()
		else
			return

	Round()//this is probably completely confusing, however, i plan on sprucing this up
		   //perhaps you should just leave this part to me? i'm not even sure how to explain half of it.
		var/Roundcount;var/word
		start:
			if(!Start||Start==0)
				EvalGame()
				return
			defining=1
			Roundcount++
			word=GetWord(lenWord)
			world<<"<br><center><hr><br>\red The word is [word]<hr></center>"
			for(var/mob/P in world)
				if(P.Player)
					P.definition=""
					P.votes = 0
					P.voted=0
					P.client.command_text="define \""
			for(var/obj/Character/c in world)
				del(c)
			for(timeleft=0;timeleft<timeDefine;timeleft+=10)
				sleep(10)
			if(!Start)
				EvalGame()
				return
			timeleft=0
			defining=0
			voting=1
			world<<"<br><center>\red <hr><br>Time's up for definitions! Get ready to vote!<hr>"
			for(var/mob/P in world)
				if(P.Player)
					P.client.command_text="vote "
			for(votetime=0;votetime<timeVote;votetime+=10)
				sleep(10)
			if(!Start)
				EvalGame()
				return
			votetime=0
			voting=0
			for(var/mob/P in world)
				if(P.Player)
					P.client.command_text="say \""
			EvalRound()
			if(Roundcount < numRounds&&Start==1)
				if(Start!=0)
					goto start
				else
					EvalGame()
			else
				EvalGame()

	EvalGame()
		var/highestwins=0
		for(var/mob/M in world)
			if(M.wins > highestwins)
				highestwins=M.wins
		for(var/mob/M in world)
			if(M.wins==highestwins)
				EndGame(M,M.wins)
	EvalRound()
		var/highestscore=0;var/mob/winner;var/mob/tier
		for(var/mob/M in world)
			if(M.Player)
				if(M.votes >= highestscore)
					highestscore=M.votes
		if(!highestscore)
			world<<"<br><center>\red <b>Nobody won this round!"
			return
		for(var/mob/M in world)
			if(M.votes==highestscore)
				if(!winner)
					winner=M
					goto single
				else
					tier=M
					goto tie
		single:
			world<<"<br><center>\red <b>[winner.name] has won this round with [highestscore] votes!"
			return
		tie:
			world<<"<br><center>\red <b>There was a tie between [winner.name] and [tier.name]!"
			return

	GetWord(length as num)
		var/newword
		var/i
		if(length)
			i=length
			while(i)
				newword+=pick(Alphabet)
				i--
		else
			i=rand(2,6)
			while(i)
				newword+=pick(Alphabet)
				i--
		return(newword)


//END GAME CONTROL PROCS!!!
var/timeleft;var/votetime

var/list/Alphabet = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
//BEGIN GAMEPLAY VERBS

mob/verb
	define(def as text)
		set hidden=1
		if(Start&&src.Player)
			if(!src.definition)
				if(defining)
					TexttoMap("Player [src.Player]: [def]",usr)
					src.definition=def
					src.client.command_text="say \""
				else
					src<<"\red <b>Too slow! Try to be faster next time!"
			else
				src<<"\red<b>You've already made a definition for this acronymn!"

	vote(player as num)
		set hidden=1
		if(Start&&src.Player)
			if(!src.voted)
				if(voting)
					if(player > Players)
						src<<"<b>\red Invalid Player number!!!"
						src.vote()
						return
					else
						for(var/mob/M in world)
							if(M.Player == player)
								M.votes++
						src.voted=1
						src.client.command_text="say \""
				else
					src<<"\red<b> Too late! Be quicker next time, yeah?"
			else
				src<<"\red<b> You've already voted this round!"