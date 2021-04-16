# Projet module risques


## 1. Préparation des machines virtuelles
```cd 1-Preparation_machine_virtuelle```<br />
Les machines virtuelles sont des clones liés du template vm-passoire-TD-tpl construit en TD (cf. TD.R3).<br/>
``` sudo apt-get update```<br/>
``` sudo apt-get upgrade```
* Les vulnérabilités relevées lors du TD.R2 doivent avoir été corrigées, en particulier :
Mot de passe de etu remplacé par un mot de passe construit en appliquant un procédé fiable ;<br/>
```passwd```
* Seules les commandes nécessaires ont le setuid bit ;<br/>
```sudo ./setuid.sh potential_breach```<br />
```sudo ./setuid.sh configure```
* Umask par défaut restrictif ;<br/>
```sudo ./mask.sh view_option```<br />
```sudo ./mask.sh secure```
* Sticky bit correctement configuré sur les répertoires ;<br/>
```sudo  ./sticky.sh potential_breach```<br />
```sudo  ./sticky.sh add_sticky_tmp```
* Anomalies de configuration dans le système de fichiers corrigées.
Les vulnérabilités relevées lors du TD.R3 doivent avoir été corrigées, en particulier :<br/>
* * Suppression des services réseaux non sécurisés ;<br/>
```sudo ./secureNetwork.sh secure```
* * Correction des anomalies dans /etc/passwd ;<br/>
```sudo ./file_etc_passwd.sh see_anomalies```<br />
```sudo ./file_etc_passwd.sh correct_anomalies```
* * Les machines virtuelles sont rendues uniques après clonage, en particulier :
Nom configuré ;
Machine-id réinitialisé ;
Clés ssh re-créées.<br />
```sudo ./configure_unique_machine.sh vm_cli_int```

Le projet peut être préparé en groupe de deux manières :
Reproduction de chacune des étapes par chaque membre une fois qu'elle a été étudiée (préférable pour apprendre, cf. remarque préalable) ;
Partage des VM de l'un des membres du groupe (pour la préparation du projet). Dans cette hypothèse, créer des comptes utilisateurs privilégiés de sorte que chaque membre du groupe dispose de son propre accès aux VM partagées (bonne pratique de non partage de mot-de-passe ; traçabilité).
```cd ..```

## 2. Serveur web
```cd 2-Serveur_web```<br />
La VM vm-web est issue de la partie 1.
Configuration réseau :
vm-web dispose de deux interfaces réseaux, l'une vers le réseau de l'entreprise, l'autre vers Internet, cf. figure.
* Interdire le routage entre les deux interfaces réseaux (configuration de net.ipv4.ip_forward via sysctl).<br/>
```sudo ./routage.sh configure```
* Installer Apache ; il n'est pas demandé de configurer HTTPS à ce stade (cf. module Crypto).<br/>
```sudo ./apache.sh install_apache```
* Développer un formulaire PHP simple qui permette aux clients de saisir des noms et de les stocker dans un fichier du serveur.<br />
```sudo ./apache.sh form_apache```
* S'assurer qu'il n'y ait pas de services inutiles via un scan de port local.<br />
```sudo ./apache.sh install_nmap```<br />
```sudo ./apache.sh scan IP_TO_SCAN```
* Désinstaller les applications non nécessaires pour ce serveur destiné à héberger un serveur web exposé à Internet (navigateurs, compilateurs...).<br />
```sudo ./applications_uninstall.sh see_gcc_installations```<br />
```sudo ./applications_uninstall.sh uninstall_gcc```

