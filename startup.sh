#!/bin/bash

DOTFILES=$HOME/dotfiles

# Create conf directories if they don't exist
DIRS=("nvim" "polybar" "i3")
for DIR in ${DIRS[@]}; do
	mkdir -p $HOME/.config/$DIR
done

# Link config files
ln -sf $DOTFILES/nvim/init.lua $HOME/.config/nvim/init.lua
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/i3/config $HOME/.config/i3/config
ln -sf $DOTFILES/polybar/config.ini $HOME/.config/polybar/config.ini
ln -sf $DOTFILES/polybar/launch.sh $HOME/.config/polybar/launch.sh
ln -sf $DOTFILES/.xinitrc $HOME/.xinitrc
