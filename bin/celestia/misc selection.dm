
#define MAX_SELECT 6
mob
	player
		var/list/images=list()
client
	var/list/selected=list()
	Click(atom/clicked, location)
		if(clicked==src.mob)
			if(src.selected.len)
				for(var/mob/M in src.selected)
					src.selected -= M
					for(var/image/ok in M:images)
						del(ok)
					M:pwner=null
				src.selected=list()
				src.mob<<"You have deselected all units."
		if(ismob(clicked)&&istype(clicked,/mob/player/subord))
			if(clicked:race==src.mob.race)
				if(!clicked:pwner||clicked:pwner==src)
					var/i=image('objs.dmi',clicked,"selected")
					if(clicked in src.selected)
						src.selected -= clicked
						for(var/image/ok in clicked:images)
							del(ok)
						clicked:pwner=null
					else
						if(src.selected.len <MAX_SELECT)
							src.selected += clicked
							src << i
							clicked:images +=i
							clicked:pwner=src
						else
							src.mob<<"You have too many units selected already!"
				else
					src<<"[clicked:pwner] currently has that unit selected!"
			else
				if(src.selected.len)
					src.mob.curtarget=clicked
					src.mob.cmdx=clicked.x
					src.mob.cmdy=clicked.y
					src.mob:MoveTo()
					src.mob:TroopAttack()
				else
					walk_to(src,clicked,1,3)
					src.mob.fight(clicked)
		if(isturf(clicked))
			src.mob.cmdx = clicked.x
			src.mob.cmdy = clicked.y
			if(src.selected.len)
				src.mob:MoveTo()
			else
				walk_to(src.mob,clicked,0,3)
		return ..()
	/*DblClick(atom/clicked, location)
		if(isturf(clicked))
			if(src.selected.len)
				walk_to(src.mob,clicked,0,3)
		if(ismob(clicked))
			walk_to(src.mob,clicked,1,3)
			src.mob.fight(clicked)
		return ..()*/
