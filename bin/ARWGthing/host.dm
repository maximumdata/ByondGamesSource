


mob/host/verb
	Start_Game()
		set category = "Host"
		if(!Start)
			var/ask= alert(src,"Would you like to set custom options, or use the defaults?","Start Game","Default","Custom")
			switch(ask)
				if("Default")
					Start()
				if("Custom")
					ChooseOptions()

	End_Game()
		set category="Host"
		EndGame()
