#!/bin/bash

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
