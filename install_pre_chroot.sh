#!/usr/bin/env sh
##-- vim: set ai et ts=4 sw=4 ft=zsh syn=zsh :
##-- host selector
##----------------------------------------------------------------------------------------
case $1 in
    "laptop"|"")
        host="Charon"
    ;;
    "desktop")
        host="Kerberos"
    ;;
    *)
        host=$1
    ;;
esac
##----------------------------------------------------------------------------------------
wget -q --tries=10 --timout=2 --spider https://www.archlinux.org/
if [[ $? -eq 0 ]]; then
    echo ""
else
    exit 1
fi
##----------------------------------------------------------------------------------------
read -p "Erase disk sda? [y/N] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Erasing disk sda..."
    sgdisk --zap-all /dev/sda
fi
##----------------------------------------------------------------------------------------
read -p "Partition sda with 1 root and 1 boot? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Partitioning disk sda..."
    parted -a optimal /dev/sda mklabel gpt mkpart primary 2MiB 1024MiB mkpart primary 1024MiB 100% name 1 bootfs name 2 rootfs set 2 lvm on
fi
##----------------------------------------------------------------------------------------
read -p "Encrypt root partition? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> encrypting rootfs partition..."
    cryptsetup --verbose --cipher=aes-xts-plain64 --key-size=512 --hash=sha512 --iter-time=5000 --use-random --verify-passphrase luksFormat /dev/sda2
    echo -e "\n >>> Opening the encrypted partition..."
    cryptsetup luksOpen /dev/sda2 lvm
fi
##----------------------------------------------------------------------------------------
read -p "Set up lvm? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Setting up logical Volume (lvm)..."
    pvcreate /dev/mapper/lvm
    vgcreate ${host} /dev/mapper/lvm
    lvcreate -L 16G ${host} -n swapvol
    lvcreate -L 100G ${host} -n rootvol
    lvcreate -l +100%FREE ${host} -n homevol
    vgchange -ay
fi
##----------------------------------------------------------------------------------------
read -p "Format the partitions as ext4? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> Formatting the partitions..."
    mkfs.ext4 -L BOOTFS /dev/sda1
    mkfs.ext4 -L ROOTFS /dev/mapper/${host}-rootvol
    mkfs.ext4 -L HOMEFS /dev/mapper/${host}-homevol
    mkswap /dev/mapper/${host}-swapvol
fi
##----------------------------------------------------------------------------------------
read -p "Mount the partitions to respective mount points? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e "\n >>> mount file systems to mount points..."
    mount /dev/mapper/${host}-rootvol /mnt
    mkdir -p /mnt/home /mnt/boot
    mount /dev/sda1 /mnt/boot
    mount /dev/mapper/${host}-homevol /mnt/home
    swapon /dev/mapper/${host}-swapvol
fi
##----------------------------------------------------------------------------------------
read -p "Update the pacman mirrorlist? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e " >>> Updating default mirrorlist... /n"
    wget -q 'https://www.archlinux.org/mirrorlist/?country=US' -O /etc/pacman.d/mirrorlist.US
    sed -i 's|^#S|S|g' /etc/pacman.d/mirrorlist.US
    rankmirrors -n 8 mirrorlist.US > mirrorlist
    pacman -Syy
fi
##----------------------------------------------------------------------------------------
read -p "Install base system? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e " >>> Installing the base system and development tools..."
    pacstrap -i /mnt base base-devel bash-completion linux-lts
fi
##----------------------------------------------------------------------------------------
read -p "? [y/N] " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping..."
    sleep 1s
else
    echo -e " >>> Generating the file system table (fstab)..."
    genfstab -U -p /mnt >> /mnt/etc/fstab
    echo -e "\n >>> Setting locale for new system..."
    locale | head -n -1 > /mnt/etc/locale.conf
    echo -e "\n >>> Ready for chroot."
fi
##----------------------------------------------------------------------------------------

