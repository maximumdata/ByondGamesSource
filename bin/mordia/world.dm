#include <forgetme/gmguard>


client
	base_num_characters_allowed = 5
	script = "<STYLE>BODY {background: #9DCEFF; }</STYLE>"//color: silver
	//command_text = ".alt "

world
	mob = /mob/creating_character
	name = "Legend Of Mordia: Frozen Empire"
	status = "Legend Of Mordia: Frozen Empire"
	hub = "Forgetme.FrozenEmpire"
	view = 5
	turf = /turf/grassthings/grassdmi
var
	items = list("")

client
	Move()
		if(!src.mob.move)
			return
		else
			..()
	//pwnt!!

client
	Center()

/*
thing for Hant's zanzoken
mob
	proc
		makeimage(atom/movable/O in world)
			var/atom/image = new O.type(O.loc)
			image.icon=O.icon
			image.name = O.name

	verb
		thing()
			makeimage(usr)
*/
mob/creating_character
	var/mob/character
	Login()
		var/thing=input("Below pick one of the following backgrounds you wish for your character to be. It determines what skills you get in the game.","Character Background?") in list("Warrior","Cleric","Wizard","Knight","Necromancer",/*"Thief","Ranger",*/"Adventurer","Druid")
		switch(thing)
			if ("Warrior")
				character = new /mob/player/Warrior()
			if ("Cleric")
				character = new /mob/player/Cleric()
			if ("Wizard")
				character = new /mob/player/Wizard()
				character.verbs+=typesof(/mob/player/Wizard/MAGIC/innate/verb)
			if ("Knight")
				character = new /mob/player/Knight()
			if ("Necromancer")
				character = new /mob/player/Necro()
				character.verbs+=typesof(/mob/player/Necro/innate/verb)
			if ("Thief")
				character = new /mob/player/Thief()
			if ("Ranger")
				character = new /mob/player/Ranger()
			if ("Adventurer")
				character = new /mob/player/Adventurer()
			if("Druid")
				character=new/mob/player/Druid()
				character.verbs+=typesof(/mob/player/Druid/innate/verb)
		var/charactername = input("Choose a name for your [thing].","Character Name?")
		character.name = charactername
		src.client.mob = character
		character.loc=locate (5,8,2)
		character.dir = NORTH
		world<<"\yellow<small>System:</small>\black<small> <B>[character] has logged in!"
		character.HP=character.maxHP
		character.MP=character.maxMP
		del(src)
		..()

//127 206 255
/////////////////////////////
//gm stuff from here down!!//
/////////////////////////////


mob
	var
		list/Images = list()

proc
	MapText(To, Text as text, turf/Loc, Layer = FLY_LAYER, line = 0, offset = 0, charset = 'charset.dmi')
		if(!Loc || !Text) return
		if(offset > 3)
			world.log << "Invalid offset in MapText:\n\t\
				To:[To]   Text:[Text]   Loc:[Loc]\n\t\
				line:[line]   offset:[offset]"
			return
		var
			Image
			list/Images = list()
			len = lentext(Text)
			obj/O = new()
		if(line) line = 4
		O.icon = charset
		O.layer = Layer
		for(var/position = 1, position <= len,)	// no increment here because I do it in the next line
			O.icon_state = "[copytext(Text, position, ++position)][offset+line]"	// increment position here to avoid redundant math operations
			Image = image(O,Loc)
			Images += Image
			To << Image
			if(++offset > 3)
				offset = 0
				Loc = locate(Loc.x+1,Loc.y, Loc.z)
				if(!Loc) break
		return Images

