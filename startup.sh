#!/bin/bash

DOTFILES=$HOME/dotfiles

# Create conf directories if they don't exist
mkdir -p $HOME/.config/nvim

# Link config files
ln -sf $DOTFILES/nvim/init.lua $HOME/.config/nvim/init.lua
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
