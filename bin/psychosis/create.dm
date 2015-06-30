mob
	proc
		Save(mob/M)
			if(M.z!=11)
				var/savefile/F=new("saves/[M.ckey]/psycho.forgetme")
				F["savex"] << M.x
				F["savey"] << M.y
				F["savez"] << M.z
				F["state"] << M.icon_state
				M.Write(F)

		Load(mob/M)
			var/savefile/F=new("saves/[M.ckey]/psycho.forgetme")
			var/X
			var/Y
			var/Z
			var/state
			F["savex"] >> X
			F["savey"] >> Y
			F["savez"] >> Z
			F["state"] >> state
			M.Read(F)
			M.icon_state=state
			M.loc=locate(X,Y,Z)
			M.umsl_locks = list()

		NewChar(mob/M)
			if(fexists("saves/[src.ckey]/psycho.forgetme"))
				if(alert(M,"If you create a new character, your old one will be deleted! Is this cool?","Alert!","Yes","No")=="Yes")
					goto createnew
				else
					return
			createnew
				var/omg=rand(10001,19999)
				M.ID = omg
				M.contents+=new /obj/guns/fists
				//M.contents+=new /obj/guns/handgun
				M.loc = locate(1,1,1)
				M.icon_state="player"
				F_Click_Menu.cmenu_Show(M.client)
				Save(M)

		CharacterStuff()
			if(!src.asking)
				src.asking=1
				var/list/asklist = list ("Create New Character")
				if(fexists(file("saves/[src.ckey]/psycho.forgetme")))
					asklist+= "Load Old Character"
				asklist+="Cancel"
				var/ask=input("What would you like to do?","[world.name]") in asklist
				switch(ask)
					if("Create New Character")
						NewChar(src)
					if("Load Old Character")
						Load(src)
					if("delete")
						del(file("saves/[src.ckey]/psycho.forgetme"))
						//make this work
				src.asking=0