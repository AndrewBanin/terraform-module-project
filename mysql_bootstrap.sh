#!/bin/bash
# Install MySQL
# # Installation of mysql
echo "Installing mysql repo packages"
yum install -y https://repo.mysql.com//mysql80-community-release-el7-5.noarch.rpm
wait
yum install -y mysql-server

## Starting mysql server (first run)'
systemctl start mysqld

## Getting mysql temp root password
tempRootDBPass="`grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'`"
echo "myslq temp password is $tempRootDBPass"

## Setting up new mysql server root password'
systemctl stop mysqld.service
rm -rf /var/lib/mysql/*logfile*
systemctl start mysqld.service
mysqladmin -u root --password="$tempRootDBPass" password "$MYSQLROOTPASS"
mysql -u root --password="$MYSQLROOTPASS" -e <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    DELETE FROM mysql.user where user != 'mysql.sys';
    FLUSH PRIVILEGES;
EOSQL
systemctl status mysqld.service

## Creating database, user and password
mysql -uroot -p$MYSQLROOTPASS <<QUERY_INPUT
CREATE USER '$ENVIRONMENT_NAME'@'%' IDENTIFIED BY '$DBPASS';
CREATE DATABASE ${ENVIROMENT_NAME}-db;
GRANT ALL PRIVILEGES ON ${ENVIRONMENT_NAME}-db.* TO '$ENVIRONMENT_NAME'@'%';
FLUSH PRIVILEGES;
EXIT
QUERY_INPUT
