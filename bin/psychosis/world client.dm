
client
	command_text=".alt "

world
	name= "...psychosis"
	hub="Forgetme.psychosis"
	//hub="Xooxer.Chatters"
	turf=/turf/thing
	view=5
	mob=/mob/player

mob
	verb
		thing(arg as text|null)
			set name = ">"
			set hidden = 1
			world<<"[arg]"
	creating




proc
	specialchars(arg as text)
		var/newone=arg
		var/flag
		for(flag=1; flag <= 3; flag++)
			if(findText(newone, "3/4"))
				var/firstHalf=copytext(arg,1,findtext(arg, "3/4"))
				var/secondHalf=copytext(arg,findtext(arg, "3/4")+3)
				newone=firstHalf+" &#190; "+secondHalf
			if(findText(newone, "1/2"))
				var/firstHalf=copytext(arg,1,findtext(arg, "1/2"))
				var/secondHalf=copytext(arg,findtext(arg, "1/2")+3)
				newone=firstHalf+" &#189; "+secondHalf
		return newone

f_cmenu_control
	cmenu_text_color = "#FF0000"
	cmenu_highlight_color = "#FFFFFF"
	cmenu_background_color = "#000000"

f_click_menu
	Options
		Sound
			cmenu_Clicked_By(client/C)
				if(C.mob.sound)
					C.mob.sound=0
					C.mob<<"Sound off"
				else
					C.mob.sound=1
					C.mob<<"Sound on"
		Auto_Switch
			cmenu_Clicked_By(client/C)
				if(C.mob.autoswitch)
					C.mob.autoswitch=0
					C.mob<<"Autoswitch of weapons off"
				else
					C.mob.autoswitch=1
					C.mob<<"Autoswitch of weapons on"
		Quit
			cmenu_Clicked_By(client/C)
				if(alert(C, "Are you sure you want to quit?", "Quit?", "YES", "NO") == "YES")
					del C.mob
					del C


	Help
		Help_On
			cmenu_Clicked_By(client/C)
				C << "<b>Sorry, no help available at the moment!</b>"

		About
			cmenu_Clicked_By(client/C)
				var/HTML = "<center><b><font color = blue>F_Click_Menu</font>\
				</b></center><br><br>"
				HTML += "A simple to use menu system for your games."
				HTML += "<br><b>Created By:</b> Flick"
				HTML += "<br><b>Version:</b> 1"
				C << browse(HTML)


