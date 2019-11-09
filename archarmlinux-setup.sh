#!/bin/bash

echo -n "Rename default alarm user? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  echo -n "Enter new username: "
  read new_username
  usermod -l $new_username -m -d /home/$new_username alarm
  groupmod -n $new_username alarm
  echo "New username set."
fi

echo -n "Do you want to set hostname? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  echo -n "Enter new hostname: "
  read new_hostname
  echo $new_hostname > /etc/hostname
  echo "New hostname set."
fi

echo -n "Do you want to set default locale to en_US.UTF-8? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
  locale-gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
fi

echo -n "Do you want to update system? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  pacman-key --init
  pacman-key --populate archlinuxarm
  pacman -Syyuw
  pacman -Syu
fi

echo -n "Do you want to enable sudo for wheel group? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  pacman -S sudo
  sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
fi

echo -n "Do you want to set timezone? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  echo -n "Enter timezone: "
  read timezone
  timedatectl set-timezone $timezone
  timedatectl status
fi

echo -n "Do you want to set ethernet network? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  echo "[Match]" > /etc/systemd/network/eth0.network
  echo "Name=eth0" >> /etc/systemd/network/eth0.network
  echo "" >> /etc/systemd/network/eth0.network
  echo "[Network]" >> /etc/systemd/network/eth0.network
  echo "DNSSEC=no" >> /etc/systemd/network/eth0.network
  echo -n "Do you want to enable DHCP? [Y,n]? "
  read input
  if [[ $input == "Y" || $input == "y" ]]; then
    echo "DHCP=yes" >> /etc/systemd/network/eth0.network
    systemctl enable dhcpcd
  else
    echo -n "Enter IP address (192.168.1.2/24): "
    read ipaddress
    echo -n "Enter gateway (192.168.1.1): "
    read gateway
    echo -n "Enter DNS (192.168.1.1): "
    read dns
    echo "Address=$ipaddress" >> /etc/systemd/network/eth0.network
    echo "Gateway=$gateway" >> /etc/systemd/network/eth0.network
    echo "DNS=$dns" >> /etc/systemd/network/eth0.network
    systemctl disable dhcpcd
  fi
  echo -n "WARNING: Do you want to restart network? [Y,n]? "
  read input
  if [[ $input == "Y" || $input == "y" ]]; then
    systemctl restart systemd-networkd
  fi
fi

echo -n "Do you want to install desktop environment (LXDE)? [Y,n]? "
read input
if [[ $input == "Y" || $input == "y" ]]; then
  pacman -S xorg xorg-xinit xorg-server xorg-server-utils xterm lxde lxde-common ttf-dejavu xf86-video-fbdev
fi
