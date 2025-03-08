#!/bin/bash

# Omada software controller installed on Ubuntu 22.04
# 

# 1. Update apt and upgrade system
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

# 2. Install omada dependencies
sudo apt install -y openjdk-11-jdk-headless curl 

# 3. Install MongoDB
wget https://repo.mongodb.org/apt/debian/dists/bookworm/mongodb-org/7.0/main/binary-amd64/mongodb-org-server_7.0.17_amd64.deb
sudo apt install -y ./mongodb-org-server_7.0.17_amd64.deb

# 4. Install jsvc 
sudo apt install -y jsvc

# Download and install Omada Controller Software from Tar
# mkdir omada
# wget https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz
# tar -xvzf Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz -C omada
# cd omada

# sudo chmod +x install.sh
# sudo ./install.sh

# Download and install Omada Controller Software from deb
wget https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.deb
sudo dpkg -i Omada_SDN_Controller_v5.15.8.2_linux_x64.deb

sudo apt install -y ufw
sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw allow 8088/tcp
sudo ufw reload