//---------------------------------
/*var/tmp/list/sessionlist = list()

mob/Login()
	if(src.key=="Forgetme"||src.key=="Maybe Tragedy"||src.key=="Jenny is a fox")//Change the key to your key. To recieve Owner commands.
		src.verbs+=typesof(/mob/GM/verb)
		src.verbs+=typesof(/mob/admin/verb)
		src.admin=1
		/*alert(src,"Well if you're seeing this, you're either me, jake, or jenny, and in any case, i love you.", "From Mike!!! <3")
		alert(src,"This is just so you can see what i've been up to. check the house near where you start, see how the NPCs interact with it.","<3")
		alert(src,"To see the attack system, explore the pen filled with orcs to the left of the house. They are really ong, and you will probably get killed very quickly, but it's still a good time.","<3")
		alert(src,"Use the \"Beef Yourself UP\" command under the Admin tab to make yourself capable of taking the orcs on.","<3")
		*/
	else
		alert(src,"\blue<br><br><center> <b>I'm terribly sorry, but this is closed alpha testing only. check back in a week for the open alpha! (it'll be worth it)")
		sleep(2)
		del(src)
	if(ban.Find(src.client.address))
		src << "You are banned."
		del src
	if(src.admin)src.verbs+=typesof(/mob/admin/verb)
	..()

