#!/bin/bash

URed='\033[4;31m';BRed='\033[1;31m';back_Red='\033[41m';
UGreen='\033[4;32m';BGreen='\033[1;32m';back_Green='\033[42m';
UYellow='\033[4;33m';BYellow='\033[1;33m';back_Yellow='\033[43m';
UBlue='\033[4;34m';BBlue='\033[1;34m';back_Blue='\033[44m';
UPurple='\033[4;35m';BPurple='\033[1;35m';back_Purple='\033[45m';
UCyan='\033[4;36m';BCyan='\033[1;36m';back_Cyan='\033[46m';NC='\033[0m';

title(){
    printf "\033c";
    echo -e "${BRed};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    echo -e ";;;;;;;;;;;;;;;;;;;;;;;;;;;${BYellow}   $1    ${BRed};;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    echo -e ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;${NC}";
    echo "";
    echo "";
    echo "";
}

do_you_want_continue(){
    while true
    do
        echo -e "${BYellow}Do you want continue?[Y/n]${NC}";
        eval do_you_want_continue_response=null;
        read -r do_you_want_continue_response;
        if [ $do_you_want_continue_response = "y" ]
        then
            break;
        elif [ $do_you_want_continue_response = "n" ]
        then
            break;
        fi
        echo "";
        echo -e "${BRed}invalid response${NC}";
        echo "";
    done
}

press_any_key_to_continue(){
    echo -e "${BPurple}";
    read -n 1 -s -r -p "press any key to continue ...";
    echo -e "${NC}";
}

roundcube(){
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
    cat ~/server_config/libs/rouncube-composer.json  | sudo tee composer.json;
    sudo apt-get install php7.2-mbstring;
    sudo apt-get install php7.2-gd;
    sudo apt-get install php7.2-curl;
    sudo apt-get install php7.2-zip;
    sudo apt install php-net-ldap2 php-net-ldap3;
    echo "";
    echo "";
    echo "";
    echo -e "${BBlue}";
    echo -e "create database roundcubemail;";
    echo -e "create user roundcubeuser@localhost;";
    echo -e "set password for roundcubeuser@localhost= password(${BYellow}\"your-password\"${BBlue});";
    echo -e "grant all privileges on roundcubemail.* to roundcubeuser@localhost identified by ${BYellow}'your-password'${BBlue};";
    echo -e "flush privileges;";
    echo -e "exit;";
    echo -e "${NC}";
    echo "";
    echo "";
    echo "";
    echo -e "${BPurple}";
    echo -e "enter mysql password of root user:";
    echo -e "${NC}";
    mysql -u root -p
    echo -e "${BPurple}";
    echo -e "enter mysql password of root user:";
    echo -e "${NC}";
    mysql -u root -p roundcubemail < /home/roundcube/roundcubemail/SQL/mysql.initial.sql
    mkdir ~/server_config/temp;
    cp ~/server_config/libs/roundcube-config ~/server_config/temp;
    echo "enter mysql password of roundcube user:";
    read -r ROUNDCUEBPASSWORD;
    sed -i "s/ROUNDCUEBPASSWORD/$ROUNDCUEBPASSWORD/g" ~/server_config/temp/roundcube-config;
    sed -i "s/tls:\/\/mail.DOMAIN/tls:\/\/mail."$domain"/g" ~/server_config/temp/roundcube-config;
    sed -i "s/PRODUCT_NAME_VALUE/mail."$domain"/g" ~/server_config/temp/roundcube-config;
    sudo mv ~/server_config/temp/roundcube-config ~/server_config/temp/config.inc.php
    sudo mv ~/server_config/temp/config.inc.php /home/roundcube/roundcubemail/config/
    rm -r ~/server_config/temp;
    sudo chown -R roundcube:roundcube /home/roundcube;
    sudo chown www-data:www-data temp/ logs/ -R;
    mkdir ~/server_config/temp;
    cp ~/server_config/libs/nginx-sites-available ~/server_config/temp;
    sed -i "s/root \/var\/www\/html/root \/home\/roundcube\/roundcubemail/g" ~/server_config/temp/nginx-sites-available;
    sed -i "s/server_name server_domain_or_IP/server_name mail.$domain/g" ~/server_config/temp/nginx-sites-available;
    sed -i "s/\/var\/log\/nginx\/error.log/\/var\/log\/nginx\/error-roundcube.log/g" ~/server_config/temp/nginx-sites-available;
    sed -i "s/\/var\/log\/nginx\/access.log/\/var\/log\/nginx\/access-roundcube.log/g" ~/server_config/temp/nginx-sites-available;
    sudo mv ~/server_config/temp/nginx-sites-available "/etc/nginx/sites-available/roundcube";
    rm -r ~/server_config/temp;
    sudo ln -s "/etc/nginx/sites-available/roundcube" /etc/nginx/sites-enabled/
    printf '\n%s\n' "$ip_address mail.$domain" | sudo tee -a /etc/hosts;
    sudo systemctl restart nginx;
    sudo systemctl status nginx;
    press_any_key_to_continue;
    sudo certbot --nginx -d $domain -d mail.$domain
    echo "";
    echo "";
    echo "";
    echo -e "${BYellow}";
    echo "enter these commands with roundcube user in /home/roundcube";
    echo -e "${BBlue}";
    echo "gpg --import pubkey.asc";
    echo "gpg --verify roundcubemail-1.2.2.tar.gz.asc";
    echo "";
    echo -e "${BYellow}";
    echo "enter this command with roundcube user in /home/roundcube/roundcubemail";
    echo -e "${BBlue}";
    echo "composer install --no-dev";
    echo -e "${NC}";
    echo "";
    echo "";
    echo "";
    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
}

