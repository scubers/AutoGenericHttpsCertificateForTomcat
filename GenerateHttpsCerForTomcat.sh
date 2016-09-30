#!/bin/bash

dir=`echo $0|sed "s/\/[^\/]*$//g"`
cd $dir

serverKeyName="server"
serverCsrName="server"
serverCrtName="server"
serverJKSName="server"
serverP12Name="server"

clientKeyName="client"
clientCrtName="client"

password="123456"

currentIP=`ifconfig en0|grep 'inet '|sed 's/inet //g'|sed 's/ .*//g'|sed 's/[^0-9^\.]//g'`


# 生成服务器密钥文件 --> 生成server.key
openssl genrsa -out "$serverKeyName.key" 1024

# 再运行命令：openssl req -new -out server.csr -key server.key根据密钥文件生成签署文件。
# 犹豫需要输入，使用expect 自动化
# ./server_csr_expect.sh '192.168.33.143'
./otherShell/server_csr_expect.sh "$currentIP" "$serverCsrName" "$serverKeyName"

# exit

# 再运行命令：openssl genrsa -out ca.key 1024生成客户端密钥文件。
openssl genrsa -out $clientKeyName.key 1024

# 再运行命令: openssl req -new -x509 -days 365 -key ca.key -out ca.crt生成客户端的签署文件。
# 犹豫需要输入，使用expect 自动化
./otherShell/client_crt_expect.sh "$currentIP" "$clientKeyName" "$clientCrtName"


# 在当前目录下创建demoCA文件夹，并在demoCA下创建文件index.txt和serial，serial内容为01，index.txt为空，以及文件夹newcerts

demoCA="demoCA"
if [ -d "$demoCA" ];
then
    rm -rf "$demoCA"
fi

mkdir "$demoCA"
mkdir "$demoCA/newcerts"
touch "$demoCA/index.txt"
touch "$demoCA/serial"
echo "01" > "$demoCA/serial"

# 让客户端的签署证书能够被网站服务器的签署证书认识
# openssl ca -in server.csr -out server.crt -cert ca.crt -keyfile ca.key
./otherShell/sever_crt_expect.sh "$serverCsrName" "$serverCrtName" "$clientCrtName" "$clientKeyName"

# 运行命令openssl pkcs12 -export -in server.crt -inkey server.key -out server.p12把服务端签署证书转换浏览器可以识别的PCS12格式,密码使用上面输入的密码“123456”。
./otherShell/convert_to_p12.sh $password "$serverCrtName" "$serverKeyName" "$serverP12Name"

# 运行命令java -cp jetty-5.1.10.jar org.mortbay.util.PKCS12Import server.p12 server.jks，使用jetty中的PKCS12Import工具类完成转换,密码同上.(jetty-5.1.10.jar需要放置到当前文件夹中)
./otherShell/convert_to_jks.sh $password "$serverP12Name" "$serverJKSName"
