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

sudo pacman -Syy

print_title "Install system apps"
sudo pacman -S --noconfirm --needed p7zip gparted conky jq lynx mate-calc gconf-editor grub-customizer neofetch unace arj gksu expac yajl
pause_function

print_title "Install codecs"
sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lirc libva-vdpau-driver portaudio twolame projectm libgoom2 vcdimager ttf-freefont lua-socket alsa-firmware playerctl
pause_function

print_title "Install fonts"
sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family tamsyn-font
pause_function

print_title "Install apps"
sudo pacman -S --noconfirm --needed wine plank deja-dup vlc steam thunderbird keepassxc hexchat qbittorrent pan vocal inkscape borg menulibre megasync nemo-megasync
sudo pacman -S --noconfirm --needed gimp gimp-plugin-lqr gimp-plugin-gmic gimp-plugin-fblur gimp-refocus gimp-nufraw
sudo pacman -S --noconfirm --needed libreoffice-fresh
pause_function

print_title "Install AUR apps"
yay -S --noconfirm --needed franz-bin gimp-paint-studio gimp-plugin-pandora qdirstat vorta cinnamon-sound-effects mint-sounds
pause_function

print_title "Install programming apps"
sudo pacman -S --noconfirm --needed gitg nodejs sqlitebrowser npm libvirt android-tools python-beautifulsoup4 python-pip python-feedparser jdk8-openjdk
yay -S --noconfirm --needed google-cloud-sdk
pause_function

print_title "Install VirtualBox"
sudo pacman -S --noconfirm --needed virtualbox dkms virtualbox-guest-iso virtualbox-host-dkms
yay -S --noconfirm --needed virtualbox-ext-oracle
sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
sudo gpasswd -a tgaddis vboxusers
pause_function

print_title "Install Sublime Text"
sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
sudo pacman -Syu --noconfirm --needed sublime-text
pause_function

print_title "Install and enable plex"
yay -S --noconfirm --needed plex-media-server
sudo systemctl enable plexmediaserver.service
pause_function

print_title "Install AUR themes"
sudo pacman -S --noconfirm --needed arc-icon-theme arc-gtk-theme elementary-icon-theme
yay -S --noconfirm --needed papirus-libreoffice-theme-git hardcode-fixer-git paper-icon-theme-git papirus-icon-theme-git sddm-theme-abstractdark-git
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
sudo bash -c 'echo "/dev/sdd1       /media/Pictures     ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/nvme0n1p1  /media/Games        ntfs-3g     defaults    0  0" >> /etc/fstab'

echo "Done!!!"
