#define DEBUG
//Just making sure to get some debugging information here

/*Release notes:
(2003)

10/20 - Removed the user list due to it looking effectivly ugly, and optimized the code a bit.

		Added "Extra Stuff" at the bottom of the code, showing how to use the unused features I coded in.

5/22 - Added the list to show which users are logged into the site. - Nadrew

4/10 - Redid the site code for V.2.0, efficently added dynamic pages, but they're not really used yet, I have some plans for them, but nothing yet. - Nadrew

2/21 - Finished 1.0 for release, and uploaded it to the BYOND server.

1/12 - Moved the site from Gushnet to Dreamhost
(2002)

Nothing, the site was in PHP on Gushnet, and this code didn't exist.

*/
#define NEWS "Not much going on in my life right now, the nadrew.com domain is renewed for another year. There have been a few server issues over at Dantom, so the site has been acting up a little; nothing too bad though."
//This is what news is, since we're not dynamicly changing it, I made it a constant variable.


var
	loggedin
	hits = 0
	news = "<b>\[3/30/04\]</b> [NEWS]"
	navigation
	list
		discontent[0]
		users = list()


proc		//A few procs I use to determine unique users that visit the site

	loadhits()		//The loading proc for the savefile that holds the IP's that visit the site

		var/savefile/F = new("hits.data")	//Save the file in a .data file (it's a normal BYOND savefile)

		var/list/uselist[0]	//The list the users are loaded into before actually loading them

		F["uhits"] >> hits		//Load up the hits

		F["users"] >> uselist		//Load up the users list into the uselist local variable

		if(!uselist)		//Make sure uselist has something

			users = list()		//If not, make "users" a blank list

		else		//If so.

			users = uselist		//load the list fully.

	savehits()		//The saving proc

		var/savefile/F = new("hits.data")		//Create a new savefile if it doesn't exist

		F["uhits"] << hits		//Save the hits as "uhits" in the savefile

		F["users"] << users		//Save the "users" list.




world

	New()		//When the webpage is loaded

		..()		//Default actions (proper loading follows)

		loadhits()		//Load the hits


		//Set the non-dynamic pages within the code
		discontent["creations"] = "<small><b><i>No creations to list at this time.</b></i></small>"

		discontent["contact"] = "<small><b>Email: <a href=mailto:nadrew@nadrew.com>nadrew@nadrew.com</a><br>Alternate email: <a href=mailto:nadrew@byond.com>nadrew@byond.com</a></small><p><b>\"Spam\" emails sent to these addresses WILL NOT BE TOLERATED, and by the laws enforced in the state of the server Nadrew.com is hosted on it is also illegal, and legal action will be taken.</b>"

		discontent["affliates"] = "<small><b><a href=http://alacrityonline.xidus.net>Alacrity Online</a></b><p><a href=http://www.teamebon.com><img border=0 src=http://www.teamebon.com/images/logo.gif></a><br><a href=http://www.ctrlaltdel-online.com><img border=0 src=http://www.ctrlaltdel-online.com/images/Small_3.gif></a></small>"

		discontent["source"] = "You can find the source for this entire website <a href=nadrewcom.dm>here</a>, it's in the .dm file format used for the <a href=http://www.byond.com target=_blank>BYOND</a> programming suite."

		navigation += "<a href=/bwicki>Bwicki</a> - "

		navigation += "<a href=/forum>Forum</a> - "
		//Add any extra links to navigation here
		for(var/L in discontent)
			//This will loop through the discontent list, and add to the navigation table accordingly
			if(L == discontent[discontent.len])

				navigation += "<a href=?[L]>[uppertext(copytext(L,1,2))+copytext(L,2,length(L)+1)]</a>"

			else

				navigation += "<a href=?[L]>[uppertext(copytext(L,1,2))+copytext(L,2,length(L)+1)]</a> - "


	Del()		//When the site is closed

		..()

		savehits()		//Save the stuff

mob
	Login()		//When someone logs into the site

		..()

		if(src.key == "guest")		//If they're a guest

			loggedin = "Guest - <a href=?login>Login</a>"		//give them a login link

		else

			loggedin = "[src.key] - <a href=?logout>Logout</a>"		//If they're logged in..
			//Give them a logout link

		if(!users.Find(src.client.address))		//Check the users list for the person's IP
			//if it's not found
			users.Add(src.client.address)		//Add it to the list

			hits++		//Add a hit

			savehits()	//And save

		else	//If it's found

			return		//Don't add a hit

	Logout()		//When the leave the site
		..()
		del(src)		//Clear their stuff from the server


CGI
	Topic(href)		//Called when any ?[blah] link is clicked

		var
			content		//set up a local variable for content display

		if(!href)		//If no link is found

			href = "News"		//Default to the news page

			content = news		//Make content equal the news variable

		else		//if there's a link found

			if(discontent.Find(href))		//if the global content list finds the link clicked

				content = discontent[href]		//content will equal the proper pointer to the global content list

			else		//if not

				if(href == "logout")		//And the logout link is clicked

					var/CGI/C = new()		//create a new CGI object for use

					C.Logout()		//Call the CGI object's logout proc.

				else if(href == "login")		//If it's login

					//Do the same except login.
					var/CGI/C = new()

					C.Login()

				href = "News"		//And return the user to the news area

				content = news
		//The default layout for the webpage with the content variable, loggedin variable, and a part of the href variable embedded into it.
		usr << browse({"<HTML>
		<HEAD>
		<TITLE>Nadrew.com \[\[Version 2.5\]\]</TITLE>
		<link href=\"nadrewcom.css\" rel=\"stylesheet\"
		</HEAD>
		<BODY BACKGROUND=\"nbg.png\" TEXT=\"WHITE\">
		<table border=\"1\" cellspacing=\"0\" bordercolor=\"black\" width=100% height=100%>
		<tr><td align=right height=100><img src=\"logo.png\"></td></tr>
		<tr><td valign=top height=20 align=center><b><small>\[\[Navigation\]\]</b></small><br>\[<a href=index.dmb>Home</a> - [navigation] \]</td></tr>
		<tr><td valign=top align=center><b><small>\[\[[uppertext(copytext(href,1,2))+copytext(href,2,length(href)+1)]\]\]</small></b><p>[content]</td></tr>
		<tr><td align=center height=10><small>©2002-2003, All Images and Content is copyrighted by Nadrew.com, and its owners, All Rights Reserved</td></tr>
		<tr><td align=center height=10>|-Logged in as [loggedin]-|</td></tr>
		</table>"})



/*****Extra Stuff!*****\

Say you want to make some dynamic web pages with this system, the code already allows it, just add some saving to the discontent list, and use something like:
*/
mob

	proc

		AddPage(page,content)

			if(page)	//See if page isn't null.

				if(discontent.Find(page))	//Uh-oh, the page exists!

					src << "Sorry, that page exists already!"

				else

					discontent.Add(page)	//Add the page

					discontent[page] = content	//Set some content to it.

			else

				return

/*
It's as easy as that, just call the proc with the proper arguments.

Now, you can also display how many unique IP addresses have visited your site by simply adding "[hits]" to your page display somewhere.

I think that's about it for the features I didn't fully use for this site, if not; I'll add how to use those too!
*/

//This code is copyrighted, and cannot be redistributed without permission from James "Nadrew" Smith. All Rights Reserved