#!/bin/bash

if [ -f /usr/local/mysql/data/auto.cnf ];
then
     echo "MYSQL: Instance allready initialised ..."
     exec /usr/local/mysql/bin/mysqld_safe "$@"
else
     echo "MYSQL: New instance installation ..." 
     /usr/local/mysql/bin/mysqld --initialize --user=mysql
     /usr/local/mysql/bin/mysql_ssl_rsa_setup
     exec /usr/local/mysql/bin/mysqld_safe "$@"
fi
