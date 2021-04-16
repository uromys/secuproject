#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

# Add sticky bit
add_sticky_tmp(){
  echo "Configuring sticky bit"

  #add sticky on tmp directory
  sudo chmod o+t /tmp/

  echo "[Sticky bit] ; $(date) ; Sticky bit modified for /tmp/" >> scripts_log.md

}

# See potential sticky bits breach
potential_breach(){
  find / -type d \( -perm /o+w -a \! -perm /+t \) -print 2> /dev/null
}

# arg call
case $1 in
        add_sticky_tmp) "$@";exit;;
        potential_breach) "$@";exit;;
esac
