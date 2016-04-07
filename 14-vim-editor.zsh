#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
    'vim' 'vim-runtime' 'vim-spell-en' 'vim-airline' 'vim-fugitive'
    'vim-nerdtree' 'vim-syntastic' 'vim-systemd' 'vimpager'
    'aspell' 'aspell-en' 'hunspell' 'hunspell-en' 'hyphen' 'hyphen-en'
    'libmythes' 'mythes-en' 'psiconv'
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
