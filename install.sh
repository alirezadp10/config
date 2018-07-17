#!/bin/bash

#ssh-keygen -f "/home/alirezadp10/.ssh/known_hosts" -R "188.40.166.176"
#scp -r -P 22 Desktop/config root@188.40.166.176:~/

sudo apt-get update;
sudo apt update;
#sudo apt upgrade;
sudo adduser sys_admin;
sudo usermod -aG sudo sys_admin;
sudo chown -R sys_admin:sys_admin /root/config;
sudo -u sys_admin bash menu.sh;
su sys_admin;
