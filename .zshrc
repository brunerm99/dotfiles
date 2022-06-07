# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH Config

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# export PATH=$PATH:~/.emacs.d/bin

# Theme
ZSH_THEME="agnoster"

# Add plugins
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias cls='clear && ls'
alias ls='exa'
alias phaserconf='export PYTHONPATH="$PYTHONPATH:$HOME/documents/chill/ADI_Radar_DSP:$HOME/documents/chill/pyadi-iio"'
alias csuvpn='sudo openconnect --juniper https://secure.colostate.edu'
alias sc="scrot -f $HOME/media/scrot/%Y-%m-%d_%H-%M-%S.png -s -e 'echo \"Saved to: \$f\"'"
alias cpsh="cp ~/media/scrot/$(ls -tr ~/media/scrot/ | tail -1) ."

# Libreoffice stuff
alias draw='libreoffice --draw'
alias writer='libreoffice --writer'
alias impress='libreoffice --impress'

# Flutter stuff
export ANDROID_HOME=/home/marchall/Android/sdk
export CHROME_EXECUTABLE=/sbin/google-chrome-stable

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

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
