#!/bin/bash

#Get IP
local_ipv4="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
#!/bin/bash
sudo yum update -y
sudo yum install -y amazon-linux-extras docker
sudo service docker start

sudo amazon-linux-extras install nginx1 -y
sudo amazon-linux-extras install postgresql10 -y
sudo amazon-linux-extras install redis4.0 -y
sudo amazon-linux-extras install tomcat8.5 -y
sudo amazon-linux-extras install php7.3 -y
sudo yum install bind* -y 
sudo yum install vsftpd -y
sudo yum install telnet telnet-server -y
sudo yum install gedit -y

sudo systemctl start nfs.service
sudo systemctl enable nfs.service

sudo systemctl start vsftpd.service
sudo systemctl enable vsftpd.service
sudo systemctl start nginx.service 
sudo systemctl enable nginx.service

sudo systemctl start named.service
sudo systemctl enable named.service
sudo systemctl start telnet.socket 
sudo systemctl enable telnet.socket 

sudo docker run -d -p 0.0.0.0:8080:8080 -p 0.0.0.0:9090:9090 -e TZ=Europe/Amsterdam webgoat/goatandwolf

