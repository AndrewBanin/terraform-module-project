#!/bin/bash
#Bash script to install and configure wordpress
#######################################
# Section 1
#Installation requirements
#update system
echo "updating OS"
sudo yum update -y
wait
echo "your OS was successfully updates"
#Installation of Appache server
echo "Installing apache server"
sudo yum install -y httpd
wait
echo "Apache was successfully installed on your system"
#Installation of php
echo "Installing php"
sudo yum install -y amazon-linux-extras
wait
echo "php was successfully installed"
#Enabling php7.4
sudo amazon-linux-extras enable php7.4
echo "php7.4 was successfully enabled"
#cleaning matadata
echo "Cleaning matadata"
sudo yum clean metadata
wait
echo "matadata was successfully cleaned"
#Installation of php libraries
echo "Installing php libraries"
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap}
wait
echo "php libraries were successfully installed"

# Installation of wget
echo "Installing wget"
sudo yum install wget -y
wait
echo "wget successfully installed"
# Installation of wordpress
echo "Changing Directory to var/www/html/"
cd /var/www/html/
echo "Downloading wordpress"
sudo wget http://wordpress.org/latest.tar.gz
wait
echo "Extracting wordpress"
sudo tar -xzf latest.tar.gz
echo "Changing directory to wordpress"
cd wordpress/
# Move wordpress to document root
echo "moving wordpress to document root"
sudo mv wp-config-sample.php wp-config.php
echo "wordpress was sucessfully installed"
# Setting permissions to wordpress directories
echo "changing ownership of apache to var/www"
sudo chown -R apache /var/www
echo "changing group permission of apache to var/www"
sudo chgrp -R apache /var/www
echo "Modifying permission of apache to var/www"
sudo chmod 2775 /var/www
# Set permissions on files and directories
echo "setting permissions on files and directories"
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
echo "Permissions were successfully changed"
# Start and enable apache 
echo "starting and enabling apache"
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install tree -y 
wait
sudo ls -la /var/www/html/wordpress
wait
sudo tree /var/www/html/
echo "section completed successfully"

## Add Database Credentias in wordpress
cd /var/www/html/wordpress
sudo perl -pi -e "s/database_name_here/${ENVIRONMENT_NAME}-db/g" wp-config.php
sudo perl -pi -e "s/username_here/$ENVIRONMENT_NAME}/g" wp-config.php
sudo perl -pi -e "s/password_here/$DBPASS/g" wp-config.php
sudo perl -pi -e "s/localhost/$DBHOST/g" wp-config.php

## Restart Apache
sudo systemctl restart httpd

## Cleaning Download
cd ..
sudo rm -rf latest.tar.gz 

echo "Wordpress username is $DBUSER and wordpressdb password is $DBPASS  last mysql root password is $MYSQLROOTPASS"
echo "Congratulations your Installation is complete have a yummy day!"