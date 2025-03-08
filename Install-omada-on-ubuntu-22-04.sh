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
# cd ~/
# wget https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz
# tar -xvzf Omada_SDN_Controller_v5.15.8.2_linux_x64.tar.gz 
# cd Omada_SDN_Controller_v5.15.8.2_Linux_x64/

# sudo chmod +x install.sh
# sudo ./install.sh

# rm -rf Omada_SDN_Controller_v5.15.8.2_Linux_x64/ && rm Omada_SDN_Controller_v5.15.8.2_Linux_x64.tar.gz

# Download and install Omada Controller Software from deb
wget https://static.tp-link.com/upload/software/2025/202501/20250109/Omada_SDN_Controller_v5.15.8.2_linux_x64.deb
sudo dpkg -i Omada_SDN_Controller_v5.15.8.2_linux_x64.deb

rm Omada_SDN_Controller_v5.15.8.2_linux_x64.deb

# Installing and configuring ufw firewall
# 22 - SSH access
# TCP 8088 – Manages the Omada Controller using an HTTP connection.
# 8043 – Manages the Controller over HTTPS.
# 8843 – Users authenticate over HTTPS when the captive portal is on.
# 29811,29812 – Manages devices on the controller.
# 29814 – Adopts devices to the controller.
# 27217 – Grants the application access to the database.
# UDP 29810 – Discovers devices pointed to the server.

sudo apt install -y ufw
sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw allow 8088,8043,8843,29811,29812,29814,27217/tcp comment "Omada Controller Ports"
sudo ufw allow 29810/udp comment "Omada Controller UDP"
sudo ufw allow 80/tcp
sudo ufw reload

# Install SSL certificate
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone -d controller.example.com

