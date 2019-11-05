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
    sudo pacman -Sy --noconfirm expac yajl bash-completion gnupg git
    gpg --list-keys
    echo "keyring /etc/pacman.d/gnupg/pubring.gpg" >> ~/.gnupg/gpg.conf
    pause_function

    print_title "Install yay"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    pause_function

    print_title "Install system apps"
    sudo pacman -S --noconfirm gedit p7zip gparted conky curl jq gnome-font-viewer lynx python-lxml libmtp gvfs-mtp mate-calc gnome-screenshot ntfs-3g gnome-terminal ntp gnome-keyring openvpn networkmanager-openvpn gconf-editor grub-customizer neofetch r8168
    pause_function

    print_title "Install and start Corsair driver"
    yay -S --noconfirm ckb-next-git
    sudo systemctl enable ckb-next-daemon.service
    sudo systemctl start ckb-next-daemon.service
    pause_function
    
    print_title "Install printers"
    sudo pacman -S --noconfirm gsfonts cups ghostscript system-config-printer gutenprint gtk3-print-backends
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
    sudo pacman -S --noconfirm a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lirc libva-vdpau-driver portaudio twolame projectm libgoom2 vcdimager lua-socket
    pause_function

    print_title "Install apps"
    sudo pacman -S --noconfirm firefox chromium wine plank gimp deja-dup vlc steam evince thunderbird keepassxc hexchat qbittorrent eog flashplugin pan vocal inkscape pepper-flash
    # gimp-plugin-lqr gimp-plugin-gmic gimp-plugin-fblur gimp-refocus gimp-nufraw
    pause_function

    print_title "Install and start plex"
    yay -S --noconfirm plex-media-server
    sudo systemctl enable plexmediaserver.service
    sudo systemctl start plexmediaserver.service
    pause_function

    print_title "Install VirtualBox"
    sudo pacman -S --noconfirm virtualbox dkms virtualbox-guest-iso linux-headers virtualbox-host-dkms
    yay -S --noconfirm virtualbox-ext-oracle
    sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
    sudo gpasswd -a tgaddis vboxusers
    pause_function

    # print_title "Install Latex"
    # sudo pacman -S texlive-most texstudio
    # pause_function

    print_title "Install LibreOffice"
    sudo pacman -S --noconfirm libreoffice
    pause_function

    print_title "Install Sublime Text"
    sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
    sudo pacman -Syu --noconfirm sublime-text
    pause_function

    print_title "Install AUR apps"
    yay -S --noconfirm kalu spideroak-one franz-bin gimp-paint-studio gimp-plugin-pandora cinnamon-sound-effects menulibre qdirstat vorta
    pause_function

    print_title "Install programming apps"
    sudo pacman -S --noconfirm gitg nodejs sqlitebrowser npm libvirt android-tools python-beautifulsoup4 python-pip python-feedparser jdk8-openjdk
    yay -S --noconfirm google-cloud-sdk
    pause_function
	
    print_title "Install AUR themes"
    sudo pacman -S --noconfirm arc-icon-theme arc-gtk-theme
    yay -S --noconfirm papirus-icon-theme-git papirus-libreoffice-theme-git paper-icon-theme-git hardcode-fixer-git
    sudo hardcode-fixer
    pause_function

    print_title "Mount hard drives"
    cd /
    sudo mkdir media
    sudo mkdir /media/Storage
    sudo mkdir /media/Backup
    sudo mkdir /media/Games
    sudo mkdir /media/Pictures
    sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
    sudo bash -c 'echo "/dev/sdc1       /media/Backup       ntfs-3g     defaults    0  0" >> /etc/fstab'
    sudo bash -c 'echo "/dev/sdd1       /media/Pictures     ntfs-3g     defaults    0  0" >> /etc/fstab'
    sudo bash -c 'echo "/dev/nvme0n1p1  /media/Games        ntfs-3g     defaults    0  0" >> /etc/fstab'
	
    print_title "HiDPI fix for GDM"
    sudo bash -c 'echo "[org.gnome.desktop.interface]" >> /usr/share/glib-2.0/schemas/93_hidpi.gschema.override'
    sudo bash -c 'echo "scaling-factor=2" >> /usr/share/glib-2.0/schemas/93_hidpi.gschema.override'
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas

    echo "Done!!!"
else
    print_title "net-tools not installed"
    
    #print_title "Install mesa libgl drivers"
    #sudo pacman -S mesa-libgl lib32-mesa-libgl
    #pause_function
    
    print_title "Install nvidia libgl drivers"
    sudo pacman -S --noconfirm nvidia-libgl lib32-nvidia-libgl
    pause_function

    print_title "Install net-tools"
    sudo pacman -Sy --noconfirm net-tools
    ifconfig
    pause_function

    print_title "Install Network Manager"
    sudo pacman -S --noconfirm network-manager-applet
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