### Séparer les tâches
* Créer un compte utilisateur non privilégié publie qui ait le droit d'arrêter et de relancer le serveur web (utiliser sudo).<br />
```sudo ./separation.sh add_user_publie```<br />
```sudo ./separation.sh publie_permissions```
* Créer un compte utilisateur non privilégié edite qui ait le droit de modifier la page web (contenant le formulaire PHP).<br />
```sudo ./separation.sh add_user_edite```<br />
```sudo ./separation.sh edite_permissions```
* Créer un compte utilisateur controle en cage (avec chroot), qui ait uniquement le droit d'afficher les processus en cours d'exécution (GI04 et plus uniquement).<br />
```sudo ./separation.sh chroot```<br />
```sudo ./separation.sh add_ps```<br />
```sudo ./separation.sh controle_chroot```
* S'assurer qu'il n'y ait pas d'utilisateurs inutiles.<br />
```sudo ./separation.sh del_user```<br />
```sudo rm -r /home/tournesol```<br />
```sudo rm -r /home/remus```<br />
```sudo rm -r /home/romulus```
* Séparation des espaces de stockage et montage restrictif (GI04 et plus uniquement)
Réaliser un snapshot de votre machine virtuelle avant cette étape. <br />
clic 2x sur vm-web > Snapshots > Take snapshot<br />
Ajouter un disque dur (taille conseillée de 250 Mo pour limiter l'encombrement).<br />
clic 2x sur vm-web > Hardware > Add > Hard disk <br />
Storage : sr06pxxx-sas<br />
Disk size : 1<br />
Repérer au démarrage le nouveau périphérique avec dmesg.<br />
Redémarrer la vm-web<br />
```sudo ./partition.sh see_disks```<br />
Partitionner ce nouveau disque avec fdisk en créant deux partitions : /var et /home. <br />
```sudo ./partition.sh init_partition```<br />
Dans chacune des partitions, créer un système de fichier ext4 avec fsck.ext4.
Monter temporairement ces partitions et y copier les contenus des répertoires actuels /var et /home.
Modifier /etc/fstab de sorte que ces deux nouvelles partitions soient utilisées à la place des répertoires actuels /var et /home du premier disque. Utiliser les options de montage nosuid, nodev, noexec. <br />
```sudo ./partition.sh partition```<br />
Redémarrer la vm-web

## 3. Clients web

* Ces VM sont issues de l'étape 1.
* * Elles ne disposent que d'une seule interface réseau, cf. figure.
* * vm-cli-int doit pouvoir communiquer avec vm-web et vm-cli-ext.
* * vm-cli-ext doit pouvoir communiquer avec vm-web mais pas avec vm-cli-int.
* Supprimer tous les services non indispensables sur ces clients (Apache...).
* Installer lynx pour disposer d'un navigateur web léger.
* Tester les accès au serveur Apache de vm-web via le formulaire.

### Mise en place du réseau des machines

* Sur vm-cli-int :<br/>
Proxmox : Double clic sur la vm > Hardware > Double clic sur Network device > Bridge : vmbr0<br/>
Redémarrer la vm<br/>
```sudo netplan generate```<br />
```sudo apt-get install lynx```

* Sur vm-cli-ext :<br/>
```sudo apt-get install lynx```

* Sur vm-web
Proxmox : Double clic sur la vm > Hardware > Add > Network device ><br/>
    Bridge : vmbr0<br/>
    Model : VirtIO (paravirtualized)<br/>
    Firewall : ?<br/>
```sudo nano /etc/netplan/00-installer-config.yaml```<br />
```network:
  ethernets:
    ens18:
      dhcp4: true
      dhcp-identifier: mac
      dhcp4-overrides:
        route-metric: 100
    ens19:
      dhcp4: true
      dhcp-identifier: mac
      dhcp4-overrides:
        route-metric: 300
  version: 2
```

### Tests de connexion 
```lynx/ssh/ping [IP]```

* Depuis vm-cli-int : <br/>
```ssh / ping possible vers ext```<br />
```ssh / ping / lynx possible vers web```

* Depuis vm-cli-ext :<br/>
```ssh / ping impossible vers int```<br />
```ssh / ping / lynx possible vers web```

* Depuis vm-web :<br/>
Pour voir les noms entrés via lynx :
```sudo cat /var/www/html/logApache.txt```

## 4. Surveillance du serveur web

* Surveillance des log Apache
* * Se connecter sur vm-web depuis vm-cli-int et visualiser les logs du serveur Apache (cf. commande tail -f et répertoire /var/log/apache2 ).
* * Depuis vm-cli-ext, se connecter au serveur web de vm-web
* * Expliquer les logs Apache obtenus.<br/>
Depuis vm-web :<br/>
```tail -f /var/log/apache2```<br/>
En même temps, se connecter au serveur apache de vm-web depuis vm-int et vm-ext.

* Capture de trafic (GI04 uniquement)
* * Capturer le trafic sur l'interface réseau de vm-web qui est connectée à vmbr2 avec tcpdump.
* * Renvoyer ce trafic sur une machine graphique disposant de wireshark (cf. TD.R3).
* * Expliquer les échanges réseau.

Depuis vm-web :<br/>
```sudo tcpdump -s0 -n -U -w - -i ens18 'not port 3000' | nc -k -l 3000```

Depuis le pc :<br/>
```nc [IP] 3000 | wireshark -k -i -```

En même temps, se connecter à vm-web depuis vm-int ou vm-ext par lynx/ping/ssh. Observer ce qu’il se passe sur wireshark.

