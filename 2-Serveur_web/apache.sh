#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

# install apache
install_apache(){
  echo "Install Apache"
  sudo apt-get install apache2 php
  echo "[Apache] ; $(date) ; Apache is installed " >> scripts_log.md
}

# php form
form_apache(){
  echo "Create form apache"
  sudo mv /var/www/html/index.html /var/www/html/index.sos
  sudo cp index.html /var/www/html/index.html
  sudo cp form.php /var/www/html/form.php
  sudo chmod og+r /var/www/html/index.html /var/www/html/form.php
  sudo touch /var/www/html/logApache.txt
  sudo chmod o+w /var/www/html/logApache.txt
  echo "[Apache] ; $(date) ; Form is created " >> scripts_log.md
}

install_nmap(){
  echo "Install nmap"
  sudo apt-get install nmap
  echo "[Nmap] ; $(date) ; nmap is installed " >> scripts_log.md
}

scan(){
  echo "Nmap : scan"
  nmap $1
  #$2 = IP
  echo "[Nmap] ; $(date) ; scan nmap" >> scripts_log.md
}

# arg call
case $1 in
        install_apache) "$@";exit;;
        form_apache) "$@";exit;;
        install_nmap) "$@";exit;;
        scan) "$@";exit;;
esac
