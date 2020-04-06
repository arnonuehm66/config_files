#!/bin/bash

echo -e "\e[1;4;246mAuto-Setup-Manjaro\e[0m
Welcome to auto-setup for your Manjaro System.

This script will download and install important packages for forensic work.
This may take some time.
"

#Prompt user if they want to continue
read -p "Would you like to continue? (y/N) " answer
if [ "$answer" == "n" ] || [ "$answer" == "N" ] || [ "$answer" == "" ]
then
	echo "Setup aborted"
	exit
fi

# Switch of manual interaction.
NOC='--noconfirm'


###################
# Helper function #
###################
cmd() {
  echo "[$*]"
  #$*
  echo
}


#################
# Update System #
#################
echo -e "\e[1;4;93mStep 1. Updating system\e[0m"
cmd sudo pacman-mirrors --geoip
cmd sudo pacman -Syyuu $NOC


#############################################
# Install essential AUR and pacman packages #
#############################################
echo -e "\e[1;4;93mStep 2. Install pre-built dependencies from pacman\e[0m"

echo "Essentials:"
cmd sudo pacman -S trizen $NOC
cmd trizen -S vim mc elinks lsof htop tree baobab numlockx deja-dup dkms $NOC

echo "Essentials:"
cmd trizen -S exfat-dkms-git exfat-utils-nofuse ttf-ms-fonts $NOC

echo "Network:"
cmd trizen -S netdiscover wireshark vivaldi $NOC

echo "Programming:"
cmd trizen -S kate qtcreator cmake git ninja $NOC

echo "Security:"
cmd trizen -S veracrypt $NOC

echo "Databases:"
cmd trizen -S sqlite3 sqlitebrowser mariadb phpmyadmin $NOC

echo "Forenics:"
cmd trizen -S vbindiff binwalk kdiff3 bless meld gpsbabel $NOC

echo "Tex(t):"
cmd trizen -S kile latex $NOC

echo "Misc.:"
cmd trizen -S vlc virtualbox virtualbox-host-dkms playonlinux wine $NOC

echo "Misc.:"
cmd trizen -S papirus-maia-icon-theme vertex-maia-themes ertex-maia-icon-theme $NOC


###########################################
# What to do next to improve the system   #
###########################################

echo
echo "Edit: sudo vim /etc/makepkg.conf"
echo "Uncomment 'MAKEFLAGS=\"-j9\"'"
echo "Change to 'COMPRESSXZ=(xz -c -z - --threads=0)'"
echo
echo "Edit: sudo vim /etc/pacman.conf"
echo "Uncomment 'Color'"
echo
echo "Install: sudo pacman -S gpm"
echo "Run with:"
echo "1. sudo systemctl enable gpm"
echo "2. sudo systemctl restart gpm"
echo
echo "Install: Einstellungen/Mnjaro Einstellungen/Sprachpakete/Verfügbare Sprachpakete"
echo



###########################################
# just add more packages if needed        #
###########################################

#Prompt user if they want to reboot
read -p "Reboot to finish installation? (y/N) " answer
if [ "$answer" == "n" ] || [ "$answer" == "N" ] || [ "$answer" == "" ]
then
	echo ""Done! Please reboot your PC now""
	exit
fi

sudo reboot
