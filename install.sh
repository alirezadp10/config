#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";

source "${DIR}/style.sh";

sudo apt-get update;
sudo apt update;
sudo apt upgrade;
printf "\033c";


echo -e "${BYellow}do you have already system administrator user? [Y/n]${BRed}";
read -r input;
echo -e "${NC}";
if [ $input = "y" ]
then
    echo -e "${BYellow}write your name of the user is system administrator: (ex: sammy)${BRed}";
    read -r admin;
    echo -e "${NC}";
else
    echo -e "${BYellow}write the name of user you want to be system administrator: (ex: sammy)${BRed}";
    read -r admin;
    echo -e "${NC}";
    sudo adduser ${admin};
fi;

printf "\033c";
sudo usermod -aG sudo ${admin};
sudo chown -R ${admin}:${admin} ${DIR};
sudo -u ${admin} bash "${DIR}/menu.sh"