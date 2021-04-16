#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

see_disks(){
        dmesg | grep disk
}

disks_state(){
        sudo lsblk -f
}

init_partition(){
        echo "Pour mettre en place la partition, suivre les commandes suivantes"
        echo "sudo fdisk /dev/sdb"
        echo ": n"
        echo ": "
        echo ": "
        echo ": "
        echo ": +900M"
        echo ": n"
        echo ": "
        echo ": "
        echo ": "
        echo ": "
        echo ": w"
}

partition(){
        sudo mkfs.ext4 /dev/sdb1
        sudo mkfs.ext4 /dev/sdb2
        sudo e2label /dev/sdb1 var
        sudo e2label /dev/sdb2 home
        sudo fsck.ext4 /dev/sdb1
        sudo fsck.ext4 /dev/sdb2
        sudo mkdir /newvar
        sudo mkdir /newhome
        sudo mount /dev/sdb1 /newvar
        sudo mount /dev/sdb2 /newhome
        sudo cp -a /home/. /newhome/
        sudo cp -a /var/. /newvar/
        sudo lsblk -f
        echo "Modifier le fichier /etc/fstab et ajouter les lignes suivantes :"
        echo "UUID=[UUID de /var] /var ext4 nosuid,nodev 0 2"
        echo "UUID=[UUID de home] /home ext4 nosuid,nodev,noexec 0 2"
        echo "/proc /var/isoler/proc none defaults,bind 0 0"
        #$var=`sudo lsblk -f | grep sdb1 | tr -s ' ' | cut -d " " -f 4`
        #$home=`sudo lsblk -f | grep sdb2 | tr -s ' ' | cut -d " " -f 4`
        #sudo echo"UUID=$var /var ext4 nosuid,nodev,noexec 0 2" > /etc/fstab
        #sudo echo"UUID=$home /home ext4 nosuid,nodev 0 2" > /etc/fstab
}

case $1 in
        see_disks) "$@";exit;;
        disks_state) "$@";exit;;
        init_partition) "$@";exit;;
        partition) "$@";exit;;
esac


