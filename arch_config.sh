#!/bin/bash

Bold=$(tput bold)
Reset=$(tput sgr0)
MOUNTPOINT="/mnt"

print_title() {
    #clear
    echo ""
    echo "******************************"
    echo -e "# ${Bold}$1${Reset}"
    echo "******************************"
}

pause_function() {
    read -e -sn 1 -p "Press a key to continue..."
}

arch_chroot() {
    arch-chroot $MOUNTPOINT /bin/bash -c "${1}"
}

print_title "System update"
pacman -Syu
pause_function

print_title "Install audio"
pacman -S alsa-utils
amixer sset Master unmute
pause_function

print_title "Add user"
useradd -m -G wheel -s /bin/bash tgaddis
passwd tgaddis
pause_function

print_title "Config sudo"
# Uncomment to allow members of group wheel to execute any command
sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
pause_function

print_title "Enable Multilib"
# uncomment lines
sed -i '/\[multilib\]/s/^#//' /etc/pacman.conf
#sed -i '/Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf
#sed -i '93s/#\[multilib\]/\[multilib\]/' /etc/pacman.conf
sed -i '93,96s/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf
#nano /etc/pacman.conf
pause_function

print_title "System update"
pacman -Syu
pause_function

print_title "Install Xorg"
pacman -S bash-completion mesa xorg-twm xterm xorg xorg-apps xorg-xinit
pause_function

#print_title "Install Nouveau drivers"
#pacman -S xf86-video-nouveau
#pause_function

print_title "Install Nvidia drivers"
pacman -S nvidia nvidia-utils nvidia-settings
pause_function

# print_title "Virtualbox drivers"
# pacman -S virtualbox-guest-utils mesa-libgl
# pause_function

print_title "Test Xorg server"
startx
pause_function

print_title "Install Cinnamon"
pacman -S cinnamon nemo-fileroller
pause_function

#print_title "Install and enable LightDM"
#pacman -S lightdm lightdm-gtk-greeter
#systemctl enable lightdm.service
#pause_function

print_title "Install and start GDM"
pacman -S gdm
systemctl enable gdm
systemctl start gdm