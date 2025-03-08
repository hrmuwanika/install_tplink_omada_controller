#!/bin/bash

# Omada Controller installer sources: https://community.tp-link.com/en/business/forum/topic/548752
# Linux: https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz

# yum update
yum update -y

# Installl Java 17
sudo yum install java-17-openjdk
sudo wget http://repo.iotti.biz/CentOS/8/x86_64/apache-commons-daemon-jsvc-1.2.2-5.el8.lux.x86_64.rpm
sudo rpm -Uvh apache-commons-daemon-jsvc-1.2.2-5.el8.lux.x86_64.rpm

# Download mongodb
cat <<"EOF" | tee /etc/yum.repos.d/mongodb-org-7.0.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF

sudo dnf -y install mongodb-org 
sudo systemctl enable --now mongod
sudo systemctl start mongod

# Now open your firewall ports
dnf -y install firewalld
firewall-cmd --zone=public --add-port=8088/tcp --permanent     # http connection
firewall-cmd --zone=public --add-port=8043/tcp --permanent     # https connection
firewall-cmd --zone=public --add-port=29810/udp --permanent    # EAP Discovery
firewall-cmd --zone=public --add-port=29811/tcp --permanent    # EAP Management
firewall-cmd --zone=public --add-port=29812/tcp --permanent    # EAP Adoption
firewall-cmd --zone=public --add-port=29813/tcp --permanent    # EAP Upgrades and initialisation check
firewall-cmd --zone=public --add-port=29814/tcp --permanent    # EAP Upgrades and initialisation check
firewall-cmd --reload

# download and install omada installer
wget -c https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz -O - | tar -xz 

# Make scripts and binaries executable    
chmod +x Omada_SDN_Controller_v5.15.8.2_linux_x64/*.sh
chmod +x Omada_SDN_Controller_v5.15.8.2_linux_x64/bin/*

# Install omada controller, by default it is enabled on boot
cd Omada_SDN_Controller_v5.15.8.2_linux_x64/
./install.sh
