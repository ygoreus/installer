#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:ft=zsh:syn=zsh:fenc=utf8:

[[ $(efivar -l 2>/dev/null | wc -l) -gt "0" ]] || return 1
[[ $USER == "root" ]] || return 1

## Install packages
packages=(
    'intel-ucode' 'linux' 'linux-headers' 'linux-firmware'
    'linux-api-headers' 'util-linux' 'systemd' 'efibootmgr'
)

pacargs=( '--asexplicit' '--needed' '--noconfirm' )

for _i in "${packages[@]}" ; do pacman -S "${pacargs[@]}" $_i ; done

## Install the bootloader
bootctl install

## Copy the bootloader files to necessary location
loader="/root/install/files/boot/loader/loader.conf"
config="/root/install/files/boot/loader/entries/a.conf"

[[ -d /boot/loader ]] && cp -iv $loader /boot/loader/loader.conf
[[ -d /boot/loader/entries ]] && cp -iv $config /boot/loader/entries/a.conf

