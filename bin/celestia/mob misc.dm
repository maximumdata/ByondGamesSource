

mob
	player
		verb

			RaceSay(arg as text)
				set hidden = 1
				if(!arg)
					return
				else
					for(var/mob/player/A in world)
						if(A.race == src.race)
							A<<"\yellow ([src.race]) [src]: [arg]"


	proc
		ViewChar(mob/M)
			var/html={"<html><head><STYLE>BODY {color:#FFFFFF; font-size: 10pt; background-color: #000000}</STYLE><title>[M]</title></head><body bgcolor=black text=white><center>
			<br><h2>[M.name] the [M.race] [M:class]</h2><br><font color=red>Race:</font> [M.race]<br><font color=red>Health:</font> [M.hp]/[M.maxhp]<br><font color=red>Energy:</font> [M.energy]/[M.maxenergy]
			<br><font color=red>Strength:</font> [M.strength]</body></html>"}
			src<<browse(html,"window=char")
