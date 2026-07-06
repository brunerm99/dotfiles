if status is-interactive
	set -U fish_greeting
end

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
export PATH="/home/marchall/.fly/bin:$PATH"

# OpenClaw TUI shortcut: always start a fresh session
function octui --description "Open OpenClaw TUI in a new session"
    /home/marchall/.npm-global/bin/openclaw tui --session tui --message "/new" $argv
end
