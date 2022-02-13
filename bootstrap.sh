#!/bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
CHECKMARK="[${GREEN}✓${NC}]"
XMARK="[${RED}✗${NC}]"
echo "Welcome to the Cutefish Bootstrapper script."
echo "This script will help you get the latest version of Cutefish installed on your Arch system."
echo ""
echo "Do be advised that you need to have a blank Arch install for this to work"
echo "(a.k.a: You have no desktop environment and are just at a terminal)"
echo ""
echo "This process may take a few minutes to complete since everything will be compiled from scratch."
echo ""
confirm=""

while [ -n $confirm ]; 
do
	read -p "Would you like to continue? [y/n] " confirm
	case $confirm in
		"y")
			break
		 	;;
		 "n")
		 	echo "Now exiting..."
		 	exit 1
		 	;;
		 *)
		 	echo "Please choose either 'y' for yes or 'n' for no."
		 	echo ''
	esac
done

echo ''
echo "Alright, lets start with some prequisite checks first..."
sleep 1

# Let's check if the system they're even using runs Arch
arch_check=$(grep "Arch" /etc/os-release)

if [ -z $arch_check ]; then
	echo -e "${XMARK} Arch not detected, now exiting..."
	exit 1 
fi
echo -e "${CHECKMARK} Arch is detected"

# Next lets check if a desktop exists
if test -f "/etc/systemd/system/display-manager.service"; then
	echo -e "${XMARK} A desktop environment was detected, now exiting..."
	exit 1 
fi

# Now lets check to see if yay is installed
sleep 1
yay_check=$(pacman -Qq | grep "yay")
if [ -z $yay_check ]; then
	echo -e "${XMARK} Yay is not installed"
	echo ''
	echo "Yay will now be installed to help assist in installing Cutefish"
	echo ''
	sleep 1
	
	# Lets check if git is installed
	git_check=$(pacman -Qq | grep "^git")
	if [ -z $git_check ]; then
		echo -e "${XMARK} Git is not installed"
		echo ''
		sleep 1
		echo "Now installing git package. Please provide your password if asked."
		sleep 1
		sudo pacman -Syu --noconfirm git
	fi
	echo -e "${CHECKMARK} Git package is installed"
	sleep 1
	echo "Now installing yay package..."
	sleep 1
	git clone https://aur.archlinux.org/yay.git
	cd yay 
	makepkg -si --noconfirm
	cd ..
else
	echo -e "${CHECKMARK} Yay is installed"
	sleep 1
fi
echo "All prerequisites have been fulfilled. Now let's get started.."
echo ''
echo "The desktop environment will now be installed."
echo "This process may take some time due to everything being built from source"
sleep 2

# To make this process easier, the AUR has a cutefish-git metapackage
yay -S --noconfirm cutefish-git
	
echo -e "${CHECKMARK} Cutefish is now installed."
sleep 2
echo "Now let's get the display manager configured"
sleep 1
sudo pacman -Syu --noconfirm sddm
echo -e "${CHECKMARK} SDDM is now installed."
sleep 1
echo "Enabling SDDM at boot..."
sudo systemctl enable sddm
echo -e "${CHECKMARK} SDDM is now enabled at boot."
sleep 1
echo "Now let's install the appropriate theme for SDDM..."
sleep 1
git clone https://github.com/cutefishos/sddm-theme
cd sddm-theme
mkdir build
cd build
cmake ..
make 
sudo make install
echo -e "${CHECKMARK} SDDM theme is now installed."
sleep 1
echo -e "${CHECKMARK} Cutefish desktop install is now complete!"
sleep 1
reboot_confirm=""

while [ -n $reboot_confirm ]; 
do
	read -p "Would you like to reboot? [y/n] " confirm
	case $confirm in
		"y")
			systemctl reboot
			break
		 	;;
		 "n")
		 	echo -e "${CHECKMARK} Script has successfully executed with no errors."
		 	echo "Once you are ready, please reboot so you can use the Cutefish desktop environment"
		 	exit 1
		 	;;
		 *)
		 	echo "Please choose either 'y' for yes or 'n' for no."
		 	echo ''
	esac
done



	


	
