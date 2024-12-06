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

sudo pacman -Rs --noconfirm xed

print_title "Install system apps"
sudo pacman -S --noconfirm --needed conky jq lynx python-lxml mate-calc cmake eog eog-plugins unace arj expac yajl p7zip gparted gnome-font-viewer gedit numlockx gnome-keyring xdg-desktop-portal-gtk evince
pause_function

print_title "Install Raedon drivers"
sudo pacman -S --noconfirm --needed xf86-video-ati vulkan-radeon lib32-vulkan-radeon vulkan-tools
yay -S --noconfirm --needed radeon-profile-git radeon-profile-daemon-git
sudo systemctl enable radeon-profile-daemon.service
sudo systemctl start radeon-profile-daemon.service
pause_function

print_title "Install codecs"
sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lirc portaudio twolame projectm libgoom2 vcdimager ttf-freefont lua-socket alsa-firmware playerctl
pause_function

print_title "Install fonts"
sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family
pause_function

print_title "Install apps"
sudo pacman -S --noconfirm --needed plank deja-dup keepassxc wine vlc qbittorrent steam inkscape borg hexchat gimp solaar telegram-desktop
pause_function

print_title "Install AUR apps"
yay -S --noconfirm --needed ferdium kalu gimp-paint-studio megasync-bin vorta google-chrome stash-bin fstl pan lightdm-settings mailspring-bin
wget https://mega.nz/linux/repo/Arch_Extra/x86_64/nemo-megasync-x86_64.pkg.tar.zst && sudo pacman -U --noconfirm nemo-megasync-x86_64.pkg.tar.zst
pause_function

print_title "Install Flatpak"
sudo pacman -S --noconfirm --needed flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
pause_function

print_title "Install programming apps"
sudo pacman -S --noconfirm --needed jdk-openjdk openjdk-doc openjdk-src
sudo pacman -S --noconfirm --needed gitg sqlitebrowser npm libvirt android-tools python-beautifulsoup4 python-feedparser python-numpy python-regex kotlin
yay -S --noconfirm --needed gitkraken python-selenium selenium-manager geckodriver chromedriver
pause_function

print_title "Install and start plex"
yay -S --noconfirm --needed plex-media-server
sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service
pause_function

print_title "Install LibreOffice"
sudo pacman -S --noconfirm --needed libreoffice-fresh
pause_function

print_title "Install VirtualBox"
sudo pacman -S --noconfirm --needed virtualbox virtualbox-guest-iso virtualbox-host-dkms
yay -S --noconfirm --needed virtualbox-ext-oracle
sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
sudo gpasswd -a tgaddis vboxusers
pause_function

print_title "Install Sublime Text"
sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
sudo pacman -Syy --noconfirm sublime-text
pause_function

print_title "Install themes and sounds"
sudo pacman -S --noconfirm --needed arc-icon-theme gtk-engine-murrine elementary-icon-theme gtk-engine-murrine
yay -S --noconfirm --needed papirus-icon-theme-git 
mkdir sound
cd sound
wget -O PKGBUILD https://bit.ly/3YffPWX
wget -O cinnamon-sound-effects.gschema.override https://bit.ly/4eQB3kt
wget -O cinnamon-sound-effects.install https://bit.ly/4gUCQXn
makepkg --install
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

print_title "HiDPI fix for GRUB"
sudo cp /etc/default/grub /etc/default/grub.bak
sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=1024x768x32/g' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo sed -i 's/#IgnorePkg   =/IgnorePkg   = cinnamon-sound-effects nemo-megasync/g' /etc/pacman.conf

echo "Done!!!"
