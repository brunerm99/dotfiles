#!/bin/bash

DOTFILES=$HOME/dotfiles

# Create conf directories if they don't exist
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/polybar
mkdir -p $HOME/.config/i3

# Link config files
ln -sf $DOTFILES/nvim/init.lua $HOME/.config/nvim/init.lua
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/i3/config $HOME/.config/i3/config
ln -sf $DOTFILES/polybar/config.ini $HOME/.config/polybar/config.ini
ln -sf $DOTFILES/polybar/launch.sh $HOME/.config/polybar/launch.sh
