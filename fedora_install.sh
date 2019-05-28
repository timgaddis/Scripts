#!/bin/bash

##############################################
##         Fedora 30 install script         ##
##############################################

Bold=$(tput bold)
Reset=$(tput sgr0)
#MOUNTPOINT="/mnt"

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

print_title "Test internet connection"
ping -c 3 www.google.com

print_title "System update"
sudo dnf -y update

print_title "Install repositories"
sudo dnf group -y install Standard
pause_function

print_title "Enable RPM fusion repository"
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y update
pause_function

#print_title "Install Fedy"
#sudo dnf install https://dl.folkswithhats.org/fedora/$(rpm -E %fedora)/RPMS/fedy-release.rpm
#sudo dnf install fedy
#pause_function

print_title "Nvidia drivers"
sudo dnf -y install xorg-x11-drv-nvidia akmod-nvidia
sudo dnf -y install xorg-x11-drv-nvidia-libs.i686
pause_function

print_title "Install Media Codecs"
sudo dnf -y groupupdate multimedia Multimedia
sudo dnf -y install gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1
pause_function

print_title "VirtualBox"
sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | rpm --import -
sudo wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -P /etc/yum.repos.d
sudo dnf -y update
sudo dnf -y install @development-tools
sudo dnf -y install kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras VirtualBox-6.0
sudo gpasswd -a tgaddis vboxusers
pause_function

print_title "Install Software groups"
sudo dnf group -y install "C Development Tools and Libraries" "System Tools"
sudo dnf group -y install --with-optional virtualization
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
pause_function

print_title "Install system apps"
sudo dnf -y install p7zip gnome-tweak-tool gparted alacarte conky curl jq lynx gtk-murrine-engine ckb-next grub-customizer lightdm-gtk
pause_function

print_title "Install apps"
sudo dnf -y install plank gimp pan chromium keepassxc qbittorrent deja-dup vlc wine vocal menulibre steam borgbackup
sudo pip3 install vorta
pause_function

print_title "Install Adobe Flash Player"
sudo rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
sudo dnf -y update
sudo dnf -y install flash-plugin
pause_function

#print_title "Install Latex"
#sudo dnf -y install texlive-scheme-small texstudio
#pause_function

print_title "Install programming apps"
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf -y install gitg nodejs sqlitebrowser npm libvirt python-beautifulsoup4 python-pip python-feedparser android-tools java-1.8.0-openjdk sublime-text
pause_function

print_title "Google cloud SDK"
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
sudo dnf -y update
sudo dnf -y install kubectl google-cloud-sdk google-cloud-sdk-app-engine-python google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python-extras
pause_function

print_title "Install themes"
sudo dnf -y copr enable dirkdavidis/papirus-icon-theme
sudo dnf -y install arc-theme arc-theme-plank papirus-icon-theme materia-theme
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/thunderbird-theme-papirus/master/install.sh | env CUSTOM_COLOR=444444 sh
pause_function

print_title "Mount hard drives"
cd /
sudo mkdir /media/Storage
sudo mkdir /media/Backup
sudo mkdir /media/Games
sudo mkdir /media/Pictures
sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdd1       /media/Backup       ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdc1       /media/Pictures     ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/nvme0n1p1  /media/Games        ntfs-3g     defaults    0  0" >> /etc/fstab'

echo "Done!!!"
