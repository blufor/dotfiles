#!/bin/bash

SRC=$PWD
set -x

mkdir -p ${HOME}/.ssh
mkdir -p ${HOME}/.gnupg
mkdir -p ${HOME}/.config/autostart

cd ${HOME}

rm -rf .bashrc .profile .bash_profile .bash_logout .gitconfig .conkyrc .Xmodmap .Xresources .devilspie bin
ln -nfs ${SRC}/.bashrc
ln -nfs ${SRC}/.bash_profile
ln -nfs ${SRC}/.bash_logout
ln -nfs ${SRC}/.gitconfig
ln -nfs ${SRC}/.conkyrc
ln -nfs ${SRC}/.Xmodmap
ln -nfs ${SRC}/.Xresources
ln -nfs ${SRC}/.devilspie
ln -nfs ${SRC}/bin

cd ${HOME}/.gnupg
rm -f gpg.conf gpg-agent.conf
ln -nfs ${SRC}/.gnupg/gpg.conf
ln -nfs ${SRC}/.gnupg/gpg-agent.conf

cd ${HOME}/.ssh
rm -f authorized_keys config
ln -nfs ${SRC}/.ssh/authorized_keys
ln -nfs ${SRC}/.ssh/config

cd ${HOME}/.config
rm -rf herbstluftwm bash
ln -nfs ${SRC}/.config/herbstluftwm
ln -nfs ${SRC}/.config/bash

cd ${HOME}/.config/autostart
rm -f gnome-keyring-gpg.desktop  gnome-keyring-ssh.desktop
ln -nfs ${SRC}/.config/gnome-keyring-gpg.desktop
ln -nfs ${SRC}/.config/gnome-keyring-ssh.desktop
cd ${SRC}

set +x