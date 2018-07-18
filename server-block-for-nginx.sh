#!/bin/bash

title "server block";
do_you_want_continue;
if [ $do_you_want_continue_response = "n" ]
then
    return;
fi
echo -e "${BYellow}what is the name of the block you want? (ex: alirezadp10)${BRed}";
read -r block_name;
echo -e "${NC}";
sudo adduser $block_name;
echo -e "${BYellow}what is the address of block? (ex: alirezadp10.ir)${BRed}";
read -r block_domain;
echo -e "${NC}";
mkdir "${DIR}/temp";
cp "${DIR}/libs/nginx-sites-available" "${DIR}/temp";
echo -e "${BYellow}default server? [Y/n]${BRed}";
read -r default_server;
echo -e "${NC}";
if [ $default_server = "y" ]
then
    find /etc/nginx/sites-available -type f -name "*" -print0 | sudo xargs -0 sed -i "s/80 default_server/80/g"
    sed -i "s/80/80 default_server/g" "${DIR}/temp/nginx-sites-available";
fi;
sed -i "s/root \/var\/www\/html/root \/home\/$block_name/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/server_name server_domain_or_IP/server_name www.$block_domain $block_domain/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/\/var\/log\/nginx\/error.log/\/var\/log\/nginx\/error-$block_name.log/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/\/var\/log\/nginx\/access.log/\/var\/log\/nginx\/access-$block_name.log/g" "${DIR}/temp/nginx-sites-available";
sudo mv "${DIR}/temp/nginx-sites-available" "/etc/nginx/sites-available/$block_name";
rm -r "${DIR}/temp";
sudo ln -s "/etc/nginx/sites-available/$block_name" /etc/nginx/sites-enabled/
printf '\n%s\n' "$ip_address $block_domain www.$block_domain" | sudo tee -a /etc/hosts;
printf '%s' "hello from $block_name" | sudo tee -a "/home/$block_name/index.html";
sudo systemctl restart nginx;
sudo systemctl status nginx;
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;
