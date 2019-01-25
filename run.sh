#!/bin/bash
docker run -d --restart always -p 3306:3306 -v /data/docker/mysqld:/var/lib/mysql --name=mysqld kdedesign/mysql-server:8.0.14
