#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
    'btrfs-progs' 'dosfstools' 'f2fs-tools' 'exfat-utils' 'fatsort'
    'hfsprogs' 'shfs-utils' 'squashfs-tools' 'sshfs' 'mtools'
    'reiserfsprogs' 'progsreiserfs' 'e2fsprogs' 'filesystem' 'jfsutils'
    'xfsprogs' 'cifs-utils' 'fuse' 'ntfs-3g' 'curlftpfs'
    'encfs' 'ecryptfs-utils' 'ext4magic' 'fuseiso' 'lib32-e2fsprogs'
    'shfs-utils' 'schroot' 'mtpfs' 'nfs-utils' 'libnfs'
    'nilfs-utils' 's3fs-fuse' 'curlftpfs'
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
