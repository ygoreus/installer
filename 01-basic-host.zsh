#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:fenc=utf8:

[[ $USER == "root" ]] || return 1

## options
host=${1:-lemu}

## copy pacman.conf and update
[[ -f /etc/pacman.d/mirrorlist ]] && \
    mv -iv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.org
[[ -f /root/install/files/etc/pacman.d/mirrorlist ]] && \
    cp -iv /root/install/files/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
[[ -f /etc/pacman.conf && -d /etc/default ]] && \
    mv -iv /etc/pacman.conf /etc/default/pacman-default.conf
[[ -f /root/install/files/etc/pacman.conf ]] && \
    cp -iv /root/install/files/etc/pacman.conf /etc/pacman.conf
pacman -Syy

## time/date/locale
sed -i 's|^#en_US|en_US|' /etc/locale.gen 1>/dev/null | locale-gen 1>/dev/null
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc --utc
#timedatectl set-timezone "America/New_York"
#timedatectl set-local-rtc 0
#timedatectl set-ntp on

## set the hostname
hostnamectl set-hostname "${host}"
hostnamectl set-location "6th Circle, Hell"
sed -i 's|localhost|localhost '"${host}"'|2' /etc/hosts

## Install boot filesystem support
packages=( 'dosfstools' 'btrfs-progs' 'mtools' 'f2fs-tools' )
for _i in "${packages[@]}" ; do pacman -S --asexplicit --needed --noconfirm $_i ; done

## copy kernel config, init config, and build init image
[[ -f /root/install/files/etc/vconsole.conf ]] && \
    cp -iv /root/install/files/etc/vconsole.conf /etc/vconsole.conf
[[ -f /root/install/files/etc/mkinitcpio.conf ]] && \
    cp -iv /root/install/files/etc/mkinitcpio.conf /etc/mkinitcpio.conf
mkinitcpio -p linux

