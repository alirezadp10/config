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

readarray -t users <<< "$(ls /home)"
users+=('custom path')
users+=('add new user')
PS3= echo -e "${BRed}Where will your block be?${BYellow}";
select opt in "${users[@]}"
do
    if [ "$opt" = "" ]
    then
        echo -e "${BRed}invalid choice, retry${BYellow}";
    else
        echo -e "${NC}";
        break;
    fi
done

if [ "$opt" = "add new user" ]
then
    sudo adduser $block_name;
    block_dir="$block_name";
    opt="";
elif [ "$opt" = "custom path" ]
then
    echo -e "${BYellow}write your path (ex: ${BRed}/home/${BYellow}alirezadp10/develop/wordpress)${BRed}";
    read -r custom_path;
    echo -e "${NC}";
    sudo mkdir "${custom_path}/${block_name}";
    echo -e "${BYellow}write owner (ex: alirezadp10)${BRed}";
    read -r owner;
    sudo chown -R ${owner}:${owner} ${custom_path};
    opt="$(echo ${custom_path} | cut -c7-)"
else
    sudo mkdir "/home/${opt}/${block_name}";
    sudo chown -R "${opt}:${opt}" "/home/${opt}/${block_name}";
fi

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
sed -i "s/root \/var\/www\/html/root \/home\/${opt//\//\\/}\/$block_name/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/server_name server_domain_or_IP/server_name www.$block_domain $block_domain/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/\/var\/log\/nginx\/error.log/\/var\/log\/nginx\/error-$block_name.log/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/\/var\/log\/nginx\/access.log/\/var\/log\/nginx\/access-$block_name.log/g" "${DIR}/temp/nginx-sites-available";
sudo mv "${DIR}/temp/nginx-sites-available" "/etc/nginx/sites-available/$block_name";
rm -r "${DIR}/temp";
sudo ln -s "/etc/nginx/sites-available/$block_name" /etc/nginx/sites-enabled/
printf '\n%s\n' "$ip_address $block_domain www.$block_domain" | sudo tee -a /etc/hosts;
printf '%s' "<h1>Hello World!</h1>" | sudo tee -a "/home/$opt/$block_name/index.html";
sudo systemctl restart nginx;
sudo systemctl status nginx;
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;
