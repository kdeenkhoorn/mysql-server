FROM kdedesign/debian-stable:latest AS build

# Start specific part for this first stage of the build
ARG MYSQLMJR=8.0
ARG MYSQLMNR=15
ARG CPU=4

# Download MYSQL and start build
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y apt-utils ca-certificates cmake libncurses5-dev libncursesw5-dev gcc g++ perl wget git libssl-dev libldap2-dev libsasl2-dev pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && cd /opt \
    && wget -q https://dev.mysql.com/get/Downloads/MySQL-${MYSQLMJR}/mysql-${MYSQLMJR}.${MYSQLMNR}.tar.gz -O /opt/mysql.tar.gz \
    && tar -zxf /opt/mysql.tar.gz \
    && rm /opt/mysql.tar.gz \
    && mkdir -p /opt/mysql-${MYSQLMJR}.${MYSQLMNR}/bld \
    && cd /opt/mysql-${MYSQLMJR}.${MYSQLMNR}/bld \
    && cmake .. -DMYSQL_DATADIR=/var/lib/mysql -DDOWNLOAD_BOOST=ON -DWITH_BOOST=/opt/boost \
    && make VERBOSE=1 -j ${CPU} \
    && make DESTDIR=/opt/install install \
    && cd /opt/install \
    && tar -cf /opt/install/mysql-server-${MYSQLMJR}.${MYSQLMNR}.tar ./usr

# Start with new base

FROM kdedesign/debian-stable:latest

# Set defaults
ARG MYSQLMJR=8.0
ARG MYSQLMNR=15
ARG CPU=4

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
