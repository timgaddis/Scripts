#!/bin/sh
##############################################
##      Linux Mint 19 install script        ##
##############################################

print_title() {
    #clear
    echo ""
    echo "******************************"
    echo "#  ${Bold}$1${Reset}"
    echo "******************************"
}

print_title "VirtualBox"
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian bionic contrib" >> /etc/apt/sources.list.d/virtualbox-offical-source.list'
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

#print_title "GetDeb"
#wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
#sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu xenial-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list'

print_title "Wine"
sudo dpkg --add-architecture i386
wget https://dl.winehq.org/wine-builds/Release.key
sudo apt-key add Release.key
#sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
rm Release.key

print_title "Google Chrome"
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
wget https://dl.google.com/linux/linux_signing_key.pub
sudo apt-key add linux_signing_key.pub
rm linux_signing_key.pub

print_title "Plex Media Server"
sudo sh -c 'echo "deb https://downloads.plex.tv/repo/deb public main" >> /etc/apt/sources.list.d/plexmediaserver.list'
sudo curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -

print_title "Spideroak"
sudo sh -c 'echo "deb http://apt.spideroak.com/ubuntu-spideroak-hardy/ release restricted" >> /etc/apt/sources.list.d/spideroak.com.sources.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 573E3D1C51AE1B3D

print_title "Sublime Text"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install -y apt-transport-https
sudo sh -c 'echo "deb https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list'

print_title "PPA install"
sudo apt-add-repository -y ppa:graphics-drivers/ppa                     # Nvidia graphic drivers
#sudo add-apt-repository -y ppa:bit-team/stable                          # Back in Time
#sudo apt-add-repository -y ppa:thp/gpodder                              # gPodder
sudo apt-add-repository -y ppa:ricotz/docky                             # Plank dock
sudo apt-add-repository -y ppa:danielrichter2007/grub-customizer        # Grub Customizer
#sudo apt-add-repository -y ppa:overcoder/hexchat                        # HexChat IRC client
sudo apt-add-repository -y ppa:webupd8team/java                         # Java 7/8/9
#sudo apt add-repository -y ppa:gencfsm/ppa                              # GNOME Encfs Manager
sudo apt-add-repository -y ppa:libreoffice/libreoffice-6-0              # LibreOffice 6.0.X
sudo apt-add-repository -y ppa:qbittorrent-team/qbittorrent-stable      # qBittorrent
#sudo apt add-repository -y ppa:inkscape.dev/stable                      # Inkscape
sudo apt-add-repository -y ppa:duplicity-team/ppa                       # Duplicity
sudo apt-add-repository -y ppa:otto-kesselgulasch/gimp					# Gimp
#sudo add-apt-repository -y ppa:stellarium/stellarium-releases           # Stellarium
#sudo add-apt-repository -y ppa:ubuntu-mozilla-security/ppa              # Thunderbird
#sudo add-apt-repository -y ppa:menulibre-dev/daily                      # MenuLibre
sudo add-apt-repository -y ppa:davidmeikle/ckb-next-release             # Corsair driver

print_title "Desktop and icon themes PPA"
sudo apt-add-repository -y ppa:numix/ppa                                # Numix GTK themes
sudo apt-add-repository -y ppa:snwh/ppa                                 # Moka and Paper icons
sudo apt-add-repository -y ppa:papirus/papirus                          # Papirus theme
sudo add-apt-repository -y ppa:fossfreedom/arc-gtk-theme-daily          # Arc theme

sudo apt update
sudo apt upgrade -y

print_title "System apps"
sudo apt install -y nvidia-graphics-drivers-396 nvidia-settings ntfs-config mint-meta-codecs ttf-mscorefonts-installer fonts-droid-fallback ckb-next
# nvidia-prime libcuda1-378 nvidia-opencl-icd-378 encfs

print_title "Wine"
sudo apt-get install -y --install-recommends winehq-stable

print_title "Flatpak apps"
flatpak install --from https://flathub.org/repo/appstream/com.github.needleandthread.vocal.flatpakref
flatpak install flathub io.github.Hexchat

print_title "Other apps"
sudo apt install -y pan gpodder steam qbittorrent hwinfo font-manager virtualbox-5.2 adobe-flashplugin grub-customizer plank pypar2 gparted curl deja-dup conky-all sublime-text jq keepassxc p7zip-full lynx xsltproc gimp gimp-plugin-registry gmic chromium-browser pepperflashplugin-nonfree google-chrome-stable plexmediaserver spideroakone
# backintime-qt4 gnome-encfs-manager nemo-dropbox stellarium inkscape hexchat gimp menulibre

print_title "Development apps"
sudo apt install -y build-essential python-software-properties g++ git gitg sqlitebrowser nodejs oracle-java8-unlimited-jce-policy android-tools-adb autoconf automake pkg-config libgtk-3-dev oracle-java8-installer oracle-java8-set-default
# python-requests python-requests-oauthlib python-oauthlib android-tools-fastboot

print_title "KVM install"
sudo apt install -y qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virt-manager
sudo adduser `id -un` libvirtd

#print_title "Latex apps"
#sudo apt install -y texlive-full texstudio

print_title "Themes"
sudo apt install -y numix-gtk-theme numix-icon-theme numix-icon-theme-circle numix-icon-theme-square papirus-icon-theme libreoffice-style-papirus moka-icon-theme faba-icon-theme paper-icon-theme moka-gnome-shell-theme moka-gtk-theme gtk2-engines-murrine arc-theme
# vertex-theme system76-pop-gtk-theme system76-pop-icon-theme 

# Add user to vboxusers group
sudo usermod -a -G vboxusers tgaddis

# Automount Storage and Backup
sudo mkdir /media/Storage
sudo mkdir /media/Backup
sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdc1       /media/Backup      ntfs-3g     defaults    0  0" >> /etc/fstab'

# Android Studio fix
#sudo bash -c 'echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.d/60-jetbrains.conf'

echo "Done!!"
