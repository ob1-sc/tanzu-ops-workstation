#!/usr/bin/env bash

# set the correct DNS server address
sudo sed -i '/\[Resolve\]/a DNS=$1' /etc/systemd/resolved.conf

# ensure symlinks are correctly setup
sudo rm -f /etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

# restart services
sudo service systemd-resolved restart
