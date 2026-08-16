#!/bin/bash

# remove the links in $HOME
rm -f $HOME/.emacs
rm -rf $HOME/.emacs.d

# clean out emacsDir
rm -rf $HOME/Config/dotEmacsV6/emacsDir
mkdir  $HOME/Config/dotEmacsV6/emacsDir

# copy early-init.el to the emacs dir
cp $HOME/Config/dotEmacsV6/early-init.el $HOME/Config/dotEmacsV6/emacsDir/early-init.el

# add the links to $HOME
ln -s $HOME/Config/dotEmacsV6/init.el  $HOME/.emacs
ln -s $HOME/Config/dotEmacsV6/emacsDir  $HOME/.emacs.d
