#!/bin/bash

SRC=$PWD

which rsync >/dev/null || exit 1

inst () {
  rsync -aq $*
}

echo -n "Removing old dotfiles... "
cd ${HOME} && rm -rf .bash .bashrc .profile .bash_profile .bash_logout .gitconfig .conkyrc .xinitrc .Xmodmap .Xresources .devilspie bin
echo "done."

echo -n "Installing new dotfiles... "
inst ${SRC}/bashrc ${HOME}/.bashrc
inst ${SRC}/bash_profile ${HOME}/.bash_profile
inst ${SRC}/bash_logout ${HOME}/.bash_logout
inst ${SRC}/conkyrc ${HOME}/.conkyrc
inst ${SRC}/gitconfig ${HOME}/.gitconfig
inst ${SRC}/Xmodmap ${HOME}/.Xmodmap
inst ${SRC}/Xresources ${HOME}/.Xresources
inst ${SRC}/bash/ ${HOME}/.bash
inst ${SRC}/bin/ ${HOME}/bin
inst ${SRC}/devel/ ${HOME}/devel
inst ${SRC}/devilspie/ ${HOME}/.devilspie
inst ${SRC}/gnupg/ ${HOME}/.gnupg
inst ${SRC}/ssh/ ${HOME}/.ssh
inst ${SRC}/config/ ${HOME}/.config
ln -s ${HOME}/.config/herbstluftwm/session.sh ${HOME}/.xinitrc
echo "done."

