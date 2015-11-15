#!/usr/bin/env bash
##-- vim: set ai et ts=4 sw=4 :

##----------------------------------------------------------------------------------------
wget -q --tries=10 --timeout=2 --spider https://www.archlinux.org/
if [[ $? -eq 0 ]]; then
    echo ""
else
    exit 1
fi

##----------------------------------------------------------------------------------------
read -p "Enable pacman's extra options? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Enabling pacman's extra options..."
    sed -i 's|^#Color|Color|' /etc/pacman.conf
    sed -i 's|^#VerbosePkgLists|VerbosePkgLists|' /etc/pacman.conf
    sed -i -e '/# Misc options/a ILoveCandy' /etc/pacman.conf
    sed -i 's|^#UseSyslog|UseSyslog|' /etc/pacman.conf
    sed -i 's|^#TotalDownload|TotalDownload|' /etc/pacman.conf
    sed -i 's|^#\[multilib\]|\[multilib\]|' /etc/pacman.conf
    sed -i -e '/\[multilib\]/{n;d}' /etc/pacman.conf
    sed -i -e '/\[multilib\]/a Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Set the language, and locale? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Setting the locale..."
    sed -i 's|^#en_US|en_US|g' /etc/locale.gen
    locale-gen
    export LANG=en_US.utf-8
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Set the system and hardware times? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Setting the system time..."
    ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
    hwclock --systohc --utc
    pacman -S ntp
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Set the hostname and some console options? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Setting host and console info..."
    echo Charon > /etc/hostname
    sed -i 's|localhost|localhost Charon|2' /etc/hosts
    echo "KEYMAP=us" > /etc/vconsole.conf
    echo "" >> /etc/vconsole.conf
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install wireless tools? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing and setting up wireless tools..."
    pacman -S --asexplicit dialog wpa_supplicant wpa_actiond netctl dhcpcd ifplugd ppp
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install and configure bootloader? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing and configuring the bootloader..."
    pacman -S --asexplicit syslinux gptfdisk
    syslinux-install_update -iam
    cp /boot/syslinux/syslinux.cfg /boot/syslinux/syslinux.cfg.default
    disk=""
    sed -i "s|APPEND.*$|APPEND cryptdevice=/dev/disk/by-uuid/${disk}\:lvm root=/dev/mapper/Charon-rootvol rw elevator=noop|" /boot/syslinux/syslinux.cfg
    sed -i "s|INITRD.*$|INITRD ../intel-ucode.img,../initramfs-linux.img|g" /boot/syslinux/syslinux.cfg
    sed -i 's|block filesystems|block encrypt lvm2 resume filesystems|' /etc/mkinitcpio.conf
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install kernel and associated firmware? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing kernel and firmware..."
    pacman -S --asexplicit --noconfirm linux linux-lts intel-ucode linux-headers linux-firmware \
                                       linux-lts-headers linux-api-headers util-linux
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install tools for AUR/ABS development? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing utilities for development..."
    pacman -S --asexplicit --noconfirm multilib-devel fakeroot tk jshon make pkg-config \
                                       autoconf automake patch ed
    pacman -S --asexplicit --noconfirm git bzr subversion mercurial abs
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install filesystem support programs? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing file system support..."
    pacman -S --asexplicit --noconfirm btrfs-progs f2fsprogs dosfstools fuse-exfat ntfs-3g \
                                       exfat-utils fuseiso e2fsprogs xfs-progs jfsutils \
                                       nilfs-utils reiserfsprogs lib32-e2fsprogs f2fs-tools \
                                       lua-filesystem lua51-filesystem lua52-filesystem \
                                       fatsort s3fs-fusenfs-utils curlftpfs
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install True Type Fonts? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing fonts..."
    pacman -S --asexplicit --noconfirm ttf-bitstream-vera ttf-cheapskate ttf-dejavu gsfonts \
                                       ttf-freefont ttf-linux-libertine ttf-oxygen \
                                       opendesktop-fonts ttf-anonymous-pro ttf-droid \
                                       ttf-fira-mono ttf-fira-sans ttf-gentium gnu-free-fonts \
                                       ttf-inconsolata ttf-ionicons ttf-liberation \
                                       ttf-linux-libertine-g ttf-symbola ttf-ubuntu-font-family \
                                       fontconfig freetype2 terminus-font
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install Xorg font libraries? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing xorg font libraries..."
    pacman -S --asexplicit --noconfirm xorg-font-util xorg-font-utils xorg-fonts-100dpi \
                                       xorg-fonts-75dpi xorg-fonts-alias xorg-fonts-encodings \
                                       xorg-fonts-misc xorg-xlsfonts xorg-xfd
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install Symbolic (japan, china, tai, etc) fonts? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing symbolic (japan, china, etc) fonts..."
    pacman -S --asexplicit --noconfirm ttf-arphic-ukai ttf-arphic-uming ttf-baekmuk \
                                       ttf-freebanglafont ttf-hannom ttf-indic-otf \
                                       ttf-junicode ttf-khmer ttf-mph-2b-damase ttf-sazanami \
                                       ttf-tibetan-machine ttf-tlwg ttf-ubraille ttf-hanazono
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install the Xorg Display server? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing X11 server..."
    pacman -S --asexplicit --noconfirm xorg-server xorg-server-common xorg-server-utils \
                                       xorg-utils xorg-apps xorg-xinit xorg-appres \
                                       xorg-twm xorg-util-macros
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install graphics drivers? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    pacman -S --asexplicit --noconfirm xf86-video-vesa xf86-video-intel intel-tbb mesa lib32-mesa \
                                       glu libtxc_dxtn mesa-demos mesa-libgl mesa-vdpau lib32-glu \
                                       lib32-libtxc_dxtn lib32-mesa-demos lib32-mesa-libgl \
                                       lib32-mesa-vdpau
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install zshell and associated tools? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing zshell and associated tools..."
    pacman -S --asexplicit --noconfirm zsh zsh-completions zsh-syntax-highlighting \
                                       zsh-lovers zshdb
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install archiving tools? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    pacman -S --asexplicit --noconfirm lz4 lzo lzop lrzip xz lib32-xz p7zip unzip bzip2 gzip perl \
                                       zlib libzip zip zziplib fcrackzip haskell-zlib lbzip2 lrzip \
                                       minizip pbzip2 pigz lib32-bzip2 lib32-zlib unarj atool cpio \
                                       unp rpmextract ace unace libarchive minizip
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install vim editor and neato plugins? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing editor and associated plugins..."
    pacman -S --asexplicit --noconfirm vim vim-runtime vim-spell-en vim-airline vim-fugitive \
                                       vim-nerdtree vim-syntastic vim-systemd vimpager
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install some power saving, control programs? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing power saving tools..."
    pacman -S --asexplicit --noconfirm cpupower powertop tp_smapi tp_smapi-lts tlp dkms \
                                       acpi acpid upower lm_sensors libacpi smartmontools
    echo -e "\n >>> Installing graphical elements..."
    pacman -S --asexplicit --noconfirm xf86-input-synaptics xf86-input-evdev gksu conky
    echo -e "\n >>> Installing some tools for user security and stability..."
    pacman -S --asexplicit --noconfirm lvm2 cryptsetup iptables
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install rxvt and some cli tools? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing cli tools..."
    pacman -S --asexplicit --noconfirm rxvt-unicode rxvt-unicode-terminfo ranger tree wget \
                                       pwgen rougue nethack mc openssh tmux rsync curl w3m \
                                       lib32-curl inxi
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install multimedia tools mpd, mpv, etc? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing multimedia tools..."
    pacman -S --asexplicit --noconfirm mpd mpc ncmpcpp libmpd libmpdclient python2-mpd \
                                       mp3info mpv
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install cryptography tools? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing crypto tools..."
    pacman -S --asexplicit --noconfirm cryptsetup libgcrypt libgpg-error nettle libcryptui \
                                       libmcrypt php-mcrypt python-crypto python-cryptography \
                                       python2-crypto python2-cryptography ecryptfs-utils \
                                       encfs haskell-entropy lib32-libgcrypt lib32-nettle \
                                       lib32-libgpg-error polkit polkit-gnome clamav \
                                       python2-pyclamd haveged
    echo -e "\n >>> Installing codecs and media backup software..."
    pacman -S --asexplicit --noconfirm libdvdcss libdvbpsi
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install some spell checking libraries? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing spell checking libraries..."
    pacman -S --asexplicit --noconfirm aspell aspell-en hunspell hunspell-en hyphen hyphen-en \
                                       libmythes mythes-en psiconv
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install sound sub-system? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing sound system utilities..."
    pacman -S --asexplicit --noconfirm alsa-lib alsa-plugins alsa-utils alsaequal lib32-alsa-lib \
                                       lib32-alsa-plugins pulseaudio pulseaudio-alsa libcanberra \
                                       libcanberra-pulse lib32-libcanberra lib32-libcanberra-pulse \
                                       alsa-firmware libpulse pavucontrol lib32-libpulse libao
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Installing userspace tools? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing userspace tools..."
    pacman -S --asexplicit --noconfirm feh xxkb asciidoc mutt screenfetch youtube-dl \
                                       youtube-viewer cowsay luakit fetchmail blender \
                                       simplescreenrecorder lib32-simplescreenrecorder \
                                       luxblend25 octave htop glances rtorrent finch \
                                       xorg-xcalc xorg-xclock galculator-gtk2
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install documentation? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing documentation..."
    pacman -S --asexplicit --noconfirm linux-docs linux-lts-docs linux-manpages \
                                       zsh-doc sqlite-doc ruby-docs bash-docs \
                                       arch-wiki-docs gcc-docs pyhton-docs python2-docs \
                                       freedesktop-docs xorg-docs
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Install multilib packages and codecs? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Installing libraries and databases, including multilib support..."
    pacman -S --asexplicit --noconfirm lib32-acl lib32-apitrace lib32-attr lib32-atk lib32-cairo \
                                       lib32-celt lib32-db lib32-libdbus lib32-elfutils \
                                       lib32-expat lib32-flac lib32-freetype2 lib32-fontconfig \
                                       lib32-gdk-pixbuf2 lib32-gettext lib32-giflib lib32-glib2 \
                                       lib32-glibc lib32-gmp lib32-gnutls lib32-gtk2 lib32-icu \
                                       lib32-harfbuzz lib32-jack lib32-json-c lib32-keyutils \
                                       lib32-krb5 lib32-mpg123 lib32-ncurses lib32-nspr lib32-nss \
                                       lib32-ocl-icd lib32-openal lib32-openssl lib32-p11-kit \
                                       lib32-pango lib32-pcre lib32-pixman lib32-portaudio \
                                       lib32-procps-ng lib32-readline lib32-sdl lib32-sdl_image \
                                       lib32-sdl_ttf lib32-soundtouch lib32-speex lib32-speexdsp \
                                       lib32-sqlite lib32-systemd lib32-libjpeg-turbo lib32-tdb \
                                       lib32-util-linux lib32-v4l-utils lib32-wayland \
                                       lib32-wxgtk2.8 lib32-xcb-util
    pacman -S --asexplicit --noconfirm lib32-lcms lib32-lcms2 lib32-libaio lib32-libao \
                                       lib32-libasyncns lib32-libcap lib32-libcups lib32-libltdl\
                                       lib32-libdrm lib32-ffi lib32-libglade lib32-libice \
                                       lib32-libidn lib32-libldap lib32-libmikmod \
                                       lib32-libmng lib32-libnl lib32-libogg lib32-libpcap \
                                       lib32-libpciaccess lib32-libphobos lib32-libphobos-devel \
                                       lib32-libpng lib32-libsamplerate lib32-libsm lib32-libssh2 \
                                       lib32-libsndfile lib32-libstdc++5 lib32-libtasn1 \
                                       lib32-libtiff lib32-libtxc_dxtn lib32-libusb \
                                       lib32-libvorbis lib32-libx11 lib32-libxau lib32-libxcb \
                                       lib32-libxcomposite lib32-libxcursor lib32-libxdamage \
                                       lib32-libxdmcp lib32-libxext lib32-libxfixes lib32-libxft \
                                       lib32-libxi lib32-libxinerama lib32-libxml2 lib32-libxmu \
                                       lib32-libxrandr lib32-libxrender lib32-libxshmfence \
                                       lib32-libxslt lib32-libxss lib32-libxt lib32-libxtst \
                                       lib32-libxv lib32-libxvmc lib32-libxxff86vm lib32-llvm \
                                       lib32-llvm-libs
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Create a user? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Creating user 'ygoreus'..."
    groupadd anomaly
    useradd -m -g anomaly -G users,wheel,power,storage,network,video -s /bin/zsh ygporeus
    sleep 1s
fi

##----------------------------------------------------------------------------------------
read -p "Set passwords for root and user? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    passwd root
    passwd ygoreus
    sleep 1s
fi





