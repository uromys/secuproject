#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi


configure(){
  echo "Configure routing"
  sudo sed -i -E "s/#?\s*(net.ipv4.ip_forward=\s*)1/\10/" /etc/sysctl.conf
  sudo sysctl -p /etc/sysctl.conf
  echo "[Routing] ; $(date) ; configure net.ipv4.ip_forward " >> scripts_log.md
}


# arg call
case $1 in
        configure) "$@";exit;;
esac
