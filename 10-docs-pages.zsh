#!/usr/bin/zsh
## vim:nonu:ai:et:ts=4:sw=4:
## start of file

[[ $USER == "root" ]] || return 1

## define packages
packages=(
    'arch-wiki-lite' 'arch-wiki-docs' 'bash-docs' 'freedesktop-docs'
    'gcc-docs' 'gconfmm-docs' 'glib2-docs' 'grails-docs' 'groovy-docs'
    'linux-docs' 'linux-grsec-docs' 'linux-lts-docs' 'linux-zen-docs'
    'mygui-docs' 'ogre-docs' 'pangomm-docs' 'php-docs' 'postgresql-docs'
    'python2-docs' 'python-docs' 'python-lxml-docs' 'python-webob-docs'
    'ruby-docs' 'scala-docs' 'zsh-doc' 'flac-doc' 'gap-doc' 'gtk-doc'
    'qt5-doc' 'sqlite-doc' 'vigra-doc' 'sagemath-doc' 'xorg-docs'
    'imagemagick-doc'
)

## define pacman -S options
pacargs=( '--asexplicit' '--needed' '--noconfirm' )

## install all the packages
for _i in "${packages[@]}"; do pacman -S "${pacargs[@]}" -- $_i; done

## end of file
