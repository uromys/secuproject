#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

# changing machine name, making ip-address unique and configuring ssh key
vm_cli_int(){
	echo "Configuring vm_cli_int"
	# changing name
	hostnamectl set-hostname vm-cli-int
	sed -i "s/passoire/vm-cli-int/" /etc/hosts

	# making ip-address unique
	rm /etc/machine-id
	systemd-machine-id-setup

	# configuring new ssh key
	rm /etc/ssh/ssh_host_*
	dpkg-reconfigure openssh-server

	echo "[Uniqueness] ; $(date) ; machine reconfigured to ensure Uniqueness" >> scripts_log.md
	reboot
}

vm_cli_ext(){
	echo "Configuring vm_cli_ext"
	# changing name
	hostnamectl set-hostname vm-cli-ext
	sed -i "s/passoire/vm-cli-ext/" /etc/hosts

	# making ip-address unique
	rm /etc/machine-id
	systemd-machine-id-setup

	# configuring new ssh key
	rm /etc/ssh/ssh_host_*
	dpkg-reconfigure openssh-server

	echo "[Uniqueness] ; $(date) ; machine reconfigured to ensure Uniqueness" >> scripts_log.md
	reboot
}

vm_web(){
	echo "Configuring vm_web"
	# changing name
	hostnamectl set-hostname vm-web
	sed -i "s/passoire/vm-web/" /etc/hosts

	# making ip-address unique
	rm /etc/machine-id
	systemd-machine-id-setup

	# configuring new ssh key
	rm /etc/ssh/ssh_host_*
	dpkg-reconfigure openssh-server

	echo "[Uniqueness] ; $(date) ; machine reconfigured to ensure Uniqueness" >> scripts_log.md
	reboot
}

# arg call
case $1 in 
        vm_cli_int) "$@";exit;;
        vm_cli_ext) "$@";exit;;
        vm_web) "$@";exit;;
esac
