#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

uninstall_gcc(){
  echo "Uninstall gcc"
  sudo apt-get remove gcc --purge
  sudo apt-get remove gcc-9 --purge
  echo "[gcc] ; $(date) ; Gcc is uninstalled " >> scripts_log.md
}

see_gcc_installations(){
  dpkg -l gcc*
}

#TO DO : uninstall navigators ? other ?

# arg call
case $1 in
        uninstall_gcc) "$@";exit;;
        see_gcc_installations) "$@";exit;;
esac
