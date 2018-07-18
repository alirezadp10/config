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
        echo -e "${BYellow}Do you want continue?[Y/n]${BRed}";
        eval do_you_want_continue_response=null;
        read -r do_you_want_continue_response;
        echo "${NC}";
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

function ProgressBar {
    let _progress=(${1}*100/100*100)/100
    let _done=(${_progress}*10)/10
    let _left=100-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    echo -ne " ${back_Green}${BGreen}${_fill// /_}${back_Yellow}${BYellow}${_empty// /_}${NC}  ${_progress}%\r"
}
