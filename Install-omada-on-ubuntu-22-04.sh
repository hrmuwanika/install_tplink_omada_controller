#!/bin/bash
# Info: run this script with sudo or as root user
# It is recommended to update repository and upgrade system before installing dependencies and omada software controller:
# 1. Update apt and upgrade system
apt update && apt upgrade -y

# 2. Install omada dependencies, mongodb deb package and jsvc build dependencies
apt install -y openjdk-11-jdk-headless curl autoconf make gcc

# 3. Install MongoDB
wget https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/4.4/main/binary-amd64/mongodb-org-server_4.4.16_amd64.deb
apt install -y ./mongodb-org-server_4.4.16_amd64.deb

# 4. Compile and install jsvc
mkdir -p /opt/tplink-sources && cd /opt/tplink-sources
# install build dependencies
# download source
wget -c https://dlcdn.apache.org/commons/daemon/source/commons-daemon-1.3.1-src.tar.gz -O - | tar -xz 
# configure and compile
cd commons-daemon-1.3.1-src/src/native/unix
sh support/buildconf.sh
# "/usr/lib/jvm/java-11-openjdk-amd64" is the default installation path of OpenJDK-11.
./configure --with-java=/usr/lib/jvm/java-11-openjdk-amd64
make
# Create a soft link from your JSVC path
ln -s /opt/tplink-sources/commons-daemon-1.3.1-src/src/native/unix/jsvc /usr/bin/

# Download and install Omada Controller Software
wget https://static.tp-link.com/upload/software/2022/202207/20220729/Omada_SDN_Controller_v5.4.6_Linux_x64.deb
dpkg --ignore-depends=jsvc -i ./Omada_SDN_Controller_v5.4.6_Linux_x64.deb
