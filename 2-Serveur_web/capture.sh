#!/bin/bash
#not tested
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Run this script using sudo."
    exit 2
fi

sudo groupadd pcap
sudo usermod -a -G pcap etu
sudo chgrp pcap /usr/sbin/tcpdump
sudo chmod 750 /usr/sbin/tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump
ssh etu@172.23.4.145   tcpdump -i any -U -s0 -w - 'not port 22' | wireshark -k -i -
