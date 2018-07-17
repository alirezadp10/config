#!/bin/bash

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
