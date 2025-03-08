#!/bin/bash

# Omada Controller installer sources: https://community.tp-link.com/en/business/forum/topic/548752
# Linux:            https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz

# Info for RHEL and Omada Software Controller
#   Omada Software Controller require jsvc but on Red Hat 8 jsvc is not available per defauls/for free
#   you have to buy a license.
OMADAURL="https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz" && echo "URL set: ${OMADAURL}"

# Set vars
OMADATARGZ=$(echo "${OMADAURL}" | awk '{split($0,a,"/"); print a[9]}') && echo "Omada installer filename set: ${OMADATARGZ}"
MYINSTALLERFOLDER=$(echo "${OMADATARGZ}" | sed 's/\.tar\.gz//') && echo "Omada install folder set: ${MYINSTALLERFOLDER}"
MYOMADAVERSION=$(echo "${OMADATARGZ}" | awk '{split($0,a,"_"); print a[4]}') && echo "Omada version: ${MYOMADAVERSION}"
OMADADEST="/opt/tplink/EAPController"

# yum update
yum update -y

# Installl Java 11
sudo yum install –y java-11-openjdk.x86_64

# Download mongodb
cat <<"EOF" | tee /etc/yum.repos.d/mongodb-org-7.0.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF

sudo dnf repolist
sudo dnf install mongodb-org mongodb-mongosh
sudo systemctl enable --now mongod
sudo systemctl status mongod

# download and install omada installer
wget -c ${OMADAURL} -O - | tar -xz 

# Make scripts and binaries executable    
chmod +x ${MYINSTALLERFOLDER}/*.sh
chmod +x ${MYINSTALLERFOLDER}/bin/*

# Install omada controller, by default it is enabled on boot
cd ${MYINSTALLERFOLDER}
./install.sh
