#!/bin/bash

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
