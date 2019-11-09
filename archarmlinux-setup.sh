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