#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

# unshadow script, combining passwd and shadow file so John can use them
run_unshadow(){
	echo "Executing run_unshadow"
	unshadow /etc/passwd /etc/shadow > notSafetokeep.md
	echo "[UNSHADOW] ; $(date) ; file notSafetokeep.md generated" >> scripts_log.md
}

# John script, brute-force
run_john() {
	echo "Executing run_john"
	start=$(date +%s)
	john notSafetokeep.md
	end=$(date +%s)
	echo "[BRUTE-FORCE] ; $(date) ; ran for $((end - start))s" >> scripts_log.md
}

clean(){
        rm notSafetokeep.md
    exit 0

}

run_unshadow
run_john
trap clean EXIT  HUP INT QUIT PIPE TERM 
