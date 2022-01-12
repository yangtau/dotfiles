#!/usr/bin/env bash

if [ "$1" = "disable" ]; then
    echo "disable proxy..."
    gsettings set org.gnome.system.proxy mode 'none'
    exit 0
fi

http_addr="127.0.0.1"
http_port="7890"
sock_addr="127.0.0.1"
sock_port="7891"

echo "enable proxy..."
gsettings set org.gnome.system.proxy mode 'manual'
gsettings set org.gnome.system.proxy.http enabled true
gsettings set org.gnome.system.proxy.http host $http_addr
gsettings set org.gnome.system.proxy.http port $http_port

gsettings set org.gnome.system.proxy.ftp host $http_addr
gsettings set org.gnome.system.proxy.ftp port $http_port

gsettings set org.gnome.system.proxy.https host $http_addr
gsettings set org.gnome.system.proxy.https port $http_port

gsettings set org.gnome.system.proxy.socks host $sock_addr
gsettings set org.gnome.system.proxy.socks port $sock_port
