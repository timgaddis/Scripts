#!/bin/bash
##############################################
##       Ubuntu 16.04 install script        ##
##############################################

# Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# VirtualBox 4.x.x
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian trusty contrib" >> /etc/apt/sources.list.d/virtualbox-offical-source.list'

# Opera browser
#wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
#sudo sh -c 'echo "deb http://deb.opera.com/opera/ stable non-free" > /etc/apt/sources.list.d/opera.list'

# PPA install
sudo add-apt-repository -y ppa:xorg-edgers/ppa                          # Xorg graphic drivers
sudo add-apt-repository -y ppa:thp/gpodder                              # gPodder
sudo add-apt-repository -y ppa:numix/ppa                                # Numix GTK themes
sudo add-apt-repository -y ppa:ricotz/docky                             # Plank dock
sudo add-apt-repository -y ppa:ubuntu-wine/ppa                          # Wine
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer        # Grub Customizer
sudo add-apt-repository -y ppa:conscioususer/polly-daily                # Polly twitter client
sudo add-apt-repository -y ppa:gwendal-lebihan-dev/hexchat-stable       # HexChat IRC client
sudo add-apt-repository -y ppa:webupd8team/java                         # Java 7/8/9
sudo add-apt-repository -y ppa:gencfsm/ppa                              # GNOME Encfs Manager
#sudo add-apt-repository -y ppa:libreoffice/libreoffice-4-4              # LibreOffice 4.4.X
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3			    # Sublime Text 3
sudo add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable      # qBittorrent
sudo add-apt-repository -y ppa:inkscape.dev/stable                      # Inkscape
sudo add-apt-repository -y ppa:moka/stable                              # Moka
sudo add-apt-repository -y ppa:nilarimogard/webupd8						# Razer mouse config

#Vertex theme
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/vertex-theme.list"
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_14.04/Release.key
sudo apt-key add - < Release.key

sudo apt-get update

sudo apt-get -y install wine1.7 pan nemo-dropbox gpodder steam-launcher
sudo apt-get -y install google-chrome-stable qbittorrent razercfg
sudo apt-get -y install oracle-java8-installer virtualbox-5.0 deja-dup
sudo apt-get -y install grub-customizer polly plank pypar2
sudo apt-get -y install conky-all encfs sublime-text-installer gnome-encfs-manager
sudo apt-get -y install numix-gtk-theme numix-icon-theme
sudo apt-get -y install numix-icon-theme-circle gparted curl xsltproc alacarte
sudo apt-get -y install keepassx p7zip-full hexchat lynx inkscape
sudo apt-get -y install build-essential python-software-properties g++ git gitg
sudo apt-get -y install vertex-theme moka-icon-theme moka-cinnamon-theme plank-theme-moka

# Update LibreOffice
#sudo apt-get -y dist-upgrade

# NTFS-config: edit file with "sudo gedit /etc/fstab"
#sudo apt-get -y install ntfs-config
#sudo mkdir -p /etc/hal/fdi/policy

# Add user to vboxusers group
sudo usermod -a -G vboxusers tgaddis

# Automount Storage and Backup
sudo mkdir /media/Storage
sudo mkdir /media/Backup
sudo bash -c 'echo "/dev/sdb1       /media/Storage      ntfs-3g     defaults    0  0" >> /etc/fstab'
sudo bash -c 'echo "/dev/sdc1       /media/Backup      ntfs-3g     defaults    0  0" >> /etc/fstab'

echo "Done!!"
