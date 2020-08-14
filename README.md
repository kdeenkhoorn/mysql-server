## MySQL Server
This docker image is an armhf version of MySQL Community Server based on my own debian stable linux image.

# Image dependencies:
- One volume /var/lib/mysql required for persistent storage
- Port 3306 for database access to the MySQL daemon.
- Port 33060 for database access to the MySQL daemon.

# Build characteristics:
This image is build from source on a Odroid HC2 on the following base:
- Debian stable (kdedesign/debian-stable:latest)
- MySQL Community Server : https://dev.mysql.com/downloads/mysql/

# Typical run command:
This run line expects a directory /var/lib/mysql for persistant storage:
```
$ docker run -d --restart always -p 3306:3306 -v /var/lib/mysql:/var/lib/mysql --name=mysqld kdedesign/mysql-server:latest
```
What will it do at startup time:
- If the file /var/lib/mysql/auto.cnf exists in /var/lib/mysql the MySQL server starts mysqld_safe with the existing database structure.
- if the file /var/lib/mysql/auto.cnf does not exists in /var/lib/mysql the MySQL server will start creating a new database. The initial password can be found inside the logging.

# entrypoint.sh contents:
```
#!/bin/bash

if [ -f /var/lib/mysql/auto.cnf ];
then
     echo "MYSQL: Instance allready initialised ..."
     exec /usr/local/mysql/bin/mysqld_safe "$@"
else
     echo "MYSQL: New instance installation ..." 
     /usr/local/mysql/bin/mysqld --initialize --user=mysql
     /usr/local/mysql/bin/mysql_ssl_rsa_setup
     exec /usr/local/mysql/bin/mysqld_safe "$@"
fi

```


# Catching the logs:
This line is usefull for getting the initial database password
```
docker logs --follow mysqld
```

# Handy commands:
To connect to a database inside the running database container using the MySQL client you can use:
```
$ docker exec -it mysqld /usr/local/mysql/bin/mysql -u root -p 
```

# More info:
The DockerHub url:
- https://hub.docker.com/r/kdedesign/mysql-server

The Dockerfile:
- https://github.com/kdeenkhoorn/mysql-server

To get you running with MySQL:
- https://dev.mysql.com/doc/refman/8.0/en/postinstallation.html

Have fun!

Kl@@s

