#!/bin/bash

MYSQLMJR=8.0
MYSQLMNR=13
CPU=4

docker build --network host --build-arg CPU=${CPU} --build-arg MYSQLMJR=${MYSQLMJR} --build-arg MYSQLMNR=${MYSQLMNR} -t kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} .
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR}
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:${MYSQLMJR}
