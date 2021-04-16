
edite_index_html(){
  echo "modify index.html"
  vim /var/www/html/index.html
  echo "[Edite] ; $(date) ; index.html has been modified by edite " >> scripts_log.md
}

edite_form_php(){
  echo "modify form.php"
  vim /var/www/html/form.php
  echo "[Edite] ; $(date) ; form.php has been modified by edite " >> scripts_log.md
}

case $1 in
        edite_index_html) "$@";exit;;
        edite_form_php) "$@";exit;;
esac
