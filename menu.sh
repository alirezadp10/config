#!/bin/bash

source style.sh

echo -e "${BYellow}what is your domain name?(ex: alirezadp10.ir)${BRed}";
read -r domain;
echo -e "${BYellow}what is your ip address?${BRed}";
read -r ip_address;

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";

while true
do
    printf "\033c";
    echo -e "${BRed}which package to install?";
    echo -e "${BYellow}"
    echo -e "default";
    echo -e "roundcube";
    echo -e "bind9";
    echo -e "php7.2";
    echo -e "mysql-server";
    echo -e "git";
    echo -e "nginx";
    echo -e "server-block-for-nginx";
    echo -e "certbot";
    echo -e "${BRed}"
    echo -e "-----------------";
    echo -e "Type exit To Exit";
    echo -e "${BCyan}";
    read -r choose;

    if [ $choose = "default" ]
    then
        source adjust-ufw.sh;
        source nginx.sh;
        source mysql-server.sh;
        source php7.2.sh;
        source git.sh;
        source certbot.sh;
        source roundcube.sh
    elif [ $choose = "roundcube" ]
    then
        source roundcube.sh
    elif [ $choose = "bind9" ]
    then
        source bind9.sh;
    elif [ $choose = "php7.2" ]
    then
        source php7.2.sh;
    elif [ $choose = "mysql-server" ]
    then
        source mysql-server.sh;
    elif [ $choose = "git" ]
    then
        source git.sh;
    elif [ $choose = "nginx" ]
    then
        source nginx.sh;
    elif [ $choose = "server-block-for-nginx" ]
    then
        source server-block-for-nginx.sh;
    elif [ $choose = "certbot" ]
    then
        source certbot.sh;
    elif [ $choose = "exit" ]
    then
        printf "\033c";
        exit;
    fi;
done
