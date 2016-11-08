#!/bin/bash

Bold=$(tput bold)
Reset=$(tput sgr0)

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

is_package_installed() {
    #check if a package is already installed
    for PKG in $1; do
      pacman -Q $PKG &> /dev/null && return 0;
    done
    return 1
}

if is_package_installed "net-tools"; then
    print_title "net-tools installed"

    print_title "Install dependencies"
    sudo pacman -Sy expac yajl bash-completion gnupg
    gpg --list-keys
    echo "keyring /etc/pacman.d/gnupg/pubring.gpg" >> ~/.gnupg/gpg.conf
    pause_function

    print_title "Download and install cower"
    mkdir ~/.AUR
    cd .AUR
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
    tar zxvf cower.tar.gz
    cd cower
    makepkg -si
    cd ..
    pause_function

    print_title "Download and install pacaur"
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
    tar zxvf pacaur.tar.gz
    cd pacaur
    makepkg -si
    pause_function

    print_title "Install system apps"
    sudo pacman -S gedit p7zip encfs gparted conky curl jq gksu gnome-font-viewer lynx gtk-engine-murrine libmtp gvfs-mtp galculator gnome-screenshot ntfs-3g gnome-terminal ntp gnome-keyring openvpn networkmanager-openvpn sqlitebrowser gconf-editor
    # gnome-tweak-tool

    print_title "Install and update ClamAV"
    sudo pacman -S clamav
    sudo freshclam
    sudo systemctl enable clamd.service
    sudo systemctl start clamd.service
    sudo systemctl enable freshclamd.service
    sudo systemctl start freshclamd.service
    wget -O- http://www.eicar.org/download/eicar.com.txt | clamscan -
    # stdin: Eicar-Test-Signature FOUND
    pause_function

    print_title "Install and start mouse driver"
    gpg --recv-keys 5FB027474203454C
    sudo pacaur -S razercfg python-pyside
    sudo systemctl enable razerd.service
    pause_function
    
    print_title "Install printers"
    sudo pacman -S gsfonts cups ghostscript system-config-printer gutenprint
    sudo gpasswd -a tgaddis sys
    sudo systemctl enable org.cups.cupsd.service
    sudo systemctl start org.cups.cupsd.service
    pause_function
    
    # print_title "Install BOINC"
    # sudo pacman -S boinc
    # sudo gpasswd -a tgaddis boinc
    # sudo systemctl enable boinc.service
    # sudo systemctl start boinc.service
    # sudo chmod 640 /var/lib/boinc/gui_rpc_auth.cfg
    # pause_function

    print_title "Configure gnome terminal"
    sudo bash -c 'echo "LANG=\"en_US.UTF-8\"" >> /etc/locale.conf'
    print_title "Enable ntp"
    sudo systemctl enable ntpd.service
    pause_function

    print_title "Install codecs"
    sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
    pause_function

    print_title "Install apps"
    sudo pacman -S firefox wine plank gimp deja-dup vlc steam evince thunderbird keepass hexchat gitg qbittorrent eog nodejs flashplugin banshee
    pause_function

    print_title "Install VirtualBox"
    sudo pacman -S virtualbox dkms virtualbox-guest-iso linux-headers qt4
    sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
    sudo gpasswd -a tgaddis vboxusers
    pause_function

    # print_title "Install Latex"
    # sudo pacman -S texlive-most texstudio
    # pause_function

    print_title "Install LibreOffice"
    sudo pacman -S libreoffice
    pause_function

    print_title "Install AUR apps"
    pacaur -S pan rar dropbox nemo-dropbox gpodder3 google-chrome kalu jdk polly pypar2 sublime-text-dev grub-customizer menulibre plex-media-server gnome-encfs-manager
    # corebird compiz enpass-bin ntfs-config
    
    print_title "Enable and start plex"
    sudo systemctl enable plexmediaserver.service
    sudo systemctl start plexmediaserver.service
    pause_function

    print_title "Install and setup VPN"
    pacaur -S private-internet-access-vpn
    sudo bash -c 'echo "p9224505">>/etc/private-internet-access/login.conf'
    sudo bash -c 'echo "PASSWORD">>/etc/private-internet-access/login.conf'
    sudo chmod 0600 /etc/private-internet-access/login.conf
    sudo chown root:root /etc/private-internet-access/login.conf
    sudo pia -a
    pause_function

    print_title "Install AUR themes"
    pacaur -S gtk-theme-arc-git moka-icon-theme-git ceti-2-themes-git vertex-themes-git paper-gtk-theme-git paper-icon-theme-git
    # pacaur -S plank-theme-numix numix-themes-git numix-themes-archblue-git numix-circle-icon-theme-git
    # plank-theme-moka-git moka-cinnamon-theme-git orchis-gtk-theme-git
    pause_function

    print_title "Automount Storage and Backup"
    cd /
    sudo mkdir media
    sudo mkdir /media/Storage
    sudo mkdir /media/Backup
    sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
    sudo bash -c 'echo "/dev/sdc1       /media/Backup      ntfs-3g     defaults    0  0" >> /etc/fstab'
    # pause_function

else
    print_title "net-tools not installed"
    
    #print_title "Install mesa libgl drivers"
    #sudo pacman -S mesa-libgl lib32-mesa-libgl
    #pause_function
    
    print_title "Install nvidia libgl drivers"
    sudo pacman -S nvidia-libgl lib32-nvidia-libgl
    pause_function

    print_title "Install net-tools"
    sudo pacman -Sy net-tools
    ifconfig
    pause_function

    print_title "Install Network Manager"
    sudo pacman -S network-manager-applet
    pause_function

    print_title "Disable dhcpcd service"
    ifconfig
    read -p "Enter interface name: " IFACE
    sudo systemctl stop dhcpcd@$IFACE.service
    sudo systemctl disable dhcpcd@$IFACE.service
    sudo systemctl stop dhcpcd.service
    sudo systemctl disable dhcpcd.service
    pause_function

    print_title "Start Network Manager"
    sudo systemctl start NetworkManager
    sudo systemctl enable NetworkManager
    pause_function

    print_title "Test network"
    ifconfig
    ping -c 2 www.google.com
fi
