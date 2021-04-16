#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

# See anomalies
see_anomalies(){
  echo "users without home in bash"
  grep -v home /etc/passwd | grep bash
  echo "users without nologin and false"
  grep -v nologin /etc/passwd | grep -v false
}

# Correct anomalies
correct_anomalies(){
  echo "Correct anomalies in /etc/passwd"
  sed -i -E "s#(www-data:/var/www:)/bin/bash#\1usr/sbin/nologin#" /etc/passwd
  echo "[/etc/passwd] ; $(date) ; Correct anomalies " >> 	scripts_log.md
}

# arg call
case $1 in
        see_anomalies) "$@";exit;;
        correct_anomalies) "$@";exit;;
esac
