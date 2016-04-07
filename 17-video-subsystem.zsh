#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
    'gst-plugins-base' 'gst-plugins-base-libs' 'gst-plugins-good' 'gst-libav'
    'lib32-gst-plugins-base' 'lib32-gst-plugins-base-libs' 'lib32-gst-plugins-good'
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
