#!/usr/bin/expect

set IP [lindex $argv 0]
set csrName [lindex $argv 1]
set keyName [lindex $argv 2]

spawn openssl req -new -out $csrName.csr -key $keyName.key

expect "*Country Name *:"  {send "\n" }
expect "*State or Province Name *"  {send "\n" }
expect "*Locality Name *"  {send "\n" }
expect "*Organization Name *"  {send "jrwong\n" }
expect "*Organizational Unit Name *"  {send "\n" }
expect "*Common Name *" {send "${IP}\n"}
expect "*Email Address *" {send "\n"}
expect "*A challenge password *" {send "\n"}
expect "*An optional company name *" {send "\n"}

interact
