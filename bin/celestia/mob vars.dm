


mob
	var
		startx=0
		starty=0
		startz=0
		hp=50
		maxhp=50
		energy
		maxenergy
		strength
		damage
		fighting
		class="NPC"
		ammo=25
		nades=10
		attackdelay=5
		CharPoints=200
		race
		mob/curtarget

		cmdx
		cmdy



//hidden
	athf

		icon='athf.dmi'
		Login()
			src.icon_state=input("o","o") in list("frylock","meatwad","shake")
			..()
		frylock
			icon_state="frylock"
		meatwad
			icon_state="meatwad"
		master_shake
			icon_state="shake"

