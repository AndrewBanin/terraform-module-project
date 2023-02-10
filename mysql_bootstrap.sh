#!/bin/bash
# Install MySQL
# # Installation of mysql
echo "Installing mysql repo packages"
sudo yum install -y https://repo.mysql.com//mysql80-community-release-el7-5.noarch.rpm
wait
sudo yum install -y mysql-server

## Starting mysql server (first run)'
sudo systemctl start mysqld

## Getting mysql temp root password
tempRootDBPass="`sudo grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'`"
echo "myslq temp password is $tempRootDBPass"

## Setting up new mysql server root password'
sudo systemctl stop mysqld.service
sudo rm -rf /var/lib/mysql/*logfile*
sudo systemctl start mysqld.service
mysqladmin -u root --password="$tempRootDBPass" password "$MYSQLROOTPASS"
mysql -u root --password="$MYSQLROOTPASS" -e <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    DELETE FROM mysql.user where user != 'mysql.sys';
    FLUSH PRIVILEGES;
    EXIT
EOSQL

wait

## Creating database, user and password
mysql -u root -p$MYSQLROOTPASS <<QUERY_INPUT
    CREATE USER '$DBUSER'@'%' IDENTIFIED BY '$DBPASS';
    CREATE DATABASE $DBNAME;
    GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'%';
    FLUSH PRIVILEGES;
    EXIT
QUERY_INPUT