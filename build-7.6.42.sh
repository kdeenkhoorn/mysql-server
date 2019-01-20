#!/bin/bash

MYSQLMJR=7.6
MYSQLMNR=42
CPU=4

docker build --network host --build-arg CPU=${CPU} --build-arg MYSQLMJR=${MYSQLMJR} --build-arg MYSQLMNR=${MYSQLMNR} -t kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} .
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR}
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:${MYSQLMJR}
