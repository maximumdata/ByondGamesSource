

//CREATE CHARACTER
mob/var/charlist
mob/var/itemlist
mob/create
	New()
		src.itemlist+=list(new /obj/items/armor, new /obj/items/guns/gun1)
	Login()
		src.loc=locate(48,48,16)
		src.client.view=8
		src.racething+="<h3><font color=blue>Race</font></h3><small>(Click the race's name to select it. It's cost is displayed next it's the name.)</small><br><br>"
		src.itemsthing+="<h3><font color=blue>Items</font></h3><small>Click done when you've finished selecting your items.</small><br><br>"
		for(var/obj/B in src.itemlist)
			//src<<browse_rsc(B.icon)	<img src=[B.icon]>
			src.itemsthing += {"
			<font color=yellow><u>[B.name]</u></font> - [B.itemdesc] Cost: [B.cost] CP <a href='?src=\ref[src];action=buy;item=[B.type];cost=[B.cost]'>Buy</a>
			<br><br>
			"}
		src.itemsthing+="<a href='?\ref[src];action=donewithitems'>Done</a>"
turf/title
	icon='create.png'
	name=""
	density=1
turf/NewChar
	name=""
	density=1
	Click()
		if(usr.type==/mob/create)
			usr.CreateChar()
turf/OldChar
	name=""
	density=1
	Click()
		if(usr.type==/mob/create)
			if(alert(usr,"Are you sure you want to load an old character?","Load Character","Yes","No")=="Yes")
				usr.Load(usr)

mob/var/racething = {"<html><head><style>BODY{ font-size = 8pt; color=#FFFFFF; background: #000000}A:link{color:#FF0000}A:active{color=#FFFFFF}A:visited{color=#FF0000}</style>
<title>Character Creation</title></head><body><center>"}
mob/var/itemsthing=	{"<html><head><style>BODY{ font-size = 8pt; color=#FFFFFF; background: #000000}A:link{color:#FF0000}A:active{color=#FFFFFF}A:visited{color=#FF0000}</style>
<title>Character Custimization</title></head><body><center>"}
//TOPIC FOR CREATING
mob
	var/const/GWinfo={"sdhabergf"}
	var/chartype
	create
		Topic(href,href_list[])
			if(href_list["type"])
				if(src.type==/mob/create)
					var/M = href_list["type"]
					src.chartype=M
					src.CharPoints-=text2num(href_list["cost"])
					alert(src,"You have [src.CharPoints] CP left.")
			if(href_list["action"])
				var/action=href_list["action"]
				if(action=="buy")
					var/itemcost=text2num(href_list["cost"])
					if(src.CharPoints >= itemcost)
						var/O = href_list["item"]
						var/obj/item = new O
						item.Move(src)
						src.CharPoints-=itemcost
						alert(src,"You have [src.CharPoints] CP left after buying \a [item.name].")
						//if(src.CharPoints)
							//src<<browse(itemsthing,"window=thing")

					else
						alert(src,"You only have [src.CharPoints] left!")
				if(action=="donewithitems")
					if(alert(src,"Are you sure you're done choosing your starting items?","Done?","Yes","No")=="Yes")
						src.flag=1
			/*if(href_list["info"])
				var/info=href_list["info"]
				if(info=="Great War")
					src<<browse(GWinfo,"window=info")*/


//END CREATION
//*******************\\

//BEGIN SAVING/LOADING/CREATING

mob
	var/flag
	proc
		CreateChar()
			if(fexists("saves/[src.ckey]/celestia.forgetme"))
				if(alert(src,"If you continue, your currently saved\ncharacter will be lost. Is this ok?","Alert!","Yes","No")=="Yes")
					goto makechar
				else
					return
			makechar:
				var/mob/newchar
				var/namething=input("Enter a name for your character","Character Creation") as text|null
				if(!namething)
					return
				namething=ckey(namething)
				var/cap = copytext(namething,1,2)
				cap=uppertext(cap)
				var/tempname = copytext(namething,2)
				namething = cap+tempname
				src.charlist+=list(new /mob/player/Verrisk, new /mob/player/Gra, new /mob/player/Homulid)
				for(var/mob/player/A in src.charlist)
					src.racething += {"
					<b><a href='?src=\ref[src];type=[A.type];cost=[A.cost]'>[A.name]</a></b> [A.cost] -- [A.startdesc]<br>
					<br>
					"}
				src<<browse(src.racething,"window=thing")
				while(!src.chartype)
					sleep()
				newchar=new src.chartype
				src<<browse(itemsthing,"window=thing")
				while(!src.flag)
					sleep()
				newchar.name=namething
				src<<browse(null,"window=thing")
				new /obj/verbs/Move_To(src)
				new /obj/verbs/Attack(src)
				newchar.contents=src.contents
				newchar.loc=locate(newchar.startx,newchar.starty,newchar.startz)
				newchar.energy=newchar.maxenergy
				newchar.hp = newchar.maxhp
				newchar.contents+= new /obj/items/bombs/light_grenade
				newchar.client=src.client
				src.charlist=null
				src<<browse(null,"window=thing")
				world<<"<h2>\blue [namething] has joined the fight!<br>"
		Save(mob/M)
			if(M.z!=16)
				var/savefile/F=new("saves/[M.ckey]/celestia.forgetme")
				F["savex"] << M.x
				F["savey"] << M.y
				F["savez"] << M.z
				F["[M.ckey]"] << M
				M.Write(F)

		Load(mob/M)
			if(!fexists("saves/[M.ckey]/celestia.forgetme"))
				alert(src,"You don't have a character saved!")
				return
			else
				var/savefile/F=new("saves/[M.ckey]/celestia.forgetme")
				var/X
				var/Y
				var/Z
				F["savex"] >> X
				F["savey"] >> Y
				F["savez"] >> Z
				F["[M.ckey]"] >> M
				M.Read(F)
				M.loc=locate(X,Y,Z)
				M.umsl_locks -= list("right leg", "left leg")
				if(M.z>1&&M.z<16)
					M.client.view=world.view
				if(M.z==1)
					M.client.view=mapview

				M.charlist=null
				world<<"<h2>\blue [M.name] has joined the fight!<br>"
