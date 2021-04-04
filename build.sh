#!/bin/bash

# Set variables what to build and how
usage() { echo "Usage: $0 [-M (Majorversion) ] [ -m (minorversion)] [ -c (#cpu) ] [ -u (URL) ]" 1>&2; exit 1; }

UPLOAD=false

while getopts ":M:m:c:u:" o; do
    case "${o}" in
        M)
            MYSQLMJR=${OPTARG}
            ;;
        m)
            MYSQLMNR=${OPTARG}
            ;;
        c)
            CPU=${OPTARG}
            ;;
        u)
            UPLOAD=true
            URL=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${MYSQLMJR}" ] || [ -z "${MYSQLMNR}" ] || [ -z "${CPU}" ]; then
    usage
    exit 1
fi

echo "Building Major version: ${MYSQLMJR}"
echo "Building Minor version: ${MYSQLMNR}"
echo "Building with         : ${CPU} CPU(s)"
echo "Upload buildresult    : ${UPLOAD}"
echo "Upload URL            : ${URL}"

exec > ./build-logging-${MYSQLMJR}.${MYSQLMNR} 2>&1

# Change to buildcontext
cd ./build-context

# Start build
docker build --network host --build-arg URL=${URL} --build-arg UPLOAD=${UPLOAD} --build-arg CPU=${CPU} --build-arg MYSQLMJR=${MYSQLMJR} --build-arg MYSQLMNR=${MYSQLMNR} -t kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} .
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:${MYSQLMJR}
docker tag kdedesign/mysql-server:${MYSQLMJR}.${MYSQLMNR} kdedesign/mysql-server:latest
