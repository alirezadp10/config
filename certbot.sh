#!/bin/bash

title "certbot";
do_you_want_continue;
if [ $do_you_want_continue_response = "n" ]
then
    return;
fi

find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep 'deb http://ppa.launchpad.net/certbot/certbot/ubuntu xenial main' &> /dev/null
if ! [ $? == 0 ]; then
    sudo add-apt-repository ppa:certbot/certbot
    sudo apt-get update;
fi

if ! dpkg -s python-certbot-nginx > /dev/null; then
    sudo apt-get install python-certbot-nginx
    sudo ufw allow 'Nginx Full'
    sudo ufw delete allow 'Nginx HTTP'
    sudo ufw status
    press_any_key_to_continue
fi

echo -e "${BYellow}What is the domain name you want to certificated?(ex: alirezadp10.ir)${BRed}";
read -r domain;

sudo certbot --nginx -d $domain -d www.$domain
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;
