#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
    'bzip2' 'gzip' 'lz4' 'lzo' 'xz' 'zlib' 'gsm' 'libmspack' 'lzop' 'snappy'
    'p7zip' 'unrar' 'zip' 'avfs' 'blosc' 'libewf' 'lrzip' 'mac' 'ucl'
    'ecm-tools' 'rpmextract' 'unzip' 'libzip' 'zziplib' 'cpio' 'unp'
    'unarj' 'arj' 'atool' 'unace' 'libarchive'
    'lib32-bzip2' 'lib32-xz' 'lib32-zlib'
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
