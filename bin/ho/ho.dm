mob/proc/GotoMars()
   var/savefile/F = new()
   F << src
   if(!world.Export("127.0.0.1:1337#player",F))
      usr << "Mars is not correctly aligned at the moment."
      return
   usr << link("127.0.0.1:1337")

world/Topic(T)
   if(T == "player")
      //download and open savefile
      var/savefile/F = new(Import())

      //load mob
      var/mob/M
      F >> M

      return 1

mob
	verb
		GotoMARS()
			src.GotoMars()