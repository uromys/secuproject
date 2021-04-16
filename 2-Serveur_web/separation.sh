#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

add_user_publie(){
  echo "Add user publie"
  sudo adduser publie
  echo "[User] ; $(date) ; pilote publie is created " >> scripts_log.md
}

publie_permissions(){
    echo "Add permissions to publie"
    sudo sed -i -E "s|(#?\s*Cmnd alias specification\s*)|\1\nCmnd_Alias APACHE=/usr/sbin/apache2ctl|" /etc/sudoers
    sudo sed -i -E "s|(#?\s*User privilege specification\s*)|\1\npublie  ALL=APACHE|" /etc/sudoers
    echo "[User] ; $(date) ; publie can starts/stop apache " >> scripts_log.md
}

add_user_edite(){
  echo "Add user edite"
  sudo adduser edite
  echo "[User] ; $(date) ;  user edite is created " >> scripts_log.md
}

edite_permissions(){
  echo "Add permissions edite"
  sudo chown www-data.www-data -R /var/www/html
  sudo chmod g+w /var/www/html/index.html /var/www/html/form.php
  sudo sed -i -E "s/(www-data:x:[[:digit:]]+:)/\1edite/" /etc/group
  echo "[User] ; $(date) ; edite can modify web page " >> scripts_log.md
}

chroot(){
  echo "Configure chroot"
  sudo mkdir /var/isoler #cage
  sudo mkdir /var/isoler/bin
  sudo cp /bin/bash /var/isoler/bin #copy bash

  sudo mkdir /var/isoler/lib
  sudo mkdir /var/isoler/lib64
  sudo mkdir /var/isoler/lib/x86_64-linux-gnu

  ldd /bin/bash #see library

  #copy library
  sudo cp /lib/x86_64-linux-gnu/libtinfo.so.6 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/libdl.so.2 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/libc.so.6 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib64/ld-linux-x86-64.so.2 /var/isoler/lib64
  echo "[Chroot] ; $(date) ; chroot is configured" >> scripts_log.md
}

add_ps(){
  echo "Add ps in chroot"
  sudo cp /bin/ps /var/isoler/bin

  ldd /bin/ps #see ps librairies

  sudo cp /lib/x86_64-linux-gnu/libprocps.so.8 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/libsystemd.so.0 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/librt.so.1 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/liblzma.so.5 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/liblz4.so.1 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/libgcrypt.so.20 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/libpthread.so.0 /var/isoler/lib/x86_64-linux-gnu
  sudo cp /lib/x86_64-linux-gnu/libgpg-error.so.0 /var/isoler/lib/x86_64-linux-gnu

  #proc : contient toutes infos sur processus en cours d'éxécution
  mkdir /var/isoler/proc
  mount --bind /proc /var/isoler/proc
  echo "[Chroot] ; $(date) ; ps is added to chroot" >> scripts_log.md
}

see_librairies_installed(){
  sudo tree /var/isoler/lib
  sudo tree /var/isoler/lib64
  sudo tree /var/isoler/bin
}

install_tree(){
  echo "Install tree"
  sudo apt-get install tree
  echo "[Chroot] ; $(date) ; tree is installed" >> scripts_log.md
}

launch_chroot(){
  sudo chroot /var/isoler
}

controle_chroot(){
  echo "Configure chroot to controle"
  sudo touch /usr/local/bin/isoler.sh
  echo "#!/bin/bash
  echo 'Bienvenue dans ce shell isolé par chroot'
  /usr/sbin/chroot /var/isoler/ /bin/bash">>/usr/local/bin/isoler.sh

  sudo chmod ugo+rx /usr/local/bin/isoler.sh
  sudo chmod go+rx /var/isoler #si quelqu'un trouve mieux à changer
  sudo chmod -R go+rx /var/isoler/bin
  sudo chmod -R go+rx /var/isoler/lib
  sudo chmod -R go+rx /var/isoler/lib64
  sudo chmod go+rx /var/isoler/proc
  sudo chmod u+s /usr/sbin/chroot
  useradd controle -d /var/isoler -s /usr/local/bin/isoler.sh

  echo "Veuillez entre le mdp de l'utilisateur controle"
  sudo passwd controle

  echo "[Chroot] ; $(date) ; chroot is configured for controle" >> scripts_log.md
}

del_user(){
  echo "Delete useless users"
  sudo deluser remus
  sudo deluser romulus
  sudo deluser tournesol
  sudo ./../1-Preparation_machine_virtuelle/securityFile.sh del_without_parent
  echo "[Users] ; $(date) ; remus, romulus & tournesol are deleted" >> scripts_log.md
}


# arg call
case $1 in
        add_user_publie) "$@";exit;;
        publie_permissions) "$@";exit;;
        add_user_edite) "$@";exit;;
        edite_permissions) "$@";exit;;
	chroot) "$@";exit;;
	add_ps) "$@";exit;;
	see_librairies_installed) "$@";exit;;
	install_tree) "$@";exit;;
	launch_chroot) "$@";exit;;
	controle_chroot) "$@";exit;;
        del_user) "$@";exit;;
esac
