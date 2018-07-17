#!/bin/bash

title "bind9";
do_you_want_continue;
if [ $do_you_want_continue_response = "n" ]
then
    return;
fi

echo "what is your domain name?(ex: alirezadp10.ir)";
read -r domain;
echo "what is your ip address?";
read -r ip_address;

echo "append this text to /etc/bind/named.conf.local:";
printf '\n%s\n' "zone \"$domain\" {" | sudo tee -a /etc/bind/named.conf.local;
printf '\t%s\n' "type master;" | sudo tee -a /etc/bind/named.conf.local;
printf '\t%s\n' "file \"/etc/bind/db.$domain\";" | sudo tee -a /etc/bind/named.conf.local;
printf '%s' "};" | sudo tee -a /etc/bind/named.conf.local;
press_any_key_to_continue;
mkdir "${DIR}/temp";
cp "${DIR}/libs/bind9-zone-file" "${DIR}/temp";
sed -i "s/LOCALHOST/$domain/g" "${DIR}/temp/bind9-zone-file";
sed -i "s/IP_ADDRESS/$ip_address/g" "${DIR}/temp/bind9-zone-file";
sudo mv "${DIR}/temp/bind9-zone-file" "/etc/bind/db.$domain";
rm -r "${DIR}/temp";
named-checkzone $domain "/etc/bind/db.$domain";
press_any_key_to_continue;
sudo systemctl restart bind9;
sudo ufw allow bind9;
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;
