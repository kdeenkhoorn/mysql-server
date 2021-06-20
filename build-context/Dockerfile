FROM kdedesign/debian-stable:latest AS build

# Start specific part for this first stage of the build
ARG MYSQLMJR=8.0
ARG MYSQLMNR=15
ARG CPU=4
ARG UPLOAD=false

# Download MYSQL and start build
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y apt-utils ca-certificates cmake libncurses5-dev libncursesw5-dev gcc g++ perl wget curl git libssl-dev libldap2-dev libsasl2-dev pkg-config bison libbison-dev \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/boost \
    && cd /opt/boost \
    && wget -q -O /opt/boost/boost_1_73_0.tar.gz https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.tar.gz \
    && cd /opt \
    && wget -q -O /opt/mysql.tar.gz https://dev.mysql.com/get/Downloads/MySQL-${MYSQLMJR}/mysql-${MYSQLMJR}.${MYSQLMNR}.tar.gz \
    && tar -zxf /opt/mysql.tar.gz \
    && rm /opt/mysql.tar.gz \
    && mkdir -p /opt/mysql-${MYSQLMJR}.${MYSQLMNR}/bld \
    && cd /opt/mysql-${MYSQLMJR}.${MYSQLMNR}/bld \
    && cmake .. -DMYSQL_DATADIR=/var/lib/mysql -DWITH_BOOST=/opt/boost \
    && make VERBOSE=1 -j ${CPU} \
    && make DESTDIR=/opt/install install \
    && cd /opt/install \
    && tar -cf /opt/install/mysql-server-${MYSQLMJR}.${MYSQLMNR}.tar ./usr 

# If requested upload buildresult to WebDAV share
RUN if ${UPLOAD} ; then curl -T "/opt/install/mysql-server-${MYSQLMJR}.${MYSQLMNR}.tar" "${URL}" --silent --insecure ; fi

# Start with new base

FROM kdedesign/debian-stable:latest

# Set defaults
ARG MYSQLMJR=8.0
ARG MYSQLMNR=15

# Update basic OS image
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y libncurses5 libncursesw5 openssl libsasl2-2 libldap-2.4-2 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd mysql \
    && useradd -r -g mysql -s /bin/false mysql \
    && mkdir -p /usr/local/mysql /var/lib/mysql \
    && chown -R mysql:mysql /usr/local/mysql /var/lib/mysql

# Copy files
COPY --from=build --chown=mysql:mysql /opt/install/usr /usr
COPY entrypoint.sh /entrypoint.sh

# Configure Docker Container
VOLUME ["/var/lib/mysql"]
EXPOSE 3306 33060
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "--user=mysql" ]
