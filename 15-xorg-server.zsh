#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
	'xorg-server' 'xorg-server-common' 'xorg-server-utils' 'xorg-server-xdmx'
	'xorg-xinit' 'xorg-apps' 'xorg-appres' 'xorg-util-macros' 'xorg-utils'
	'xf86-input-synaptics' 'xf86-input-evdev'
)

## xorg.conf
config="/etc/X11/xorg.conf"

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
