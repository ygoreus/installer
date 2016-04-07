#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
    'alsa-firmware' 'alsa-lib' 'alsa-plugins' 'alsa-tools' 'alsa-utils' 'libao'
    'pulseaudio' 'pulseaudio-alsa' 'libpulse' 'libcanberra-pulse' 'pulseaudio-lirc'
    'libcanberra' 'pavucontrol'
    'lib32-alsa-lib' 'lib32-alsa-plugins' 'lib32-libcanberra-pulse'
    'lib32-libpulse' 'lib32-libcanberra'
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
