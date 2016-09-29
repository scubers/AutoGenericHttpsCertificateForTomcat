#!/usr/bin/expect


set pwd [lindex $argv 0]
set crtName [lindex $argv 1]
set keyName [lindex $argv 2]
set p12Name [lindex $argv 3]


spawn openssl pkcs12 -export -in $crtName.crt -inkey $keyName.key -out $p12Name.p12

expect "*Password*"  {send "$pwd\n" }
expect "*Password*"  {send "$pwd\n" }


interact
