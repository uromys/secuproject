#!/bin/bash

# doesn't work right now might delete later
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi


add_alias(){
 if grep -q "alias deluser='alias_del_user"; 2>/dev/null "~/.bash_aliases"; then
        echo "[INFO]  add alias"
        echo "alias_del_user ()
{
  sudo deluser -P --"$1" && grep -q sudo find / -type f \( -nouser -o -nogroup \) -exec rm  {} \; 2>/dev/null
}">>~/.bash_aliases
        echo "alias deluser='alias_del_user;" >> ~/.bash_aliases
else
        echo "alias already set up"
    fi
}




# arg call
case $1 in
        add_alias) "$@";exit;;
esac

add_alias