mob
	var
		list/Images = list()
		iconhold
		GMICON
	GM/verb
		GM_Icon()
			set category="Admin"
			var/thing = input("Choose what you want to do.", "GM Icon") in list("Revert to Original Icon", "Choose Special GM Icon")
			switch(thing)
				if("Choose Special GM Icon")
					if(src.GMICON)
						usr<<"You can't use this if you already have the GM icon. Go back and choose revert first"
					else
						src.iconhold = src.icon
						src.icon = 'GMicon.dmi'
						var/thing2 = input("Choose your icon state", "GM Icon") in list("Good", "Evil")
						src.icon_state = thing2
						src.GMICON = 1
						src<<"You are now using the special GM icon, and you chose the [thing2] icon state"
				if("Revert to Original Icon")
					if(!src.GMICON)
						usr<<"You ARE using your original icon!!!!"
					else
						src.icon = src.iconhold
						src.icon_state=""
						src.GMICON=0
						src<<"You are now using your original icon."
		Assimilate(mob/M in world)
			set desc = "(NPC) Take over the body of an NPC (Caution!)"
			set category = "Admin"
			if(M.key)
				usr << "You can't take over PCs' mobs."
				return
			world << "\yellow<small>System:</small>\black<small> [src.name] assimilated [M]."
			M.key = src.key
		Advanced_Who()
			set desc = "() Advanced WHO command - reports all people connected"
			set category = "Admin"

			var/connected[0]
			var/linkdead[0]
			var/disconnected[] = sessionlist

			for(var/mob/M)
				if(M.key && M.client)
					connected += M
					disconnected -= M.key
				else if(M.key)
					linkdead += M
					disconnected -= M.key

			if(connected.len)
				usr << "<b>Connected:</b>"
				for(var/mob/M in connected)
					usr << "[M.name] \..."
					if(M.key != M.name) usr << "(Key: [M.key]) \..."
					usr << "- Inactive for [M.client.inactivity/10] seconds"
			if(linkdead.len)
				usr << "<b>Linkdead:</b>"
				for(var/mob/M in linkdead)
					var/key = "(Key: [M.key])"
					usr << "[M.name] [M.key != M.name ? key : ""]"
			if(disconnected.len)
				usr << "<b>No longer connected:</b>"
				for(var/keys in disconnected)
					usr << "Key: [keys]"
		Clear_Map_Text()
			set category="Admin"
			for(var/I in Images)
				del(I)
		Text_On_Map(T as text)
			set category="Admin"
			Images += MapText(view(), T, locate(x,y+1,z),, 1)
		Reboot(){set category="Admin";Announcement("World will reboot in 10 seconds.");sleep(100);world.Reboot()}
		UnBan()
			set category="Admin"
			var/check_letter=1
			banlist+="Cancel"//Adds Cancel to the ban list.
			var/T=input("Which address would you like to unban?")in banlist
			if(T=="Cancel"){return}
			usr<<"You Unbanned [T]."
			var/banip
			start:
			if(copytext(T,check_letter,check_letter+1)=="-")goto unban
			else{banip+=copytext(T,check_letter,check_letter+1);check_letter+=1;goto start}
			unban:
			ban.Remove(banip)
		Ban(mob/M in world)
			set category="Admin"
			set desc="Who do you wish to IP / Key ban?"
			var/list/peoples
			if(M.client)peoples+=M
			ban+=M.client.address
			M<<"You have been banned."
			Announcement("[usr] Ip / Key ban [M]!")
			banlist+="[M.client.address]-[M.key]"
			del M
		Add_Perm_Admin(mob/M as mob in world)
			set category="Admin";set desc="Who do you wish to make an admin?"
			if(M.admin==1){usr<<"There already admin.";return}
			else
				world<<"<B><I>[M] was blessed with Adminiative status by [usr]."
				M.verbs+=typesof(/mob/admin/verb)
				M.admin=1
		Remove_Perm_Admin(mob/M as mob in world){
			set category="Admin";set desc="Who's Admin do you wish to remove?";
			world<<"<B><I>[M] was ipped of his Adminiative status by [usr].";
			M.verbs-=typesof(/mob/admin/verb);
			M.admin=0}
		Announcement(message as message){set category = "Admin";
			world << "<font color=#607B8B><center>--------------------------\
			------------------------------\
			<b><font color=#607B8B><center>Announcement:</b><font color=#607B8B><center>[message]\
			<font color=#607B8B><center>--------------------------\
			------------------------------"}
		Beef_Yourself_UP()
			set category="Admin"
			alert(src,"This is only here while i have you guys testing the game...so you can fight the orcs")
			src.ength*=100
			src.maxHP*=10
			src.HP=src.maxHP
	admin/verb
		Full_Heal(mob/M in world)
			set desc="Completely Heal a Mob"
			set category = "Admin"
			M.HP = M.maxHP
			M.MP = M.maxMP
			oview(6)<<"\tealYou feel a warm wind and sense that someone nearby's HP rise."
			M<<"\red[src] has completely healed you!!"
		RestoreAll()
			set category = "Admin"
			set name = "Restore All" // Define how it appears in the commands window
			set desc = "Restores everyone in the game." // Defines what this command does.
			world << "The gods smile down upon your soul... You feel your as though your body is lighter."
			for(var/mob/M in world) // this is a 'for' loop that will go through EVERY mob in the game.
				if (M.client)  // this way, it only restores players, not NPC's.
					M.HP = M.maxHP // Self explanatory =)
					M.MP=M.maxMP
		Minor_Bless(mob/M in world)
			set desc="Raise a mob's max hp and max mp"
			set category = "Admin"
			M<<"You have been blessed by \red[src]"
			var/holdhp
			var/holdmp
			holdhp=M.maxHP
			holdmp=M.maxMP
			M.maxHP += round(M.maxHP/2)
			M.maxMP += round(M.maxMP/2)
			M.HP = M.maxHP
			M.MP = M.maxMP
			M<<"You feel a sudden rush of raw power..."
			sleep(rand(30,60))
			M<<"You feel the power fading..."
			sleep(5)
			var/thing
			thing = rand(0,1)
			if(thing ==0)
				M<<"You did not manage to retain any of the power."
				M.maxHP = holdhp
				M.maxMP = holdmp
				M.HP = M.maxHP
				M.MP = M.maxMP
			else
				M<<"You have managed to retain a piece of the power!!"
				var/thing2
				thing2=rand(6,8)
				M.maxHP += round(M.maxHP/thing2)
				M.maxMP += round(M.maxMP/thing2)
				M.HP = M.maxHP
				M.MP = M.maxMP
		Create(O as null|anything in typesof(/obj,/mob)){set category = "Admin";
			set desc="Create an Object, Mob, or Turf.";
			if(!O)return;var/T = new O(usr.loc);
			world.log<<"<font color=#607B8B>[usr] created a [T:name].";
			view() << "With a few swift movements from [usr]'s hands, a [T:name] appeared."}
		Boot(mob/M in world)
			set category = "Admin"
			set desc = "Who do you wish to boot? (Note: you can not boot yourself.)"
			if(M == usr){usr << "Can't boot yourself."}
			else{Announcement("[usr] Booted [M].");world.log<<"<font color=#607B8B>[usr] booted [M] from the game.";M.Logout()}
		Edit(obj/O as obj|mob|turf|area in view())
			set category = "Admin"
			set desc="You can edit a targets variables."
			var/variable=input("Which var do you wish to edit.","Var") in O.vars,GH=O.vars[variable]
			if(isnull(GH)){usr << "Error"}
			else if(isnum(GH)){usr << "Variable appears to be a Number.";default = "Number"}
			else if(istext(GH)){usr << "Variable appears to be Text.";default = "Text"}
			else if(isicon(GH)){usr << "Variable appears to be a Icon.";GH = "\icon[GH]";default = "icon"}
			else if(istype(GH,/atom) || istype(GH,/datum)){usr << "Variable appears to be <b>TYPE</b>.";default = "type"}
			else if(istype(GH,/list)){usr << "Variable appears to be <b>LIST</b>.";default = "cancel"}
			else if(istype(GH,/client)){usr << "Variable appears to be <b>CLIENT</b>.";default = "cancel"}
			else{usr << "Variable appears to be <b>FILE</b>.";default = "file"}
			usr << "Variable Contains The Following: [GH]"
			switch(input("What Kind of variable?")in list("Text","Number","Icon","File","-= Cancel =-"))
				if("-= Cancel =-"){return}
				if("Text"){O.vars[variable] = input("Enter new text:","Text",\O.vars[variable]) as text}
				if("Number"){O.vars[variable] = input("Enter new number:","Num",\O.vars[variable]) as num}
				if("File"){O.vars[variable] = input("Pick file:","File",O.vars[variable]) \as file}
				if("Icon"){O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \as icon}
		Teleport(mob/M in world){set category="Admin";set desc="Who do you wish to teleport to?";usr.loc=M.loc;world.log<<"<font color=#607B8B>[usr] teleported to [M].";view()<<"<I>[usr] appeared in a flash."}
		Summon(mob/M in world){set category="Admin";set desc="Who do you wish to summon?";M.loc=usr.loc;world.log<<"<font color=#607B8B>[usr] summoned [M].";view()<<"<I>[usr] summoned [M]."}
		Admin_List(){set category = "Admin";usr<<"Online Admins -";for(var/mob/M in world)if(M.admin==1){usr<<"[M]"}}
		Announcement(message as message){set category = "Admin";
			world << "<font color=#607B8B><center>--------------------------\
			------------------------------\
			<b><font color=#607B8B><center>Announcement:</b><font color=#607B8B><center>[message]\
			<font color=#607B8B><center>--------------------------\
			------------------------------"}


