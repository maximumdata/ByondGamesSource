

obj
	Click()
		..()
		src.Get()
	verb/Get()
		set src in oview(1)
		set category = null
		src.Move(usr)
	ores
		tin
			text="<font bgcolor=#cccccc> "
		copper
			text="<font bgcolor=#F2cc50> "
		iron
			text="<font bgcolor=#505050> "
		black
			text="<font bgcolor=#010101> "


turf
	smelter
		density=1
		icon='icons.dmi'
		icon_state="smelt"
		Click()
			//if(usr in oview(1,src))
			src.Smelt()
		verb/Smelt()
			set hidden = 1
			set src in oview(1)
			usr.ores=1
			var/obj/ores/list/userores=list()
			for(var/obj/ores/Ore in usr.contents)
				userores.Add(Ore)
			if(userores.len<2)
				usr<<"You don't have enough ores to smelt!"
				return null
				usr.ores=0
			userores+="Cancel"
			usr << browse(smeltingpage)
			var/obj/ores/list/smeltores[2]
			smeltores[1] = input("Please choose the first ore to smelt.","Smelt") in userores
			if(smeltores[1]=="Cancel")
				return
				usr.ores=0
			userores -= smeltores[1]
			smeltores[2] = input("Please choose the second ore.","Smelt") in userores
			if(smeltores[2]=="Cancel")
				return
				usr.ores=0
			userores -= smeltores[2]
			var
				tin
				copper
				black
				iron
				x
			var/obj/newbar
			for(x=1;x<3;x++)
				if(istype(smeltores[x],/obj/ores/tin))
					tin++
				if(istype(smeltores[x],/obj/ores/copper))
					copper++
				if(istype(smeltores[x],/obj/ores/black))
					black++
				if(istype(smeltores[x],/obj/ores/iron))
					iron++
				usr.contents.Remove(smeltores[x])
			if(tin&&iron)
				newbar=new /obj/bars/steel
			if(tin&&black)
				newbar=new/obj/bars/platinum
			if(tin&&copper)
				newbar=new/obj/bars/nickel
			if(copper&&black)
				newbar=new/obj/bars/cobalt
			if(copper&&iron)
				newbar=new/obj/bars/gold
			if(iron&&black)
				newbar=new/obj/bars/titanium
			if(tin&&!iron&&!copper&&!black)
				newbar=new/obj/bars/tin
			if(!tin&&iron&&!copper&&!black)
				newbar=new/obj/bars/iron
			if(!tin&&!iron&&copper&&!black)
				newbar=new/obj/bars/copper
			if(!tin&&!iron&&!copper&&black)
				newbar=new/obj/bars/black
			if(newbar)
				usr<<"You created a [newbar.name]!"
				newbar.Move(usr)
				usr.ores=0

