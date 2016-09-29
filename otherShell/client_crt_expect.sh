#!/usr/bin/expect

set timeout 5

set IP [lindex $argv 0]
set keyName [lindex $argv 1]
set crtName [lindex $argv 2]

spawn openssl req -new -x509 -days 365 -key $keyName.key -out $crtName.crt

expect "*Country Name *:"  {send "\n" }
expect "*State or Province Name *"  {send "\n" }
expect "*Locality Name *"  {send "\n" }
expect "*Organization Name *"  {send "jrwong\n" }
expect "*Organizational Unit Name *"  {send "\n" }
expect "*Common Name *" {send "${IP}\n"}
expect "*Email Address *" {send "\n"}

interact
