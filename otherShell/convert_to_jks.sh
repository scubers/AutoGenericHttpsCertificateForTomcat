#!/usr/bin/expect


set pwd [lindex $argv 0]
set p12Name [lindex $argv 1]
set jksName [lindex $argv 2]

spawn java -cp jetty-5.1.10.jar org.mortbay.util.PKCS12Import $p12Name.p12 $jksName.jks

expect "*passphrase*"  {send "$pwd\n" }
expect "*passphrase*"  {send "$pwd\n" }


interact
