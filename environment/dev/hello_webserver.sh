#!/bin/bash
yum update -y
yum install httpd -y
echo "<html><h1>Hello Cloud Gurus Welcome To My Webpage</h1></html>" > /var/www/html/index.html
service httpd start
chkconfig httpd on