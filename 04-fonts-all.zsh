#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
 # regular fonts
packages=(
    'ttf-bitstream-vera' 'ttf-cheapskate' 'ttf-dejavu' 'gsfonts'
    'ttf-freefont' 'ttf-linux-libertine' 'ttf-oxygen' 'ttf-inconsolata'
    'opendesktop-fonts' 'ttf-anonymous-pro' 'ttf-droid' 'ttf-ionicons'
    'ttf-fira-mono' 'ttf-fira-sans' 'ttf-gentium' 'gnu-free-fonts'
    'ttf-liberation' 'ttf-linux-libertine-g' 'ttf-symbola' 'ttf-ubuntu-font-family'
    'fontconfig' 'freetype2' 'terminus-font'
)
 # xorg font rendering packages
packages+=(
    'xorg-font-util' 'xorg-font-utils' 'xorg-fonts-100dpi' 'xorg-fonts-75dpi'
    'xorg-fonts-alias' 'xorg-fonts-encodings' 'xorg-fonts-misc' 'xorg-xlsfonts'
    'xorg-xfd' 'xorg-fonts-type1' 'xorg-fonts-cyrillic'
)
 # symbolic (kanji, mandarin, etc) fonts
packages+=(
    'ttf-arphic-ukai' 'ttf-arphic-uming' 'ttf-baekmuk' 'ttf-freebanglafont'
    'ttf-hannom' 'ttf-indic-otf' 'ttf-junicode' 'ttf-khmer' 'ttf-mph-2b-damase'
    'ttf-sazanami' 'ttf-tibetan-machine' 'ttf-tlwg' 'ttf-ubraille' 'ttf-hanazono'
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
