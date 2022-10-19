# ZSH config

# Powerlevel10k prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh 
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="agnoster"

# Add plugins
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

### Aliases ###

# ls and clear
alias ls='exa -l --git --group-directories-first'
alias ll='exa --group-directories-first'
alias lt='exa -lT --git --group-directories-first --level=2'
alias lt3='exa -lT --git --group-directories-first --level=3'
alias lt4='exa -lT --git --group-directories-first --level=4'
alias la='exa -al --git --group-directories-first'
alias l.='exa -al --git --group-directories-first | grep "^\."'
alias lg='exa -al --git --group-directories-first'
alias cls='clear && ls' # the most important alias
alias cla='clear && la'
alias df='df -h'
alias du='du -h'
alias clc='clear'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias back='cd -'

# Git
alias gs='git status'
alias gl='git log --graph --decorate --oneline'
alias gall='git add -A'
alias ga='git add'
alias gp='git push'
alias gc='git commit -m'
alias gbv='git branch -v'

# Bashly for creating nice bash CLIs
alias bashly='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly'

# Work / school
alias csuvpn='sudo openconnect --juniper https://secure.colostate.edu'

# Libreoffice 
alias draw='libreoffice --draw'
alias writer='libreoffice --writer'
alias impress='libreoffice --impress'

# Flutter 
export ANDROID_HOME=/home/marchall/Android/sdk
export CHROME_EXECUTABLE=/sbin/google-chrome-stable

# Exports
export PATH=$PATH:$HOME/.local/bin
export XDG_CONFIG_HOME=$HOME/.config
export WALLPAPER_HOME=$HOME/media/wallpapers

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/marchall/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/marchall/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/marchall/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/marchall/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Prompt
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