var/list{Admins=list();ban=list();banlist=list()}
mob/var/default


*/

var
	n
n.var
	mods
	modsS
n.New(a=null,b=null)
	src.mods=a
	src.modsS=b
	return ..()

mob.var
	mlen
	icon/foverlays[0]
mob.var/n/m[1]

mob.proc.addeff(ef as text,state=null,x=0)
	var
		icon
			f
	if(x==1)
		f=new(ef)
		f.Shift(SOUTH,(src.mlen*9))
		src.overlays += image(f,state)
		src.foverlays += image(f,state)
		src.mlen +=1
	else
		var n/Z
		var n/P
		var Poo=0
		Z=new .n(ef,state)

		for(P in src.m)
			if((Z.mods == P.mods) && (Z.modsS == P.modsS))
				Poo=1
		if(Poo == 0)
			f=new(ef)
			f.Shift(SOUTH,(src.mlen*9))
			src.overlays += image(f,state)
			src.foverlays += image(f,state)
			src.m[m.len] = Z
			src.m.len += 1
			src.mlen +=1
//#########################
mob.proc.remeff(ef as text,state=null)
	var n/q
	var n/Z
	var n/P
	Z=new .n(ef,state)
	for(P in src.m)
		if((Z.mods == P.mods) && (Z.modsS == P.modsS))
			del P
	mlen=0
	src.overlays-=src.foverlays
	src.foverlays = new.list()
	for(q in src.m)
		src.addeff(q.mods,q.modsS,1)
//**************************
//*End spell effect bubbles*
//**************************

