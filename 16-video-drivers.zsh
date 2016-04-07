#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
    'mesa' 'mesa-vdpau' 'mesa-demos' 'mesa-libgl'
    'glu' 'libvdpau-va-gl' 'libtxc_dxtn'
    'lib32-mesa' 'lib32-mesa-vdpau' 'lib32-mesa-demos'
    'lib32-mesa-libgl' 'lib32-glu' 'lib32-libtxc_dxtn'
    'xf86-video-vesa'
    'xf86-video-intel' 'intel-tbb' 'vulkan-intel' 'libva-intel-driver'
    'lib32-libva-intel-driver'
    'xf86-input-synaptics'
    #'xf86-video-ati'
    #''
    #'xf86-video-nouveau'
    #''
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
