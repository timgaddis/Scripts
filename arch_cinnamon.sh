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
    sudo pacman -Sy --noconfirm --needed expac yajl bash-completion gnupg
    gpg --list-keys
    echo "keyring /etc/pacman.d/gnupg/pubring.gpg" >> ~/.gnupg/gpg.conf
    pause_function

    print_title "Install system apps"
    sudo pacman -S --noconfirm --needed gedit p7zip gparted conky curl jq gnome-font-viewer lynx python-lxml libmtp gvfs gvfs-mtp gnome-calculator gnome-screenshot gnome-system-monitor ntfs-3g gnome-terminal gnome-keyring openvpn networkmanager-openvpn neofetch cmake evince unace arj downgrade
    pause_function

    print_title "Install Hardware apps"
    sudo pacman -S --noconfirm --needed amd-ucode dmidecode dmraid hdparm hwdetect intel-ucode lsscsi mtools sg3_utils sof-firmware
    pause_function

    print_title "Install printers"
    sudo pacman -S --noconfirm --needed gtk3-print-backends cups cups-filters cups-pdf foomatic-db foomatic-db-engine foomatic-db-gutenprint-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds foomatic-db-ppds ghostscript gsfonts gutenprint splix system-config-printer
    yay -S --noconfirm --needed brother-mfc-j491dw
    sudo gpasswd -a tgaddis sys
    sudo systemctl enable cups.service
    sudo systemctl start cups.service
    pause_function
    
    print_title "Configure gnome terminal"
    sudo bash -c 'echo "LANG=\"en_US.UTF-8\"" >> /etc/locale.conf'
    pause_function

    print_title "Install and enable ntp"
    sudo pacman -S --noconfirm --needed ntp
    sudo systemctl enable ntpd.service
    pause_function

    print_title "Install bluetooth"
    sudo pacman -S --noconfirm --needed bluez bluez-utils gnome-bluetooth blueman
    sudo systemctl start bluetooth.service
    sudo systemctl enable bluetooth.service
    pause_function

    print_title "Install codecs"
    sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lirc libva-vdpau-driver portaudio twolame projectm libgoom2 vcdimager ttf-freefont lua-socket alsa-firmware playerctl
    pause_function

    print_title "Install fonts"
    sudo pacman -S --noconfirm --needed --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family tamsyn-font freetype2 ttf-opensans
    pause_function

    print_title "Install apps"
    sudo pacman -S --noconfirm --needed gthumb firefox wine plank gimp deja-dup vlc steam keepassxc hexchat qbittorrent eog eog-plugins pan vocal inkscape borg piper
    # gimp-plugin-lqr gimp-plugin-gmic gimp-plugin-fblur gimp-refocus gimp-nufraw
    pause_function

    print_title "Install AUR apps"
    yay -S --noconfirm --needed ferdium-bin gimp-paint-studio megasync nemo-megasync vorta google-chrome brother-mfc-j491dw mint-artwork-cinnamon pamac-aur mailspring stash-bin
    pause_function

    print_title "Install programming apps"
    sudo pacman -S --noconfirm --needed jre11-openjdk-headless jre11-openjdk jdk11-openjdk openjdk11-doc openjdk11-src
    sudo pacman -S --noconfirm --needed gitg sqlitebrowser npm libvirt android-tools python-beautifulsoup4 python-feedparser python-numpy kotlin nodejs
    yay -S --noconfirm --needed google-cloud-sdk google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datastore-emulator
    yay -S --noconfirm --needed python-selenium geckodriver chromedriver
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
    sudo pacman -S --noconfirm --needed libreoffice-fresh
    pause_function

    print_title "Install Sublime Text"
    sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
    sudo pacman -Syu --noconfirm --needed sublime-text
    pause_function
	
    print_title "Install AUR themes"
    sudo pacman -S --noconfirm --needed arc-icon-theme gtk-engine-murrine elementary-icon-theme gtk-engine-murrine
    yay -S --noconfirm --needed papirus-libreoffice-theme papirus-icon-theme-git plank-theme-arc
    pause_function

    print_title "Mount hard drives"
    cd /
    sudo mkdir media
    sudo mkdir /media/Storage
    sudo mkdir /media/Backup
    sudo mkdir /media/Games
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
        
    # print_title "Install nvidia libgl drivers"
    # sudo pacman -S --noconfirm --needed nvidia-libgl lib32-nvidia-libgl
    # pause_function

    print_title "Install yay"
    sudo pacman -S --noconfirm git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
    pause_function

    print_title "Install Raedon drivers"
    sudo pacman -S --noconfirm --needed xf86-video-ati vulkan-radeon lib32-vulkan-radeon vulkan-tools
    yay -S --noconfirm --needed radeon-profile-git radeon-profile-daemon-git
    sudo systemctl enable radeon-profile-daemon.service
    sudo systemctl start radeon-profile-daemon.service
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
