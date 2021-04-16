#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

# setting the default umask value to 077
secure(){
	echo "Executing secure"
	sed -i -E "s/#?\s*(UMASK\s*)[[:digit:]]+/\1077/" /etc/login.defs
	echo "[MASK] ; $(date) ; Mask set to 077 " >> scripts_log.md
}

# view all files with a umask option
view_option(){
	echo "Executing view_option"
	grep -u umask /etc/* 2> /dev/null
}

# arg call
case $1 in 
        secure) "$@";exit;;
        view_option) "$@";exit;;
esac



