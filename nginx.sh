#!/bin/bash

title "nginx";
do_you_want_continue;
if [ $do_you_want_continue_response = "n" ]
then
    return;
fi
if ! dpkg -s nginx > /dev/null; then
    sudo apt-get install nginx;
    sudo ufw allow 'Nginx HTTP';
    sudo ufw status;
    press_any_key_to_continue;
    sudo sed -i "s/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/g" /etc/nginx/nginx.conf;
fi

sudo systemctl restart nginx;
sudo systemctl status nginx;
press_any_key_to_continue;

echo -e "${BYellow}create server block?[Y/n]${BRed}";
read -r input;
echo -e "${NC}";
if [ $input = "y" ]
then
    source "${DIR}/server-block-for-nginx.sh";
else
    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
fi;