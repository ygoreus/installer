#!/usr/bin/env sh
##-- vim: set ai et ts=4 sw=4 ft=zsh syn=zsh :
##-- host selector
case $1 in
    "laptop"|"")
        host="Charon"
    ;;
    "desktop")
        host="Kerberos"
    ;;
    *)
        host="Charon"
    ;;
esac

##-- prepare disks for installation
echo -e "\n >>> Erasing disk sda..."
sgdisk --zap-all /dev/sda

echo -e "\n >>> Partition the disk sda..."
parted -a optimal /dev/sda mklabel gpt mkpart primary 2MiB 1024MiB mkpart primary 1024MiB 100% name 1 bootfs name 2 rootfs set 2 lvm on

echo -e "\n >>> encrypt rootfs partition..."
cryptsetup --verbose --cipher=aes-xts-plain64 --key-size=512 --hash=sha512 --iter-time=5000 --use-random --verify-passphrase luksFormat /dev/sda2

echo -e "\n >>> Opening the encrypted partition..."
cryptsetup luksOpen /dev/sda2 lvm

echo -e "\n >>> Setting up logical Volume (lvm)..."
pvcreate /dev/mapper/lvm
vgcreate ${host} /dev/mapper/lvm
lvcreate -L 16G ${host} -n swapvol
lvcreate -L 100G ${host} -n rootvol
lvcreate -l +100%FREE ${host} -n homevol
vgchange -ay

echo -e "\n >>> Formatting the file systems..."
mkfs.ext4 -L BOOTFS /dev/sda1
mkfs.ext4 -L ROOTFS /dev/mapper/${host}-rootvol
mkfs.ext4 -L HOMEFS /dev/mapper/${host}-homevol
mkswap /dev/mapper/${host}-swapvol

echo -e "\n >>> mount file systems to mount points..."
mount /dev/mapper/${host}-rootvol /mnt
mkdir -p /mnt/home /mnt/boot
mount /dev/sda1 /mnt/boot
mount /dev/mapper/${host}-homevol /mnt/home
swapon /dev/mapper/${host}-swapvol
echo -e "\n >>> Done preparing\!"

##-- Install base system
echo -e " >>> Update default mirrorlist... /n"
wget -q 'https://www.archlinux.org/mirrorlist/?country=US' -O /etc/pacman.d/mirrorlist.US
sed -i 's|^#S|S|g' /etc/pacman.d/mirrorlist.US
rankmirrors -n 8 mirrorlist.US > mirrorlist
pacman -Syy

echo -e " >>> Install the base system and development tools...\n"
pacstrap -i /mnt base base-devel bash-completion linux-lts

echo -e " >>> Generating the file system table (fstab)..."
genfstab -U -p /mnt >> /mnt/etc/fstab
echo -e "\n >>> Setting locale for new system...\n"
locale | head -n -1 > /mnt/etc/locale.conf
echo -e "\n >>> Ready for chroot.\n"


