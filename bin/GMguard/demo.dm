
/*

	This is to demonstrate the implementation of this library.
	See comments on the mob.

*/

//#include <forgetme/gmguard>
//important line here...if you want to use the library at all.
//you can also click the checkbox next to forgetme.GMguard
//in the lib folder over there
//					<------

mob
	icon='mob.dmi'

	//THIS IS THE ABSOLUTE MOST IMPORTANT PART OF IMPLEMENTATION
	//simply add the line if(GMguard(msg)) to your communication verbs (OOC, Say, Shout...etc)
	//the proc will return a 1 if the message is safe, so put your actual code to display
	//the message under the if, and then handle if they DO ask for GM under an else.
	//This could also be used to return a message with a link to info for properly requesting
	//GM. If you do this, and decide that asking for GM is not a harsh offense, just set
	//the variable mob/var/GMguard to an insanely high number, and that way, hopefully, the user
	//won't ever be kicked if they ask.

	verb
		say(msg as text)
			if(GMguard(msg))	//add this line.
				world<<"[src]: [msg]"
			else
				usr<<"You are a nublet, my friend. Don't ask for GM."


	n00b
		GMguard = 2		//you MUST set this var if you want people to be able to ask
						//a different amount of times than the default (3)





//useless junk...
turf
	turf
		icon='mob.dmi'
		icon_state="turf"


world
	mob=/mob/n00b