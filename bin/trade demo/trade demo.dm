/*
##########################
##trade demo by forgetme##
##########################

	i made this because i haven't been able to find any demos to show how to make a trade system.
	after alot of searching, i decided to just make my own. the verb is really plug and play,
	just modify the word "player" after every instance of mob to suit your game. enjoy.
	i hope this helps someone.

	NOTE--
		i believe in open source, and i don't like when people ask for credit for their open
		source code. if you use this, it'd be cool if you gave me a credit somewhere, but don't
		think it's necessary. this is here to make it easier on people (i'm going to turn it
		into a lib eventually, anyway).
*/


mob
	player
		icon='icon.dmi'
		icon_state="mob"
		verb
			Trade(mob/player/M in view())
				set category="Actions"
				label1
					var/obj/tradeitem=input("Which item do you wish to trade?","Trade") in usr.contents
					if(!tradeitem)
						usr<<"\yellow<small>System:</small>\black<small> You don't have anything to trade [M]!"
						return 0
					var/thing=alert(M,"[usr] wants to trade you their [tradeitem]. Do you accept?", "Trade","Yes","No")
					switch(thing)
						if("Yes")
							if(tradeitem.equipped)
								alert(usr,"You must unequip [tradeitem] first!")
								alert(M,"[usr] has to unequip [tradeitem] first!")
								goto label1
							else
								label2
									var/obj/trade2=input("Which item do you want to trade for [usr]'s [tradeitem]?","Trade") in M.contents
									if(!trade2)
										M<<"\yellow<small>System:</small>\black<small> You don't have anything to trade [usr]!"
										return 0
									if(trade2.equipped)
										alert(M,"You must unequip [trade2] first!")
										alert(usr,"[M] has to unequip [trade2] first!")
										goto label2
									else
										var/thing2=alert(usr,"[M] wants to trade you their [trade2] for your [tradeitem]. Do you accept?","Trade","Yes","No")
										switch(thing2)
											if("Yes")
												M.contents -= trade2
												usr.contents+=trade2
												usr.contents-=tradeitem
												M.contents+=tradeitem
												M<<"\yellow<small>System:</small>\black You traded your [trade2] to [usr] for their [tradeitem]!"
												usr<<"\yellow<small>System:</small>\black You traded your [tradeitem] to [M] for their [trade2]!"
											if("No")
												usr<<"\yellow<small>System:</small>\black <b>[M] declined!"
												return
						if("No")
							usr<<"\yellow<small>System:</small>\black <b>[M] declined!"
							return




//simple demo stuff from here down,
//don't worry about this stuff

mob
	Login()
		..()
		src.contents+=new/obj/Armor
		src.contents+=new/obj/Weapon
	Stat()
		statpanel("Inv", src.contents)


world
	hub="Forgetme.TradeDemo"
	mob=/mob/player
obj
	var
		equipped=0
	icon='icon.dmi'
	Armor
		icon_state="armor"
	Weapon
		icon_state="weapon"