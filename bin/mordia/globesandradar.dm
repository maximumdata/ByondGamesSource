mob
	Login()
		..()
		src.client.screen += new/obj/meter1 // Add new objects to client.screen.
		src.client.screen += new/obj/mmeter1
		src.client.screen += new/obj/bg
		src.client.screen += new/obj/healthlabel
		src.client.screen += new/obj/MAGIClabel




	proc/Update(mob/M as mob)
		for(var/obj/meter1/N in M.client.screen)
			N.num = (src.HP/src.maxHP)*N.width
			N.Update()
		for(var/obj/mmeter1/MM in M.client.screen)
			MM.num = (src.MP/src.maxMP)*MM.width
			MM.Update()




obj

	var/num = 0 // current unrounded icon_state number
	var/width // number of frames in your meter, if you have frames 0 = 30 then this is set to 30
	          // even though theres 31 frames.



	meter1
		icon = 'hpglobe.dmi'
		screen_loc = "1,1"
		icon_state = "0"
		layer = MOB_LAYER+10
		width = 16

	mmeter1
		icon = 'mpglobe.dmi'
		screen_loc = "11,1"
		icon_state = "0"
		layer = MOB_LAYER+10
		width = 16

	bg
		icon='hud.dmi'
		screen_loc = "1,1 to 11,1"
		layer = MOB_LAYER+8

	healthlabel
		icon='hud.dmi'
		icon_state="hplabel"
		screen_loc="2,1"
		layer=MOB_LAYER+9
	MAGIClabel
		icon='hud.dmi'
		icon_state="mplabel"
		screen_loc="10,1"
		layer=MOB_LAYER+9

	proc/Update()
		if(num < 0) //if the meter is negative
			num = 0 //set it to zero
		else if(num > width) //if the meter is over 100%
			num = width //set it to 100%
		src.icon_state = "[round(src.num)]" // this sets the icon state of the meter to its rounded off number




mob
	proc
		speechonmap(thing as text,pause as num)
			textonscreenbackground(1,1,11,4)//Sets up hwo big you want the background to be.
			textonscreenTEXT(2,10,4,2,"[thing]")// Sets up where the text will go, from which x to y and how far down.
			sleep(pause)
			usr.close_menu()







mob/proc
	close_menu(){for(var/obj/text/O in client.screen)del O;for(var/obj/back/O in client.screen)del O}
	TOSP(var/textonscreen){text1=list();for(var/a=1,a<=length(textonscreen),a++){text1+=copytext(textonscreen,a,a+1)}}
	textonscreenbackground(var/XC1,YC1,XC2,YC2)
		for(var/XC=XC1,XC<=XC2,XC++)
			for(var/YC=YC1,YC<=YC2,YC++){var/obj/back/b=new(client);
				if(XC==XC1)b.icon_state="l";if(XC==XC2)b.icon_state="r";if(YC==YC1)b.icon_state="b";
				if(YC==YC2)b.icon_state="t";if(XC==XC1&&YC==YC1)b.icon_state="ll";
				if(XC==XC2&&YC==YC2)b.icon_state="ur";if(XC==XC1&&YC==YC2)b.icon_state="ul";
				if(XC==XC2&&YC==YC1)b.icon_state="lr";b.screen_loc="[XC],[YC]"}
	textonscreenTEXT(var/XC1,XC2,YC1,YC2,T)
		var{XC=XC1;YC=YC1}TOSP(T)
		for(var/Y in text1){var/obj/text/C=new(client);
			if(XC==round(XC)&&YC==round(YC)) C.screen_loc="[XC],[YC]";else if(XC!=round(XC)&&YC==round(YC))C.screen_loc="[XC-0.5]:16,[YC]";else if(XC==round(XC)&&YC!=round(YC))C.screen_loc="[XC],[YC-0.5]:+16";
			else if(XC!=round(XC)&&YC!=round(YC))C.screen_loc="[XC-0.5]:16,[YC-0.5]:+16";C.icon_state="[Y]";
			//sleep(1) // Important. If you wish for the text to sleep leave it, otherwise remove sleep(1)!
			XC+=0.5
			if(XC==XC2)
				XC=XC1;YC-=0.5
			if(YC==YC2-0.5)break}
mob/var/text1
obj
	back
		icon='back.dmi'
		layer=MOB_LAYER+11
		New(client/C)C.screen+=src
	text
		icon='text.dmi'
		layer=MOB_LAYER+12
		New(client/C)C.screen+=src
