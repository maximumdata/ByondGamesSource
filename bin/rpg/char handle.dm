client/view="21x15"

mob/verb/save()
      var/savefile/F = new()//make a new one
      F["usr"] << src// use this if you want to save ALL the vars
      usr.client.Export(F)


/* Below is the code for loading the saved file */

mob/Login()
	src.loc=locate(10,10,2)
	return ..()

client/proc/Load()
	var/savefile/client_file = new(Import())
	if(client_file)
		client_file["usr"] >> mob  //use this if you want to save ALL of the users vars
		return ..()

turf/Load
	Click()
		..()
		var/ask=input("") in list("load","no")
		switch(ask)
			if("load")
				usr.client.Load()