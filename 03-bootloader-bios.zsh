#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:ft=zsh:syn=zsh:fenc=utf8:

[[ $USER == "root" ]] || return 1

## Install packages
packages=(
    'intel-ucode' 'linux' 'linux-headers' 'linux-firmware'
    'linux-api-headers' 'util-linux' 'systemd' 'efibootmgr'
    'syslinux' 'gptfdisk'
)

pacargs=( '--asexplicit' '--needed' '--noconfirm' )

for _i in "${packages[@]}" ; do pacman -S "${pacargs[@]}" $_i ; done

## Install the bootloader
syslinux-install_update -iam

## Copy the bootloader files to necessary location
botimg="/root/install/files/boot/syslinux/boot.png"
config="/root/install/files/boot/syslinux/syslinux.cfg"

[[ -d /boot/syslinux ]] && cp -iv $botimg /boot/syslinux/boot.png
[[ -d /boot/syslinux ]] && cp -iv $config /boot/syslinux/syslinux.cfg

