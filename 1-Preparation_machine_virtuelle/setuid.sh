#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

# Configure setuid bit following ANSSI recommendation or specific usage that can be a breach
configure(){
  echo "Configuring setuid bit"

  # update.sh : useless
  sudo chmod u-s /home/remus/update.sh

  # chage : ANSSI recomendation
  sudo chmod g-s /usr/bin/chage

  # chsh : ANSSI recommendation
  sudo chmod u-s /usr/bin/chsh

  # at : not used
  sudo chmod ug-s /usr/bin/at

  # fusermount for partition FULL : not used
  sudo chmod u-s /usr/bin/fusermount

  # Wall : ANSSI recommendation
  sudo chmod g-s /usr/bin/wall

  # chfn : ANSSI recomendation
  sudo chmod u-s /usr/bin/chfn

  # expriy : not used
  sudo chmod g-s /usr/bin/expiry

  # crontab : not used
  sudo chmod g-s /usr/bin/crontab

  # dmcrypt-get-device
  sudo chmod u-s /usr/lib/eject/dmcrypt-get-device

  # ssh-keysign : ANSSI recommendation
  sudo chmod u-s /usr/lib/openssh/ssh-keysign

  # ssh-agent
  sudo chmod g-s /usr/bin/ssh-agent

  # unix_chkpwd : not used
  sudo chmod g-s /usr/sbin/unix_chkpwd

  # readfile -s : not used
  sudo chmod u-s /usr/local/bin/readfile-s

  echo "[Setuid bit] ; $(date) ; Setuid bit modified for selected potential breach" >> scripts_log.md

}

# See potential setuid bits breach
potential_breach(){
	find / -type f \( -perm -u+s -o -perm -g+s \) -exec \ls -l {} \; 2> /dev/null
}

# arg call
case $1 in
        configure) "$@";exit;;
        potential_breach) "$@";exit;;
esac
