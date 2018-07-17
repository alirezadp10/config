#!/bin/bash

title "server block";
do_you_want_continue;
if [ $do_you_want_continue_response = "n" ]
then
    return;
fi
echo "What is the name of the block you want?";
read -r block_name;
sudo adduser $block_name;
echo "What is the name of block domain you want?";
read -r block_domain;
mkdir ~/config/temp;
cp ~/config/libs/nginx-sites-available ~/config/temp;
echo "default server? [Y/n]";
read -r default_server;
if [ $default_server = "y" ]
then
    sed -i "s/80/80 default_server/g" ~/config/temp/nginx-sites-available;
fi;
sed -i "s/root \/var\/www\/html/root \/home\/$block_name/g" ~/config/temp/nginx-sites-available;
sed -i "s/server_name server_domain_or_IP/server_name www.$block_domain $block_domain/g" ~/config/temp/nginx-sites-available;
sed -i "s/\/var\/log\/nginx\/error.log/\/var\/log\/nginx\/error-$block_name.log/g" ~/config/temp/nginx-sites-available;
sed -i "s/\/var\/log\/nginx\/access.log/\/var\/log\/nginx\/access-$block_name.log/g" ~/config/temp/nginx-sites-available;
sudo mv ~/config/temp/nginx-sites-available "/etc/nginx/sites-available/$block_name";
rm -r ~/config/temp;
sudo ln -s "/etc/nginx/sites-available/$block_name" /etc/nginx/sites-enabled/
printf '\n%s\n' "$ip_address $block_domain www.$block_domain" | sudo tee -a /etc/hosts;
printf '%s' "hello from $block_name" | sudo tee -a "/home/$block_name/index.html";
sudo systemctl restart nginx;
sudo systemctl status nginx;
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;