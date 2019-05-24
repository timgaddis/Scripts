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

sudo pacman -Syy

print_title "Install system apps"
sudo pacman -S gparted conky jq gksu lynx python-lxml mate-calc ntp gconf-editor nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia lib32-nvidia-utils grub-customizer
pause_function

print_title "Install trizen"
git clone https://aur.archlinux.org/trizen.git
cd trizen
makepkg -si
cd ..
pause_function

print_title "Install codecs"
sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lirc libva-vdpau-driver portaudio twolame projectm libgoom2 vcdimager ttf-freefont lua-socket
pause_function

# print_title "Install BOINC"
# sudo pacman -S boinc
# sudo gpasswd -a tgaddis boinc
# sudo systemctl enable boinc.service
# sudo systemctl start boinc.service
# sudo chmod 640 /var/lib/boinc/gui_rpc_auth.cfg
# pause_function

print_title "Install apps"
sudo pacman -S plank deja-dup vlc firefox thunderbird keepassxc hexchat wine qbittorrent pan gimp gimp-plugin-lqr gimp-plugin-gmic gimp-plugin-fblur gimp-refocus gimp-nufraw flashplugin vocal
pause_function

# print_title "Install Latex"
# sudo pacman -S texlive-most texstudio
# pause_function

print_title "Install AUR apps"
trizen -S spideroak-one franz-bin gimp-paint-studio gimp-plugin-pandora cinnamon-sound-effects menulibre
pause_function

print_title "Install programming apps"
trizen -S google-cloud-sdk gitg nodejs sqlitebrowser npm libvirt android-tools python-beautifulsoup4 atom-editor-bin python-pip python-feedparser jdk8-openjdk
# jdk8
pause_function

print_title "Install VirtualBox"
sudo pacman -S virtualbox dkms virtualbox-guest-iso linux-headers virtualbox-host-dkms
sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
sudo gpasswd -a tgaddis vboxusers
pause_function

print_title "Install Sublime Text"
sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
sudo pacman -Syu sublime-text
pause_function

print_title "Install printers"
trizen -S gsfonts cups ghostscript system-config-printer gutenprint gtk3-print-backends
sudo gpasswd -a tgaddis sys
sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service
pause_function

print_title "Install and start Corsair driver"
trizen -S ckb-next-git
sudo systemctl enable ckb-next-daemon.service
sudo systemctl start ckb-next-daemon.service
pause_function

print_title "Install and start plex"
trizen -S plex-media-server
sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service
pause_function

print_title "Install AUR themes"
trizen -S papirus-icon-theme-git papirus-libreoffice-theme-git paper-icon-theme-git arc-icon-theme hardcode-fixer-git arc-gtk-theme 
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
sudo bash -c 'echo "/dev/sdd1       /media/Backup       ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdc1       /media/Pictures     ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/nvme0n1p1  /media/Games        ntfs-3g     defaults    0  0" >> /etc/fstab'

print_title "HiDPI fix for login screen"
sudo bash -c 'echo "html { zoom: 2.0; }" >> /usr/share/lightdm-webkit/themes/antergos/css/style.css'

echo "Done!!!"
