
mob
	player
		icon='mobs.dmi'
		var
			startdesc
			cost
			origicon
			scanner=0

		Verrisk
			cost=50
			icon_state="verrisk"
			origicon="verrisk"
			class="Soldier"
			race="Verrisk"
			maxhp=100

			maxenergy=50
			strength=7
		Gra
			cost=75
			icon_state="gra"
			origicon="gra"
			class="Soldier"
			race="Gra"
			maxhp=75

			maxenergy=75
			strength=5
		Homulid
			cost=100
			icon_state="homulid"
			origicon="homulid"
			class="Soldier"
			race="Homulid"
			maxhp=125

			maxenergy=25
			strength=10

		New()
			..()
			//src.icon+=rgb(rand(200,255),rand(10,90),rand(100,255))
		Login()
			src.client.view=world.view
			..()

		Logout()
			Save(src)
			..()

		Stat()
			statpanel("")
			stat("[src.name] the [src.race] [src.class]","")
			stat("Health / Max Health","[src.hp] / [src.maxhp]")
			stat("Energy / Max Energy", "[src.energy] / [src.maxenergy]")
			stat("Strength","[src.strength]")
			stat("Coordinates:","\blue [src.x],[src.y],[src.z]")
			if(src.contents.len)
				statpanel("Pack")
				for(var/obj/items/O in src.contents)
					stat(O)
			if(src.scanner)
				statpanel("Scanner")
				for(var/mob/player/A in world)
					if(A.client&&A!=src)
						stat("[A]'s Location: [A.x],[A.y],[A.z]","")
			if(src.client.selected.len)
				statpanel("Selected Troops")
				for(var/mob/i in src.client.selected)
					stat("[i.name]","[i.x],[i.y]")
					//stat("[i.x],[i.y]")
			statpanel("Unit Commands")
			for(var/obj/verbs/O in src.contents)
				stat("----------------------")
				stat(O)
				stat("[O.desc]")


//BEGIN START INFO
mob/player/Verrisk
	startx=7
	starty=5
	startz=2
	startdesc={"(<font color=blue>easy</font>) An anomoly of the possibilites of the evolution of life, the Verrisk are a race
			so closely similar to the Zerg that inhabit nebulae seemingly infinite distances from their home planet of Veray, that,
			when they were first discovered by the Homulids, they were classified as a band of wayfaring Zerg. It wasn't until the start of the Great
			War that the impossibility of that theory was discovered. The Verrisk are a defensive race, relying more on special skills than the Homulid, but not as mentally adept
			as the Gra, the Verrisk are a good medium between the two. While they are effective fighters alone, they are just as efficient in groups.
			The Verrisk have no distinct weakness to either the Gra or the Homulids."}
mob/player/Gra
	startx=5
	starty=5
	startz=3
	startdesc={"(<font color=yellow>medium</font>) Upon meeting a Gra, you would probably mistake them for a harmless blob-like creature.
			However, you would soon find out just how wrong you are! It is unknown how what seem like a race of amoebic blobs could have
			developed such a tremendous grasp on mental energy. At the cost of this, their already minimal physical strength has been neglected. The Gra are
			excellent when in groups, but can be an easy picking to even a weak Homulid."}
mob/player/Homulid
	startx=5
	starty=7
	startz=2
	startdesc={"(<font color=red>hard</font>) The Homulids are the descendants of the ancient species of 'Homo Sapiens'.
			They are the sole survivors of the great nuclear war of 2057, a small party of
			250 people sent to Mars to avoid the conflict, and continue the species. Their bodies have evolved over the years to adapt to the different
			conditions of Mars. The Homulids are a race of fighters, focusing on physical strength over natural energy, and their stats reflect it. Homulids are
			strong in small groups, but can become unruly in large ones. They have a particular weakness to the mental prowess of the Gra."}