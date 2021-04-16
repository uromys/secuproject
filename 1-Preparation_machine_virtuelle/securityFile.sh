#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

 # find directory accessible by all in writing : owner no root
 directory_security(){
   find  / -type  d -perm  /o+w -a \! -uid  0 -print  2>  /dev/null
 }

 update_directory_security(){
   echo "Security directory : remove write permissions for other"
   sudo find  / -type  d -perm  /o+w -a \! -uid  0 -exec chmod o-w {} \;  2>  /dev/null
   echo "[SecurityDirectory] ; $(date) ; Directories write permissions have been removed for other " >> 	scripts_log.md
 }

# TODO should be a -a logic gate or a -o ?
# To delete files withoud parent
del_without_parent(){
	echo "Deleting files without parent"
	sudo find / -type f \( -nouser -o -nogroup \) -exec rm  {} \; 2>/dev/null
	echo "[SecurityFile] ; $(date) ; Files without parent deleted" >> 	scripts_log.md
}

# Show files without parent
files_without_parent(){
	find / -type f \( -nouser -o -nogroup \) -print 2> /dev/null
}

# find files executable by user and accessible in writing  by other
write_permission_files(){
 find  / -type  f -perm  /u+x -perm  /o+w -print  2>  /dev/null
}

del_write_permission_files(){
 echo "Remove write permissions on file for other"
 sudo find  / -type  f -perm  /u+x -perm  /o+w -exec chmod o-w {} \; 2>  /dev/null
 echo "[SecurityFile] ; $(date) ; File write permissions have been removed for other " >> 	scripts_log.md
}

# arg call
case $1 in
        directory_security) "$@";exit;;
        update_directory_security) "$@";exit;;
        del_without_parent) "$@";exit;;
        files_without_parent) "$@";exit;;
        write_permission_files) "$@";exit;;
        del_write_permission_files) "$@";exit;;
esac
