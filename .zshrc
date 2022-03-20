# ZSH Config

# Path to your oh-my-zsh installation.
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

# Aliases
alias cls='clear && ls'
alias phaserconf='export PYTHONPATH="$PYTHONPATH:$HOME/documents/chill/ADI_Radar_DSP:$HOME/documents/chill/pyadi-iio"'
alias draw='libreoffice --draw'
alias writer='libreoffice --writer'
alias csuvpn='sudo openconnect --juniper https://secure.colostate.edu'
alias sc="scrot -f $HOME/media/scrot/%Y-%m-%d_%H-%M-%S.png -s -e 'echo \"Saved to: \$f\"'"

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

