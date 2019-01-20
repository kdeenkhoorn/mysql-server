#!/bin/bash
docker run -d --restart always -p 3306:3306 -v /data/docker/mysqld:/usr/local/mysql/data --name=mysqld kdedesign/mysql-server:latest
