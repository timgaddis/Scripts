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

print_title "Test internet connection"
# Test internet connection
ping -c 3 www.google.com
pause_function

print_title "Install arch-install-scripts"
pacman -Syy
wget https://git.archlinux.org/arch-install-scripts.git/snapshot/arch-install-scripts-22.tar.gz
tar zxvf arch-install-scripts-22.tar.gz
cd arch-install-scripts-22
pause_function

print_title "Load root partition"
lsblk
read -p "Enter the root partition: " ROOT

print_title "Mount the root partition"
# Mount the root partition
mount /dev/$ROOT /mnt
pause_function

print_title "Install bootloader"
# Install the bootloader
arch_chroot "mount /dev/sda2 /boot/EFI"
arch_chroot "grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=Arch --recheck"

print_title "Generate grub.cfg"
# Generate grub.cfg
arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg"
pause_function

print_title "Exit"
# Exit and unmount system
arch_chroot "exit"
umount -R /mnt
#reboot
