# ZSH config

# oh-my-zsh 
export ZSH="$HOME/.oh-my-zsh"

export EDITOR="vim"

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
alias df='duf'
alias du='du -h'
alias lsusage='du -h . -d 1'
alias spaceblame='sudo du -h . | 
    sort -hr | 
    head -n 10 | 
    column -t -N "Space,Directory" -o " | "'
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
alias gbv='git branch -v --color=always | grep -v "gone"'
alias gsp='git stash pop'
alias gst='git stash'
alias gss='git stash show'
alias gmwm='git push -o merge_request.create -o merge_request.target=$(git_main_branch) -o merge_request.merge_when_pipeline_succeeds -o merge_request.label="Merge $(git_current_branch) to $(git_main_branch)"'
alias gca='git commit --amend'

# NeoVim
alias vim='nvim'

# Other
alias ispeed='echo "Running internet speed test..." && speedtest-cli --simple --bytes' # internet speed

# Bashly for creating nice bash CLIs
alias bashly='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly'

# Work / school
alias csuvpn='sudo openconnect --juniper https://secure.colostate.edu'

# Libreoffice 
alias draw='libreoffice --draw'
alias writer='libreoffice --writer'
alias impress='libreoffice --impress'

# Exports
export PATH=$PATH:$HOME/.local/bin
export XDG_CONFIG_HOME=$HOME/.config
export WALLPAPER_HOME=$HOME/media/wallpapers
export CRONLOG=$HOME/.local/share/cron/logs

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/marchall/.anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/marchall/.anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/marchall/.anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/marchall/.anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Prompt
eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
