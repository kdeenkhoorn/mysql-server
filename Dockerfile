FROM kdedesign/debian-stretch AS build

# Update basic OS image
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y cmake libncurses5-dev libncursesw5-dev gcc g++ perl wget libssl-dev 

# Start specific part for this first stage of the build
WORKDIR /opt
ARG MYSQLMJR=8.0
ARG MYSQLMNR=13
ARG CPU=4

# Download MYSQL and start build

ADD https://dev.mysql.com/get/Downloads/MySQL-${MYSQLMJR}/mysql-${MYSQLMJR}.${MYSQLMNR}.tar.gz /opt/mysql.tar.gz

# Compile mysqld

RUN tar -zxf ./mysql.tar.gz \
    && rm ./mysql.tar.gz \
    && mkdir -p /opt/mysql-${MYSQLMJR}.${MYSQLMNR}/bld \
    && cd /opt/mysql-${MYSQLMJR}.${MYSQLMNR}/bld \
    && cmake .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/opt/boost \
    && make -j ${CPU} \
    && make DESTDIR=/opt/install install \
    && cd /opt/install \
    && tar -cf /opt/install/mysql-server.tar ./usr

# Start with new base

FROM kdedesign/debian-stretch

# Update basic OS image
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y libncurses5 libncursesw5 openssl  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Copy binaries files from first stage build
COPY --from=build /opt/install/mysql-server.tar \
                    /opt/install/mysql-server.tar

# Copy script files
COPY entrypoint.sh /entrypoint.sh

# Add mysql user and extract compiled software
RUN groupadd mysql \
    && useradd -r -g mysql -s /bin/false mysql \
    && tar -C / -xf /opt/install/mysql-server.tar \
    && rm /opt/install/mysql-server.tar \
    && mkdir -p /usr/local/mysql/data \
    && chown -R mysql:mysql /usr/local/mysql

# Configure Docker Container
VOLUME ["/usr/local/mysql/data"]
EXPOSE 3306 33060

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "--user=mysql" ]
