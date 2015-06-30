/*
        _/_/_/  _/_/_/      _/_/      _/_/_/  _/    _/  _/_/_/_/  _/_/_/
     _/        _/    _/  _/    _/  _/        _/    _/  _/        _/    _/
    _/        _/_/_/    _/_/_/_/    _/_/    _/_/_/_/  _/_/_/    _/    _/
   _/        _/    _/  _/    _/        _/  _/    _/  _/        _/    _/
    _/_/_/  _/    _/  _/    _/  _/_/_/    _/    _/  _/_/_/_/  _/_/_/



                    _/          _/  _/_/_/  _/        _/
                   _/          _/    _/    _/        _/
                  _/    _/    _/    _/    _/        _/
                   _/  _/  _/      _/    _/        _/
                    _/  _/      _/_/_/  _/_/_/_/  _/_/_/_/



               _/      _/  _/_/_/_/  _/      _/  _/_/_/_/  _/_/_/
              _/_/    _/  _/        _/      _/  _/        _/    _/
             _/  _/  _/  _/_/_/    _/      _/  _/_/_/    _/_/_/
            _/    _/_/  _/          _/  _/    _/        _/    _/
           _/      _/  _/_/_/_/      _/      _/_/_/_/  _/    _/



                           _/_/_/    _/_/_/  _/_/_/_/
                          _/    _/    _/    _/
                         _/    _/    _/    _/_/_/
                        _/    _/    _/    _/
                       _/_/_/    _/_/_/  _/_/_/_/

*/
proc
	TexttoMap(Text as text,mob/User)
		if(!Text) return
		Text=html_decode(Text)
		var/len=lentext(Text);var/i;var/off=0
		while(i<len)
			if(i)off+=6
			i++
			var/Cop=copytext(Text,i,i+1)
			new/obj/Character(Cop,off,User.Player,User)
obj/Character
	icon='Text.dmi'
	layer=90
	var/owner
	New(Character,Offset,Num,Usr)
		owner=Usr
		var/X=1
		while(Offset>=32)
			X++
			Offset-=32
		icon_state=Character
		pixel_x+=Offset
		if(Num>1)pixel_y+=Num*5
		loc=locate(X,1,1)

turf/T
	icon='Text.dmi'
	icon_state="__"

world/turf=/turf/T
client/view=5
