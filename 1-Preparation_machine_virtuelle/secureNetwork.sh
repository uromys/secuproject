#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

#TODO anael alias delUser => appel de la fonction 

# Secure the network
secure(){
	echo "Securing network"
	deluser telnetd;   
	./securityFile.sh del_without_parent
	rm /etc/inetd.conf
	sed -i -E "s/^telnet\s+([[:digit:]]+\/[[:alpha:]])+/#telnet \1/" /etc/services
	echo "[SecurityNetwork] ; $(date) ; Network secured" >> scripts_log.md
}

# arg call
case $1 in 
        secure) "$@";exit;;
esac     

