#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias claude-mem='/home/marchall/.bun/bin/bun "/home/marchall/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'
. "$HOME/.cargo/env"

# Added by flyctl installer
export FLYCTL_INSTALL="/home/marchall/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
