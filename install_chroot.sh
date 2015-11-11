#!/usr/bin/env sh
##-- vim: set ai et ts=4 sw=4 ft=sh syn=zsh :


echo -e "\n >>> Enabling pacman\'s essential features..."
sed -i 's|^#Color|Color|' /etc/pacman.conf
sed -i 's|^#VerbosePkgLists|VerbosePkgLists|' /etc/pacman.conf
sed -i -e '/# Misc options/a ILoveCandy' /etc/pacman.conf
sed -i 's|^#UseSyslog|UseSyslog|' /etc/pacman.conf
sed -i 's|^#TotalDownload|TotalDownload|' /etc/pacman.conf
sed -i 's|^#\[multilib\]|\[multilib\]|' /etc/pacman.conf
sed -i -e '/\[multilib\]/{n;d}' /etc/pacman.conf
sed -i -e '/\[multilib\]/a Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf

echo -e "\n >>> Setting the locale..."
sed -i 's|^#en_US|en_US|g' /etc/locale.gen
locale-gen
export LANG=en_US.utf-8

echo -e "\n >>> Setting the system time..."
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc --utc
pacman -Syy
pacman -S ntp

echo -e "\n >>> Setting host and console info..."
echo Charon > /etc/hostname
sed -i 's|localhost|localhost Charon|2' /etc/hosts
echo "KEYMAP=us" > /etc/vconsole.conf
echo "" >> /etc/vconsole.conf

echo -e "\n >>> Installing and setting up wireless tools..."
pacman -S --asexplicit dialog wpa_supplicant wpa_actiond netctl dhcpcd ifplugd ppp

echo -e "\n >>> Installing and configuring the bootloader..."
pacman -S --asexplicit syslinux gptfdisk
syslinux-install_update -iam
cp /boot/syslinux/syslinux.cfg /boot/syslinux/syslinux.cfg.default
disk=$(lsblk -f | grep 'sda2' | awk '{print $3}')
sed -i "s|APPEND.*$|APPEND cryptdevice=/dev/disk/by-uuid/${disk}\:lvm root=/dev/mapper/Charon-rootvol rw elevator=noop|" /boot/syslinux/syslinux.cfg
sed -i "s|INITRD.*$|INITRD ../intel-ucode.img,../initramfs-linux.img|g" /boot/syslinux/syslinux.cfg
sed -i 's|block filesystems|block encrypt lvm2 resume filesystems|' /etc/mkinitcpio.conf
mkinitcpio -p linux
mkinitcpio -p linux-lts









