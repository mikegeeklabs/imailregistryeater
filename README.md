#This perl code eats a Windows Registry File (2000 / 2003 server?), looks
#for IMAIL users and passwords..  and spits out plain text passwords.  Once
#upon a time (2004) I had to move thousands of people from a few dozen IMAIL
#servers on MS-Server 2000 and 2003.  Easily the worst email product I'd
#seen in a while from a stability and scaling perspective.  It's a decent
#small office system, it's not something you run an ISP with.  What I
#discovered was that IMAIL stored the users info in the Server's registry.. 
#with pseudo-encryption.  Look up 'Schneiers Law'
#
#This was the first step of moving these people to a serious Courier-MTA based mail server on Linux. 
#I'm posting this on GitGub because I still get requests for this from people... 
#It's 2014 and there are still IMAIL servers? http://www.imailserver.com/
#I don't know if this works on the newer versions. I hope not. 
#License: Egoware - if you use this to kill an IMAIL server and like it. Send me a thank you. 
#Otherwise consider this public domain. 
