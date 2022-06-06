#!/bin/env /usr/bin/bash

step "Date and time"

echo ""

question "What is your timezone?"
read timezone

ls -sf "/usr/share/zoneinfo/${timezone}" /etc/localtime

hwclock --systohc

step "Localization"

question "What lang(s) will you use?"
read langs

sed -i "s/# ${locale}.UTF-8 UTF-8/${locale}.UTF-8 UTF-8/g" /etc/locale.gen

echo ""
echo "Generating locales..."

locale-gen

echo "Setting the system locale..."

echo "LANG=${locale}.UTF-8
LANGUAGE=${locale}.UTF-8
LC_ALL=${locale}.UTF-8" >> /etc/locale.conf

localectl set-locale LANG=${locale}.UTF-8

######################################################################################

step "Hostname"

question "Enter the hostname desired:                   user@${bold_white}hostname${reset}"
read hostname

echo "${hostname}" >> /etc/hostname

######################################################################################

step "Root password"

echo "You need to set the root password."
passwd

######################################################################################

step "Bootloader"

amdcpu() {
  cpu = $(grep -m 1 'model name' /proc/cpuinfo | cut -d ":" -f 2)
  if [ cpu == "" ] ; then
    return 1
  else
    return 0
  fi
}
echo 

if [ amdcpu = 1 ] ; then
  echo "${bold_white}[${bold_blue}INFO${bold_white}]${reset} Setup detected you're using an AMD CPU. Before installing the bootloader, the \"amd-ucode\" package needs to be installed."
  pacman -S --noconfirm amd-ucode
fi