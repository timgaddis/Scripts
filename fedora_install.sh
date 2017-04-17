#!/bin/bash

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
# pause_function

print_title "Install repositories"
sudo dnf group -y install Standard

print_title "Chrome"
echo "[google-chrome]" >> /etc/yum.repos.d/google-chrome.repo
echo "name=google-chrome" >> /etc/yum.repos.d/google-chrome.repo
echo "baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch" >> /etc/yum.repos.d/google-chrome.repo
echo "enabled=1" >> /etc/yum.repos.d/google-chrome.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/google-chrome.repo
echo "gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" >> /etc/yum.repos.d/google-chrome.repo

print_title "VirtualBox"
sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | rpm --import -
sudo wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -P /etc/yum.repos.d

print_title "Gnome Encfs Manager"
sudo wget http://download.opensuse.org/repositories/home:moritzmolch:gencfsm/Fedora_23/home:moritzmolch:gencfsm.repo -P /etc/yum.repos.d

print_title "Themes"
sudo wget http://download.opensuse.org/repositories/home:snwh:moka-project/Fedora_22/home:snwh:moka-project.repo -P /etc/yum.repos.d
sudo wget http://download.opensuse.org/repositories/home:Horst3180/Fedora_23/home:Horst3180.repo -P /etc/yum.repos.d
# pause_function

print_title "Enable RPM fusion repository"
su -c 'dnf -y install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'
# pause_function

print_title "System update"
sudo dnf -y check-update
# pause_function

print_title "Install Nvidia drivers"
sudo dnf -y install akmod-nvidia "kernel-devel-uname-r == $(uname -r)"
sudo dnf -y install xorg-x11-drv-nvidia-libs.i686
# pause_function

print_title "Install Software groups"
sudo dnf group -y install "C Development Tools and Libraries" "Development Tools" "System Tools" Multimedia "Design Suite" Fonts "Printing Support"

print_title "Install Adobe Flash Player"
sudo rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-i386-1.0-1.noarch.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
sudo dnf -y install flash-plugin
# pause_function

print_title "Install system apps"
sudo dnf -y install p7zip gnome-tweak-tool encfs gparted alacarte conky curl jq lynx gtk-murrine-engine pygpgme
# pause_function

print_title "Install Media Codecs"
sudo dnf -y install gstreamer-plugins-bad gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer-ffmpeg gstreamer1-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1
# pause_function

print_title "Install apps"
sudo dnf -y install wine plank gimp pan gpodder google-chrome-stable keepassx hexchat gitg qbittorrent deja-dup vlc gnome-encfs-manager nemo-dropbox menulibre
# enpass
# pause_function

print_title "Install Latex"
sudo dnf -y install texlive-scheme-small texstudio
pause_function

print_title "Install VirtualBox"
sudo dnf -y install VirtualBox-5.0 VirtualBox-guest dkms
sudo /usr/lib/virtualbox/vboxdrv.sh setup
sudo usermod -a -G vboxusers tgaddis
# pause_function

print_title "Install polly"
sudo dnf -y install dbus-python gnome-python2-gconf gnome-python2-gtkspell notify-python numpy pygtk2 pyxdg python-SocksiPy python-httplib2 python-keyring python-oauth2 python-pycurl
wget https://launchpad.net/polly/1.0/pre-alpha-2/+download/Polly-0.93.12.tar.gz
tar xzvf Polly-0.93.12.tar.gz
cd Polly-0.93.12
sudo ./install
cd ..
sudo rm Polly-0.93.12.tar.gz
sudo rm -r Polly-0.93.12
# pause_function

print_title "Install steam"
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo
sudo dnf -y install steam
# pause_function

print_title "Install themes"
sudo dnf -y install arc-theme ceti-2-theme vertex-theme moka-icon-theme plank-theme-moka moka-gnome-shell-theme
# pause_function

print_title "Automount Storage and Backup"
sudo mkdir /media/Storage
sudo mkdir /media/Backup
sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdc1       /media/Backup      ntfs-3g     defaults    0  0" >> /etc/fstab'
# pause_function

