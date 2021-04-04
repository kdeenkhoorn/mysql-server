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

# Build instructions:
To start the build call build.sh with the following options:
```
./build.sh [-M (Majorversion) ] [ -m (minorversion)] [ -c (#cpu) ] [ -u (URL) ] 
```

Meaning:
```
-M Majorversion to build, for example 8.0 (required)
-m Minorversion to build, for example 23 (required)
-c Number of CPU's to use during compile fase (required)
-u Upload buildresult to WebDAV URL (for personal use and not required)
```

Example:
If you would like to build version 8.0.23 execute:
```
./build.sh -M 8.0 -m 23 -c 4
```
Or to upload the buildresult file `mysql-server-8.0.23.tar` to URL https://www.example.com/webdav:
```
./build.sh -M 8.0 -m 23 -c 4 -u https://www.example.com/webdav
```

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

