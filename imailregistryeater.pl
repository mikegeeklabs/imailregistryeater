#!/usr/bin/perl
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

print "Eat what registry file? " ; 
$file = <STDIN> ; 
chop($file) ; 
# $file = "mail1.reg.txt" ;
print "Eating $file  \n" ; 

open(IN,"$file") ; 
open(OUT,">imail.passwd") ; 
open(SQL,">mail.sql") ; 

while(<IN>) {
  if(/\"MailAddr\"/) { 
	$addr = "\L$addr" ; 
	$cleartext = extract($addr,$passwd) ; 
	print "$addr	$name	$passwd	$cleartext \n" ; 
	print OUT "$addr|$name|$cleartext\n" ; 
	print SQL "insert into mailboxes (login,loginname,domain,name,passwd) values ('unassigned','$login','$domain','$name','$cleartext') ; \n" ; 
	$addr = stripval($_) ; 
  } ; 
  if(/\"FullName\"/) { 
	$name = stripval($_) ; 
  } ; 
  if(/\"Password\"/) { 
	$passwd = stripval($_) ; 
  } ; 
} ; 
        #outputs the last record
	print OUT "$addr|$name|$cleartext\n" ; 
	print SQL "insert into mailboxes (login,loginname,domain,name,passwd) values ('unassigned','$login','$domain','$name','$cleartext') ; \n" ; 
	close OUT ; 
	close SQL ; 

sub stripval($string) {
	$_ = shift ; 
	s/\"//g ; 
	s/\'//g ; 
	s/\//g ; 
	s/\n//g ; 
	($j,$val) = split(/\=/) ; 
	return $val ; 
} 

sub extract($addr,$passwd) {
	$cleartext = "" ; 
	$addr = shift ; 
	($login,$domain) = split(/\@/,$addr) ; 
	$addrz = "$login$login$login$login$login$login" ; 
	$passwd = shift ; 	
	@a = split(//,$addrz) ; 
	@p1 = split(//,$passwd) ; 
	$pz = "" ; $pzz = "" ; 
	foreach(@p1) {
		$pz .= $_ ; 
		if(length($pz) > 1) { $pzz .= "$pz|" ; $pz = "" ; } ; 
	} ; 
	@p = split(/\|/,$pzz) ; 
	$i = 0 ; 
	$c = "" ; 
	foreach(@p) { 
	$pwh = $_ ; 
	$aa = ord($a[$i]) ; 
	$aahex = sprintf("%lx ", $aa);
	$zz = hex($pwh) - hex($aahex) ; 
	$cc = chr($zz) ; 
	$c .= "$cc" ; 	
	$i++ ; 
} ; 

	$cleartext = $c ; 
	return $cleartext ; 
} ; 
