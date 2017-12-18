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

print_title "Install system apps"
sudo pacman -S pacaur gparted conky jq gksu lynx python-lxml galculator ntp gconf-editor nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia lib32-nvidia-utils
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
sudo pacman -S plank deja-dup vlc thunderbird keepass hexchat qbittorrent pan wine
sudo pacman -S gimp gimp-plugin-lqr gimp-plugin-gmic gimp-plugin-fblur gimp-refocus gimp-ufraw
pause_function

print_title "Install VirtualBox"
sudo pacman -S virtualbox dkms virtualbox-guest-iso linux-headers qt4 virtualbox-host-dkms
sudo bash -c 'echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf'
sudo gpasswd -a tgaddis vboxusers
pause_function

# print_title "Install Latex"
# sudo pacman -S texlive-most texstudio
# pause_function

print_title "Install AUR apps"
pacaur -S rar gpodder3 spideroak-one polly menulibre gimp-paint-studio gimp-plugin-pandora
pause_function

print_title "Install programming apps"
pacaur -S google-cloud-sdk gitg jdk8 nodejs sqlitebrowser npm sublime-text-dev libvirt android-tools
pause_function

print_title "Android Studio fix"
sudo bash -c 'echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.d/60-sysctl.conf'
gpg --recv-keys C52048C0C0748FEE227D47A2702353E0F7E48EDB
pacaur -S ncurses5-compat-libs
pause_function

#print_title "Install Sublime Text"
#sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
#sudo bash -c 'echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf'
#sudo pacman -Syu sublime-text
#pause_function

print_title "Install printers"
pacaur -S gsfonts cups ghostscript system-config-printer gutenprint gtk3-print-backends
sudo gpasswd -a tgaddis sys
sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service
pause_function

print_title "Install and start Corsair driver"
pacaur -S ckb-next-git
sudo systemctl enable ckb-daemon.service
sudo systemctl start ckb-daemon.service
pause_function

print_title "Install and start plex"
pacaur -S plex-media-server
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
# Replace password and run pia -a
pause_function

print_title "Install AUR themes"
pacaur -S gtk-theme-arc-git moka-icon-theme-git ceti-2-themes-git vertex-themes-git paper-gtk-theme-git papirus-icon-theme-git papirus-libreoffice-theme-git
pause_function

print_title "Automount Storage and Backup"
cd /
sudo mkdir media
sudo mkdir /media/Storage
sudo mkdir /media/Backup
sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdc1       /media/Backup      ntfs-3g     defaults    0  0" >> /etc/fstab'

echo "Done!!!"
