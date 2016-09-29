#!/usr/bin/expect

set serverCsrName [lindex $argv 0]
set serverCrtName [lindex $argv 1]

set clientKeyName [lindex $argv 2]
set clientCrtName [lindex $argv 3]

spawn openssl ca -in $serverCsrName.csr -out $serverCrtName.crt -cert $clientCrtName.crt -keyfile $clientKeyName.key

expect "*Sign the certificate*"  {send "y\n" }
expect "*commit*"  {send "y\n" }


interact
