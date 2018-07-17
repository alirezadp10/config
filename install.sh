#!/bin/bash

#ssh-keygen -f "/home/alirezadp10/.ssh/known_hosts" -R "188.40.166.176"
#scp -r -P 22 Desktop/config root@188.40.166.176:~/


source style.sh

sudo apt-get update;
sudo apt update;
sudo apt upgrade;

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";

echo -e "${BYellow}do you already have system administrator user? [Y/n]${BRed}";
read -r input;
echo -e "${NC}";
if [ $input = "y" ]
then
    echo -e "${BYellow}write your name of the user is system administrator: (ex: sys_admin)${BRed}";
    read -r admin;
    echo -e "${NC}";
    sudo chown -R ${admin}:${admin} ${DIR};
    printf "\033c";
    sudo -u ${admin} bash "${DIR}/menu.sh";
else
    echo -e "${BYellow}write the name of user you want to be system administrator: (ex: sys_admin)${BRed}";
    read -r admin;
    echo -e "${NC}";
    sudo adduser ${admin};
    sudo usermod -aG sudo ${admin};
    sudo chown -R ${admin}:${admin} ${DIR};
    printf "\033c";
    sudo -u ${admin} bash "${DIR}/menu.sh";
fi;