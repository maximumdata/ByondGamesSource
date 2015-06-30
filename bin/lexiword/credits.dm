/*
repiv for the Word_Check proc
YMIHere for the whole removing letters from strings thing
Scoobert for QuickLinks
Druaga for ideas!
*/

var/specialwords=list("iwin","ljr","xooxer","crashed","aza","sariat","chanbot","chatters","mertek","loverboy","splatty","splattergnome","forgetme")

mob/proc/Spam()
	if(!AdminList.Find(src.key))
		if(src.Speaking>=3)
			src.Mute=1
			world<<"<b>[src] has been muted for spamming.</b>"
			mutelist+=src
		src.Speaking++
		spawn(7) src.Speaking--

mob/var
	Speaking=0
	Mute=0
proc
	Overwrite_Text(msg, snippet, position as num, secposition as num)//This is a modifyed version of flicks proc called "Insert_Text"
		if(secposition == 0) secposition = length(msg)//Put in because of Garthors Advice.
		msg = copytext(msg, 1, position) + snippet + copytext(msg, secposition)//This is complicated, yet simple.
		return msg//This sends the message back what whatever called it.
	Link_Parse(T,url,tag,end)//simply complicated text string.
		if(T&&url&&tag&&end)//check to make sure it has all the vars passes needed.
			var/second=findtext(T,end)+1
			if(findtext(T,end,second))
				var/Start=findtext(T,tag)
				while(Start)
					sleep()
					Start=findtext(T,tag,Start)+length(tag)
					var/Check
					if(Start-length(tag)-1)//Check to make sure the string is not the first thing in the text
						if(copytext(T,Start-length(tag)-1,Start-length(tag)))//Check one letter before the ID starts
							Check=copytext(T,Start-length(tag)-1,Start-length(tag))//This places the letter before the ID into the check var for later use in a check.
					if(!Check||Check==" ")//This makes sure there is a space or it's the first thing in the text. This prevents things like said: from being a problem. Also recommended by Garthor
						var/End=findtext(T,end,Start)
						if(End==0) End=length(T)+1
						var/Num=copytext(T,Start,End)
						T=Overwrite_Text(T,"<a href=\"[url][Num]\">[tag][Num]</a>",Start-length(tag),End)
						Start+=12+length(url)+length(Num)+7
						Start=findtext(T,tag,Start)
		else if(T&&url&&tag)//check for no end, because it will react diffrent with no end.
			var/Start=findtext(T,tag)
			while(Start)
				sleep()
				Start=findtext(T,tag,Start)+length(tag)
				var/Check
				if(Start-length(tag)-1)
					if(copytext(T,Start-length(tag)-1,Start-length(tag)))
						Check=copytext(T,Start-length(tag)-1,Start-length(tag))
				if(!Check||Check==" ")
					var/End=findtext(T," ",Start)
					if(End==0) End=length(T)+1
					var/Num=copytext(T,Start,End)
					T=Overwrite_Text(T,"<a href=\"[url][Num]\">[tag][Num]</a>",Start-length(tag),End)
					Start+=12+length(url)+length(Num)+7
					Start=findtext(T,tag,Start)
				else
					Start=findtext(T,tag,Start)
		return T
	Link_Filters(var/T)
		T=html_encode(T)
		T=Link_Parse(T,"http://www.bash.org/?","Bash:")//Simple enough, http... is the location on the web, normaly it will end in ? or =
		T=Link_Parse(T,"http://www.planetbyond.com/BYONDBash.dmb?quote=","BBash:")//The second thing is the name to use. But using double terms like BBash and Bash will cause problems.
		T=Link_Parse(T,"http://developer.byond.com/forum/index.cgi?id=","ID:")
		T=Link_Parse(T,"http://www.google.com/search?q=","google:",":")//For ease, end your begining term with your ending term
		T=Link_Parse(T,"http://dictionary.reference.com/search?q=","define:",":")
		T=Link_Parse(T,"http://bwicki.byond.com/ByondBwicki.dmb?","bwicki:")
		T=Link_Parse(T,"http://games.byond.com/hub/","hub:")//hub:xkey/xgame
		T=Link_Parse(T,"http://www.planetbyond.com/site.dmb?browse&amp;owner=","Condo:")//condo:xkey&page=n
		return T