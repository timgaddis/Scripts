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

file="/etc/first_run"
if [ -f "$file" ]
then
    print_title "Second Run!!"

    numberofcores=$(grep -c ^processor /proc/cpuinfo)
    if [ $numberofcores -gt 1 ]
    then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
    else
        echo "No change."
    fi

    print_title "Install dependencies"
    sudo pacman -Sy --noconfirm --needed expac yajl bash-completion gnupg git
    gpg --list-keys
    echo "keyring /etc/pacman.d/gnupg/pubring.gpg" >> ~/.gnupg/gpg.conf
    pause_function

    print_title "Install yay"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
    pause_function

    print_title "Install system apps"
    sudo pacman -S --noconfirm --needed gedit p7zip gparted conky curl jq gnome-font-viewer lynx python-lxml libmtp gvfs-mtp mate-calc gnome-screenshot ntfs-3g gnome-terminal gnome-keyring openvpn networkmanager-openvpn grub-customizer neofetch cmake evince unace arj
    pause_function
    
    print_title "Install printers"
    sudo pacman -S --noconfirm --needed gsfonts cups ghostscript system-config-printer gutenprint gtk3-print-backends
    sudo gpasswd -a tgaddis sys
    sudo systemctl enable org.cups.cupsd.service
    sudo systemctl start org.cups.cupsd.service
    pause_function
    
    print_title "Configure gnome terminal"
    sudo bash -c 'echo "LANG=\"en_US.UTF-8\"" >> /etc/locale.conf'
    pause_function

    print_title "Install and enable ntp"
    sudo pacman -S --noconfirm --needed ntp
    sudo systemctl enable ntpd.service
    pause_function

    print_title "Install codecs"
    sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lirc libva-vdpau-driver portaudio twolame projectm libgoom2 vcdimager ttf-freefont lua-socket alsa-firmware playerctl
    pause_function

	print_title "Install fonts"
	sudo pacman -S --noconfirm --needed --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family tamsyn-font
	pause_function

    print_title "Install apps"
    sudo pacman -S --noconfirm --needed firefox chromium wine plank gimp deja-dup vlc steam thunderbird keepassxc hexchat qbittorrent eog eog-plugins flashplugin pan vocal inkscape pepper-flash borg
    # gimp-plugin-lqr gimp-plugin-gmic gimp-plugin-fblur gimp-refocus gimp-nufraw
    pause_function

    print_title "Install AUR apps"
    yay -S --noconfirm --needed franz-bin gimp-paint-studio gimp-plugin-pandora cinnamon-sound-effects menulibre qdirstat vorta megasync nemo-megasync pamac-aur
    pause_function

    print_title "Install programming apps"
    sudo pacman -S --noconfirm --needed gitg nodejs sqlitebrowser npm libvirt android-tools python-beautifulsoup4 python-pip python-feedparser jdk8-openjdk kotlin
    yay -S --noconfirm --needed google-cloud-sdk
    pause_function
    
    print_title "Install and start plex"
    yay -S --noconfirm --needed plex-media-server
    sudo systemctl enable plexmediaserver.service
    sudo systemctl start plexmediaserver.service
    pause_function
    
    print_title "Install VirtualBox"
    sudo pacman -S --noconfirm --needed linux-headers
    sudo pacman -S --noconfirm --needed virtualbox dkms virtualbox-guest-iso virtualbox-host-dkms
    yay -S --noconfirm --needed virtualbox-ext-oracle
    sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
    sudo gpasswd -a tgaddis vboxusers
    pause_function

    # print_title "Install Latex"
    # sudo pacman -S texlive-most texstudio
    # pause_function

    print_title "Install LibreOffice"
    sudo pacman -S --noconfirm --needed libreoffice
    pause_function

    print_title "Install Sublime Text"
    sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
    sudo pacman -Syu --noconfirm --needed sublime-text
    pause_function
	
    print_title "Install AUR themes"
    sudo pacman -S --noconfirm --needed arc-icon-theme arc-gtk-theme gtk-engine-murrine elementary-icon-theme gtk-engine-murrine
    yay -S --noconfirm --needed papirus-libreoffice-theme hardcode-fixer-git paper-icon-theme-git papirus-icon-theme-git plank-theme-arc
    sudo hardcode-fixer
    pause_function

    print_title "Mount hard drives"
    cd /
    sudo mkdir media
    sudo mkdir /media/Storage
    sudo mkdir /media/Backup
    sudo mkdir /media/Games
    sudo mkdir /media/Pictures
    sudo bash -c 'echo "/dev/sdb1       /media/Backup       ntfs-3g     defaults    0  0" >> /etc/fstab'
    sudo bash -c 'echo "/dev/sdc1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
    sudo bash -c 'echo "/dev/nvme0n1p1  /media/Games        ntfs-3g     defaults    0  0" >> /etc/fstab'
	
    print_title "HiDPI fix for GDM"
    sudo bash -c 'echo "[org.gnome.desktop.interface]" >> /usr/share/glib-2.0/schemas/93_hidpi.gschema.override'
    sudo bash -c 'echo "scaling-factor=2" >> /usr/share/glib-2.0/schemas/93_hidpi.gschema.override'
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas

    sudo  rm /etc/first_run
    echo "Done!!!"
else
    print_title "First Run!!"
        
    print_title "Install nvidia libgl drivers"
    sudo pacman -S --noconfirm --needed nvidia-libgl lib32-nvidia-libgl
    pause_function

    print_title "Disable dhcpcd service"
    ip link
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
    
    sudo bash -c 'echo "First Run" >> /etc/first_run'
fi
