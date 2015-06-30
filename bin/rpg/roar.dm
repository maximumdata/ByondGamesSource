

client/var/clicking
client/Click()
	if(src.clicking)
		src.DblClick()
		src.clicking=0
	else
		src.clicking=1
		spawn(4) src.clicking=0
