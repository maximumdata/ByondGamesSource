/*


	This is the code featured in my upcoming RPG. I got real sick of people asking
	for GM in all my games, so this is a little proc to take care of them.


	*************
	**IMPORTANT**
	*************
	For this to work, you must set /mob/var/GMguard in YOUR code to the number of
	times people are allowed to ask for GM before being taken care of!

							SEE DEMO FOR EXAMPLE!!!!

*/

mob
	var
		GMguard = 3   		//MAKE SURE YOU SET THIS VAR IN YOUR PLAYER MOB!!!!!
		GMask = 0			//leave this one as is.

		GMlist= list("can i be gm", "can i be GM","can i be gm?", "can i be GM?", "Can I be GM?", "Can i be gm?", "how can i get gm?", "How can i get gm?", "how can i get GM?", "How can i get GM?")
		// these are the strings that aren't allowed, this will be
		// updated almost daily for the next few weeks


	proc
		GMguard(M as text)
			if(M in GMlist)
				src.GMask++
				goto RemoveNoob
				return 0
			else
				return 1
			RemoveNoob
				if(src.GMask >= src.GMguard)
					src<<"You are a \yellow complete\black and\red utter\blue NOOB!!!\black STOP ASKING FOR GM!!! GOODBYE!!!"
					spawn(2)
					del(src)
				else
					return


