#!/bin/bash

title "php7.2";
do_you_want_continue;
if [ $do_you_want_continue_response = "n" ]
then
    return;
fi

find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep 'deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main' &> /dev/null
if ! [ $? == 0 ]; then
    sudo apt-get install python-software-properties;
    sudo add-apt-repository ppa:ondrej/php;
    sudo apt-get update;
fi

sudo apt-get install -y php7.2;
sudo apt-get install php7.2-fpm;
sudo apt-get install php7.2-mysql;
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.2/fpm/php.ini;
sudo systemctl restart php7.2-fpm;
export LANG="en_US.utf8"
export LANGUAGE="en_US.utf8"
export LC_ALL="en_US.UTF-8"
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;
