
start_apache(){
  echo "Start apache"
  sudo apache2ctl start
  echo "[Apache] ; $(date) ; Apache is started " >> scripts_log.md
}

stop_apache(){
  echo "Stop apache"
  sudo apache2ctl stop
  echo "[Apache] ; $(date) ; Apache is stopped " >> scripts_log.md
}

restart_apache(){
  echo "Restart apache"
  sudo apache2ctl stop
  echo "[Apache] ; $(date) ; Restart apache " >> scripts_log.md
}


# arg call
case $1 in
        start_apache) "$@";exit;;
        stop_apache) "$@";exit;;
        restart_apache) "$@";exit;;
esac