######################################
############ adjust ufw ##############
######################################

adjust_ufw(){
    title "ufw";
    do_you_want_continue;
    if [ $do_you_want_continue_response = "n" ]
    then
        return;
    fi

    sudo ufw allow OpenSSH;
    sudo ufw enable;
    sudo ufw status;
    press_any_key_to_continue;
}

######################################
########### install bind9 ############
######################################

bind9(){
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
    mkdir ~/server_config/temp;
    cp ~/server_config/libs/bind9-zone-file ~/server_config/temp;
    sed -i "s/LOCALHOST/$domain/g" ~/server_config/temp/bind9-zone-file;
    sed -i "s/IP_ADDRESS/$ip_address/g" ~/server_config/temp/bind9-zone-file;
    sudo mv ~/server_config/temp/bind9-zone-file "/etc/bind/db.$domain";
    rm -r ~/server_config/temp;
    named-checkzone $domain "/etc/bind/db.$domain";
    press_any_key_to_continue;
    sudo systemctl restart bind9;
    sudo ufw allow bind9;
    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
}

######################################
########## install php7.2 ############
######################################

php7.2(){
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
}

######################################
#######  install mysql server  #######
######################################

mysql_server(){
    title "mysql server";
    do_you_want_continue;
    if [ $do_you_want_continue_response = "n" ]
    then
        return;
    fi

    if ! dpkg -s postfix > /dev/null; then
        sudo apt-get install mysql-server;
    fi

    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
}

######################################
###########  install git  ############
######################################

git(){
    title "git";
    do_you_want_continue;
    if [ $do_you_want_continue_response = "n" ]
    then
        return;
    fi

    if ! dpkg -s git > /dev/null; then
        sudo apt-get install git;
    fi

    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
}

######################################
##########  install nginx  ###########
######################################

nginx(){
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
        sudo sed -i "s/80 default_server/80/g" /etc/nginx/sites-available/default;
    fi

    sudo systemctl restart nginx;
    sudo systemctl status nginx;
    press_any_key_to_continue;

    echo "create server block?[Y/n]";
    read -r input;
    if [ $input = "y" ]
    then
        server_block_for_nginx;
    else
        echo -e "${BGreen}Done!${NC}";
        press_any_key_to_continue;
    fi;
}

######################################
######  server block for nginx  ######
######################################

server_block_for_nginx(){
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
    mkdir ~/server_config/temp;
    cp ~/server_config/libs/nginx-sites-available ~/server_config/temp;
    echo "default server? [Y/n]";
    read -r default_server;
    if [ $default_server = "y" ]
    then
        sed -i "s/80/80 default_server/g" ~/server_config/temp/nginx-sites-available;
    fi;
    sed -i "s/root \/var\/www\/html/root \/home\/$block_name/g" ~/server_config/temp/nginx-sites-available;
    sed -i "s/server_name server_domain_or_IP/server_name www.$block_domain $block_domain/g" ~/server_config/temp/nginx-sites-available;
    sed -i "s/\/var\/log\/nginx\/error.log/\/var\/log\/nginx\/error-$block_name.log/g" ~/server_config/temp/nginx-sites-available;
    sed -i "s/\/var\/log\/nginx\/access.log/\/var\/log\/nginx\/access-$block_name.log/g" ~/server_config/temp/nginx-sites-available;
    sudo mv ~/server_config/temp/nginx-sites-available "/etc/nginx/sites-available/$block_name";
    rm -r ~/server_config/temp;
    sudo ln -s "/etc/nginx/sites-available/$block_name" /etc/nginx/sites-enabled/
    printf '\n%s\n' "$ip_address $block_domain www.$block_domain" | sudo tee -a /etc/hosts;
    printf '%s' "hello from $block_name" | sudo tee -a "/home/$block_name/index.html";
    sudo systemctl restart nginx;
    sudo systemctl status nginx;
    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
}

certbot(){
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

    sudo certbot --nginx -d $domain -d www.$domain
    echo -e "${BGreen}Done!${NC}";
    press_any_key_to_continue;
}

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
#######################################################################################################################

echo "what is your domain name?(ex: alirezadp10.ir)";
read -r domain;
echo "what is your ip address?";
read -r ip_address;

while true
do
    printf "\033c";
    echo "which package to install?";
    echo "default";
    echo "roundcube";
    echo "bind9";
    echo "php7.2";
    echo "mysql-server";
    echo "git";
    echo "nginx";
    echo "server-block-for-nginx";
    echo "certbot";
    echo "-----------------";
    echo "Type exit To Exit";
    read -r choose;

    if [ $choose = "default" ]
    then
        adjust_ufw;
        nginx;
        mysql_server;
        php7.2;
        git;
        certbot;
        roundcube;
    elif [ $choose = "roundcube" ]
    then
        roundcube;
    elif [ $choose = "bind9" ]
    then
        bind9;
    elif [ $choose = "php7.2" ]
    then
        php7.2;
    elif [ $choose = "mysql-server" ]
    then
        mysql_server;
    elif [ $choose = "git" ]
    then
        git;
    elif [ $choose = "nginx" ]
    then
        nginx;
    elif [ $choose = "server-block-for-nginx" ]
    then
        server_block_for_nginx;
    elif [ $choose = "certbot" ]
    then
        certbot;
    elif [ $choose = "exit" ]
    then
        printf "\033c";
        exit;
    fi;
done
