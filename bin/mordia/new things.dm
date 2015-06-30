/*
//change these to move the center of the window
var
	midx = 3
	midy = 3
mob

	var/tmp //vars used to keep track of objects displayed
		obj
			curspell
		curspellnum = 1
		hud
			__hud_test = new()
			spellmenu
				__hud_spells = new()
		spellmenuup = 0
		obj/spell_menu
			top
				__s_t = new()
			mid
				__s_m = new()
			bot
				__s_b = new()
			left
				__s_l = new()
			right
				__s_r = new()
			tl
				__s_tl = new()
			tr
				__s_tr = new()
			bl
				__s_bl = new()
			br
				__s_br = new()
			use
				__s_use = new()
			lb
				__s_lb = new()
			rb
				__s_rb = new()
	Login()
		..()
		if(client) //add bottom hud bar
			client.screen += __hud_test
			client.screen += __hud_spells

	proc
		DispspellMenu()
			if(!spellmenuup) //if the menu isn't on
				client.screen += __s_t //add the menu
				client.screen += __s_m
				client.screen += __s_b
				client.screen += __s_l
				client.screen += __s_r
				client.screen += __s_tl
				client.screen += __s_tr
				client.screen += __s_bl
				client.screen += __s_br
				client.screen += __s_use

				if(contents.len > 1) //olny use the buttons if there's more than 1 spell
					client.screen += __s_lb
					client.screen += __s_rb

				if(!curspell && contents.len) //set the inital spell if needed
					curspell = contents[curspellnum]

				if(curspell) //display initial spell if needed
					client.screen += curspell

				spellmenuup = 1
			else //if it is on
				client.screen -= __s_t //remove it
				client.screen -= __s_m
				client.screen -= __s_b
				client.screen -= __s_l
				client.screen -= __s_r
				client.screen -= __s_tl
				client.screen -= __s_tr
				client.screen -= __s_bl
				client.screen -= __s_br
				client.screen -= __s_use
				client.screen -= __s_lb
				client.screen -= __s_rb

				if(curspell) //remove displayed spell if needed
					client.screen -= curspell
				spellmenuup = 0


obj
	proc
		Use(mob/M) //proc called when it is used(M is the person using it)

obj/spell_menu //menu part definitions
	name = ""
	icon = 'item_menu.dmi'
	top
		icon_state = "top"
		New()
			. = ..()
			screen_loc = "[midx],[midy + 1]"
	mid
		icon_state = "mid"
		New()
			. = ..()
			screen_loc = "[midx],[midy]"
	bot
		icon_state = "bottom"
		New()
			. = ..()
			screen_loc = "[midx],[midy - 1]"
	left
		icon_state = "left"
		New()
			. = ..()
			screen_loc = "[midx - 1],[midy]"
	right
		icon_state = "right"
		New()
			. = ..()
			screen_loc = "[midx + 1],[midy]"
	tr
		icon_state = "topright"
		New()
			. = ..()
			screen_loc = "[midx + 1],[midy + 1]"
	tl
		icon_state = "topleft"
		New()
			. = ..()
			screen_loc = "[midx - 1],[midy + 1]"
	br
		icon_state = "bottomright"
		New()
			. = ..()
			screen_loc = "[midx + 1],[midy - 1]"
	bl
		icon_state = "bottomleft"
		New()
			. = ..()
			screen_loc = "[midx - 1],[midy - 1]"
	use
		icon_state = "use"
		New()
			. = ..()
			screen_loc = "[midx],[midy - 1]"
		MouseEntered() //change the icon state if it's hovered over
			icon_state = "useo"
		MouseExited()
			icon_state = "use"
		Click()
			if(usr.curspell) //if there's a selected spell...
				usr.curspell.Use(usr) //use it
				usr.client.screen -= usr.curspell

				if(usr.contents.len) //if there's anything in the contents at all
					if(usr.curspellnum > usr.contents.len)			//if spell was deleted
						usr.curspellnum = 1							//and the position is
						usr.curspell = usr.contents[usr.curspellnum]  //no longer valid
						usr.client.screen += usr.curspell

					else
						usr.curspell = usr.contents[usr.curspellnum]
						usr.client.screen += usr.curspell

					if(usr.contents.len == 1) //remove the buttons if needed
						usr.client.screen -= usr.__s_lb
						usr.client.screen -= usr.__s_rb

				else
					usr.curspellnum = 1
					usr.DispspellMenu() //remove spell menu


	lb
		icon_state = "leftb"
		New()
			. = ..()
			screen_loc = "[midx - 1],[midy]"
		MouseEntered()
			icon_state = "leftbo"
		MouseExited()
			icon_state = "leftb"
		Click()
			usr.client.screen -= usr.curspell //remove the currently displayed spell
			usr.curspellnum-- //find the in of the spell "below" the current one
			if(usr.curspellnum <= 0) //if it's invalid
				usr.curspellnum = usr.contents.len //set it to the "top" spell

			if(usr.contents.len) //if there's anything in contents
				usr.curspell = usr.contents[usr.curspellnum] //set the curspell var
				usr.client.screen += usr.curspell //display the new one

			else
				usr.curspellnum = 1
				usr.DispspellMenu() //remove spell menu

	rb
		icon_state = "rightb"
		New()
			. = ..()
			screen_loc = "[midx + 1],[midy]"
		MouseEntered()
			icon_state = "rightbo"
		MouseExited()
			icon_state = "rightb"
		Click()
			usr.client.screen -= usr.curspell //remove the currently displayed spell
			usr.curspellnum++ //find the in of the spell "above" the current one
			if(usr.curspellnum >= usr.contents.len+1) //if it's invalid
				usr.curspellnum = 1 //set it to the "bottom" spell

			if(usr.contents.len) //if there's anything in contents
				usr.curspell = usr.contents[usr.curspellnum] //set the curspell var
				usr.client.screen += usr.curspell //display the new one

			else
				usr.curspellnum = 1
				usr.DispspellMenu() //remove spell menu

hud
	parent_type = /obj
	name = ""
	MouseEntered()
		icon_state = "over"
	MouseExited()
		icon_state = ""
	New()
		. = ..()
		screen_loc = "1,1 to 11,1"
	icon = 'base.dmi'
	spellmenu
		icon = 'itemmenu.dmi'
		New()
			..()
			screen_loc = "2,1"
		Click()
			spawn() usr.DispspellMenu() //display the spell menu


obj //demo objs
	New()
		. = ..()
		screen_loc = "[midx],[midy]" //set the obj's screen_loc to the middle panel's
*/