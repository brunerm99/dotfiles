# ZSH config

# Powerlevel10k prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh installation
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

# ls
alias ls='exa --group-directories-first'
alias lt='exa -lT --git --group-directories-first --level=2'
alias la='exa -al --git --group-directories-first'
alias l.='exa -al --git --group-directories-first | grep "^\."'
alias lg='exa -al --git --group-directories-first'
alias cls='clear && ls' # the most important alias
alias cla='clear && la'
alias df='df -h'
alias du='du -h'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Git
alias gs='git status'
alias gl='git log --graph --decorate --oneline'
alias gall='git add -A'
alias ga='git add'
alias gp='git push'
alias gc='git commit -m'

# Work / school
alias phaserconf='export PYTHONPATH="$PYTHONPATH:$HOME/documents/chill/ADI_Radar_DSP:$HOME/documents/chill/pyadi-iio"'
alias csuvpn='sudo openconnect --juniper https://secure.colostate.edu'

# Screenshotting 
alias sc="scrot -f $HOME/media/scrot/%Y-%m-%d_%H-%M-%S.png -s -e 'echo \"Saved to: \$f\"'"
alias cpsh="cp ~/media/scrot/$(ls -tr ~/media/scrot/ | tail -1) ."

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
