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

sudo pacman -R --noconfirm parcellite xed xviewer xviewer-plugins microsoft-office-web-jak

sudo pacman -Syy

print_title "Install system apps"
sudo pacman -S --noconfirm --needed conky jq gksu lynx python-lxml mate-calc gedit neofetch cmake eog eog-plugins evince unace arj gksu expac yajl
sudo systemctl enable ntpd.service
pause_function

print_title "Install codecs"
sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lirc libva-vdpau-driver portaudio twolame projectm libgoom2 vcdimager ttf-freefont lua-socket alsa-firmware playerctl
pause_function

print_title "Install fonts"
sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family tamsyn-font
pause_function

print_title "Install apps"
sudo pacman -S --noconfirm --needed plank deja-dup keepassxc wine vlc qbittorrent pan vocal steam gnu-netcat inkscape borg menulibre ferdi
pause_function

print_title "Install AUR apps"
yay -S --noconfirm --needed gimp-paint-studio gimp-plugin-pandora qdirstat vorta icu68 megasync nemo-megasync google-chrome
pause_function

print_title "Install LibreOffice"
sudo pacman -S --noconfirm --needed libreoffice-fresh
pause_function

print_title "Install programming apps"
sudo pacman -S --noconfirm --needed jre11-openjdk-headless jre11-openjdk jdk11-openjdk openjdk11-doc openjdk11-src
sudo pacman -S --noconfirm --needed gitg nodejs sqlitebrowser npm libvirt android-tools python-beautifulsoup4 python-feedparser python-numpy kotlin
yay -S --noconfirm --needed google-cloud-sdk
sudo archlinux-java set java-11-openjdk
pause_function

print_title "Install VirtualBox"
sudo pacman -S --noconfirm --needed linux512-headers
sudo pacman -S --noconfirm --needed virtualbox dkms virtualbox-guest-iso virtualbox-host-dkms linux512-virtualbox-host-modules
yay -S --noconfirm --needed virtualbox-ext-oracle
sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
sudo gpasswd -a tgaddis vboxusers
pause_function

print_title "Install Sublime Text"
sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
sudo pacman -Syu --noconfirm --needed sublime-text
pause_function

print_title "Install and start plex"
yay -S --noconfirm --needed plex-media-server
sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service
pause_function

print_title "Install themes"
sudo pacman -S --noconfirm --needed arc-gtk-theme gtk-engine-murrine elementary-icon-theme arc-themes-maia gtk-engine-murrine arc-maia-icon-theme paper-icon-theme-git
yay -S --noconfirm --needed papirus-libreoffice-theme plank-theme-arc hardcode-fixer-git arc-kde-git
sudo hardcode-fixer
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

echo "Done!!!"
