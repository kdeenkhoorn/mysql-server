#!/bin/bash

# Set variables what to build and how
MYSQLMJR=8.0
MYSQLMNR=15
CPU=4

exec > ./build-logging-${MYSQLMJR}.${MYSQLMNR} 2>&1

# Change to buildcontext
cd ./build-context

# Start build
docker build --network host --build-arg CPU=${CPU} --build-arg MYSQLMJR=${MYSQLMJR} --build-arg MYSQLMNR=${MYSQLMNR} -t kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} .
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:${MYSQLMJR}
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:latest
