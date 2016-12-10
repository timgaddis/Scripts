#!/bin/sh
##############################################
##       Linux Mint 18 install script       ##
##############################################

print_title() {
    #clear
    echo ""
    echo "******************************"
    echo "#  ${Bold}$1${Reset}"
    echo "******************************"
}

print_title "VirtualBox"
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list.d/virtualbox-offical-source.list'
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

print_title "GetDeb"
wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu xenial-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list'

print_title "PPA install"
sudo apt add-repository -y ppa:graphics-drivers/ppa                     # Nvidia graphic drivers
#sudo add-apt-repository -y ppa:bit-team/stable                          # Back in Time
sudo apt add-repository -y ppa:thp/gpodder                              # gPodder
#sudo apt add-repository -y ppa:numix/ppa                                # Numix GTK themes
sudo apt add-repository -y ppa:ricotz/docky                             # Plank dock
sudo apt add-repository -y ppa:ubuntu-wine/ppa                          # Wine
sudo apt add-repository -y ppa:danielrichter2007/grub-customizer        # Grub Customizer
#sudo apt add-repository -y ppa:conscioususer/polly-daily                # Polly twitter client
sudo apt add-repository -y ppa:menulibre-dev/daily                      # Menu Libre
sudo apt add-repository -y ppa:gwendal-lebihan-dev/hexchat-stable       # HexChat IRC client
sudo apt add-repository -y ppa:webupd8team/java                         # Java 6/7/8/9
#sudo apt add-repository -y ppa:gencfsm/ppa                              # GNOME Encfs Manager
sudo apt add-repository -y ppa:libreoffice/libreoffice-5-2              # LibreOffice 5.2.X
sudo apt add-repository -y ppa:webupd8team/sublime-text-3               # Sublime Text 3
sudo apt add-repository -y ppa:qbittorrent-team/qbittorrent-stable      # qBittorrent
sudo apt add-repository -y ppa:inkscape.dev/stable                      # Inkscape
sudo apt add-repository -y ppa:moka/stable                              # Moka
sudo apt add-repository -y ppa:duplicity-team/ppa                       # Duplicity
#sudo add-apt-repository -y ppa:stellarium/stellarium-releases           # Stellarium

print_title "Arc and Vertex themes"
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
sudo apt-key add - < Release.key
rm Release.key

sudo apt update
sudo apt upgrade -y

print_title "System apps"
sudo apt install -y nvidia-370 nvidia-settings nvidia-prime ntfs-config mint-meta-codecs encfs ttf-mscorefonts-installer fonts-droid-fallback nodejs

print_title "Other apps"
sudo apt install -y wine1.8 pan gpodder steam qbittorrent hwinfo font-manager oracle-java8-installer oracle-java8-set-default virtualbox-5.1
sudo apt install -y adobe-flashplugin grub-customizer polly plank pypar2 gparted curl deja-dup chromium-browser conky-all sublime-text-installer
sudo apt install -y jq keepassx p7zip-full hexchat lynx inkscape xsltproc menulibre 
# backintime-qt4 gnome-encfs-manager nemo-dropbox stellarium

print_title "Development apps"
sudo apt install -y python-requests python-requests-oauthlib python-oauthlib build-essential python-software-properties g++ git gitg
	
#print_title "Latex apps"
#sudo apt install -y texlive-full texstudio

print_title "Themes"
#sudo apt install -y numix-gtk-theme numix-icon-theme numix-icon-theme-circle
sudo apt install -y moka-icon-theme faba-icon-theme moka-gnome-shell-theme moka-gtk-theme
sudo apt install -y gtk2-engines-murrine vertex-theme arc-theme

# Add user to vboxusers group
sudo usermod -a -G vboxusers tgaddis

# Automount Storage and Backup
sudo mkdir /media/Storage
sudo mkdir /media/Backup
sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdc1       /media/Backup      ntfs-3g     defaults    0  0" >> /etc/fstab'

# Android Studio fix
sudo bash -c 'echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.d/60-jetbrains.conf'

echo "Done!!"
