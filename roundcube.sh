#!/bin/bash

title "roundcube";
do_you_want_continue;
if [ $do_you_want_continue_response = "n" ]
then
    return;
fi
sudo apt-get install postfix
sudo sed -i "s/myhostname = /#myhostname = /g" /etc/postfix/main.cf;
printf '\n%s\n' "myhostname = $domain" | sudo tee -a /etc/postfix/main.cf;
sudo sed -i "s/myorigin = /#myorigin = /g" /etc/postfix/main.cf;
printf '\n%s\n' "myorigin = $domain" | sudo tee -a /etc/postfix/main.cf;
sudo sed -i "s/mydestination = /#mydestination = /g" /etc/postfix/main.cf;
printf '\n%s\n' "mydestination = mail.$domain, localhost.$domain, localhost, $domain" | sudo tee -a /etc/postfix/main.cf;
sudo sed -i "s/mynetworks = /#mynetworks = /g" /etc/postfix/main.cf;
printf '\n%s\n' "mynetworks= $ip_address 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128" | sudo tee -a /etc/postfix/main.cf;
printf '\n%s\n' "home_mailbox = Maildir/new/mail" | sudo tee -a /etc/postfix/main.cf;
sudo ufw allow Postfix;
sudo apt-get install dovecot-core dovecot-imapd
printf '\n%s\n' "protocols = imap" | sudo tee -a /etc/dovecot/dovecot.conf;
sudo sed -i "s/#   mail_location = maildir:~\/Maildir/   mail_location = maildir:~\/Maildir/g" /etc/dovecot/conf.d/10-mail.conf;
sudo sed -i "s/mail_location = mbox:~\/mail:INBOX=\/var\/mail\/%u/#mail_location = mbox:~\/mail:INBOX=\/var\/mail\/%u/g" /etc/dovecot/conf.d/10-mail.conf;
sudo sed -i "s/#disable_plaintext_auth = yes/disable_plaintext_auth = no/g" /etc/dovecot/conf.d/10-auth.conf;
sudo sed -i "s/auth_mechanisms = plain/auth_mechanisms = plain login/g" /etc/dovecot/conf.d/10-auth.conf;
sudo sed -i ':a;N;$!ba;s/unix_listener auth-userdb {.*#group =\n  }/\tunix_listener auth-userdb {\n\t\t#mode = 0666\n\t\tuser = postfix\n\t\tgroup = postfix\n\t}/g' /etc/dovecot/conf.d/10-master.conf
sudo systemctl restart dovecot.service;
sudo adduser roundcube;
cd /home/roundcube
sudo apt install wget;
sudo wget https://github.com/roundcube/roundcubemail/releases/download/1.2.2/roundcubemail-1.2.2.tar.gz;
sudo chown -R roundcube:roundcube /home/roundcube;
sudo wget https://roundcube.net/download/pubkey.asc;
sudo chown -R roundcube:roundcube /home/roundcube;
sudo wget https://github.com/roundcube/roundcubemail/releases/download/1.2.2/roundcubemail-1.2.2.tar.gz.asc;
sudo chown -R roundcube:roundcube /home/roundcube;
sudo tar xvf /home/roundcube/roundcubemail-1.2.2.tar.gz;
sudo mv roundcubemail-1.2.2 roundcubemail;
cd /home/roundcube/roundcubemail;
sudo apt install composer;
sudo mv composer.json-dist composer.json;
cat "${DIR}/libs/rouncube-composer.json"  | sudo tee composer.json;
sudo apt-get install php7.2-mbstring;
sudo apt-get install php7.2-gd;
sudo apt-get install php7.2-curl;
sudo apt-get install php7.2-zip;
sudo apt install php-net-ldap2 php-net-ldap3;
echo -e "";
echo -e "";
echo -e "";
echo -e "${BBlue}";
echo -e "create database roundcubemail;";
echo -e "create user roundcubeuser@localhost;";
echo -e "set password for roundcubeuser@localhost= password(${BYellow}\"your-password\"${BBlue});";
echo -e "grant all privileges on roundcubemail.* to roundcubeuser@localhost identified by ${BYellow}'your-password'${BBlue};";
echo -e "flush privileges;";
echo -e "exit;";
echo -e "${NC}";
echo -e "";
echo -e "";
echo -e "";
echo -e "${BYellow}";
echo -e "enter mysql password of ${BRed}root${BYellow} user:";
echo -e "${NC}";
mysql -u root -p
echo -e "${BYellow}";
echo -e "enter mysql password of ${BRed}root${BYellow} user:${BRed}";
mysql -u root -p roundcubemail < /home/roundcube/roundcubemail/SQL/mysql.initial.sql
echo -e "${NC}";
mkdir "${DIR}/temp";
cp "${DIR}/libs/roundcube-config" "${DIR}/temp";
echo -e "${BYellow}enter mysql password of ${BRed}roundcube${BYellow} user:${BRed}";
read -r ROUNDCUEBPASSWORD;
echo -e "${NC}";
sed -i "s/ROUNDCUEBPASSWORD/$ROUNDCUEBPASSWORD/g" "${DIR}/temp/roundcube-config";
sed -i "s/tls:\/\/mail.DOMAIN/tls:\/\/mail."$domain"/g" "${DIR}/temp/roundcube-config";
sed -i "s/PRODUCT_NAME_VALUE/mail."$domain"/g" "${DIR}/temp/roundcube-config";
sudo mv "${DIR}/temp/roundcube-config" "${DIR}/temp/config.inc.php"
sudo mv "${DIR}/temp/config.inc.php" /home/roundcube/roundcubemail/config/
rm -r "${DIR}/temp";
sudo chown -R roundcube:roundcube /home/roundcube;
sudo chown www-data:www-data temp/ logs/ -R;
mkdir "${DIR}/temp";
cp "${DIR}/libs/nginx-sites-available" "${DIR}/temp";
sed -i "s/root \/var\/www\/html/root \/home\/roundcube\/roundcubemail/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/server_name server_domain_or_IP/server_name mail.$domain/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/\/var\/log\/nginx\/error.log/\/var\/log\/nginx\/error-roundcube.log/g" "${DIR}/temp/nginx-sites-available";
sed -i "s/\/var\/log\/nginx\/access.log/\/var\/log\/nginx\/access-roundcube.log/g" "${DIR}/temp/nginx-sites-available";
sudo mv "${DIR}/temp/nginx-sites-available" "/etc/nginx/sites-available/roundcube";
rm -r "${DIR}/temp";
sudo ln -s "/etc/nginx/sites-available/roundcube" /etc/nginx/sites-enabled/
printf '\n%s\n' "$ip_address mail.$domain" | sudo tee -a /etc/hosts;
sudo systemctl restart nginx;
sudo systemctl status nginx;
press_any_key_to_continue;
sudo certbot --nginx -d $domain -d mail.$domain
echo -e "";
echo -e "";
echo -e "";
echo -e "${BYellow}";
echo -e "enter these commands with roundcube user in /home/roundcube";
echo -e "${BRed}";
echo -e "gpg --import pubkey.asc";
echo -e "gpg --verify roundcubemail-1.2.2.tar.gz.asc";
echo -e "";
echo -e "${BYellow}";
echo -e "enter this command with roundcube user in /home/roundcube/roundcubemail";
echo -e "${BRed}";
echo -e "composer install --no-dev";
echo -e "${NC}";
echo -e "";
echo -e "";
echo -e "";
echo -e "${BGreen}Done!${NC}";
press_any_key_to_continue;
