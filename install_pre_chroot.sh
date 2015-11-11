#!/usr/bin/env sh
##-- prepare disks for installation


##-- Install base system
echo -e " >>> Update default mirrorlist... /n"
wget -q 'https://www.archlinux.org/mirrorlist/?country=US' -O /etc/pacman.d/mirrorlist.US
sed -i 's|^#S|S|g' /etc/pacman.d/mirrorlist.US
rankmirrors -n 8 mirrorlist.US > mirrorlist
pacman -Syy
echo -e " >>> Done\!"

echo -e " >>> Install the base system and development tools...\n"
pacstrap -i /mnt base base-devel bash-completions
echo -e "\n >>> Done\!"

echo -e " >>> Generating the file system table (fstab)..."
genfstab -U -p /mnt >> /mnt/etc/fstab
echo -e "\n >>> Done\!\n >>> Setting locale for new system...\n"
locale | head -n -1 > /mnt/etc/locale.conf
echo -e "\n >>> Done\!\n >>> Ready for chroot.\n"

