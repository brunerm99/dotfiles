if status is-interactive
    workbench
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
fish_add_path /Users/marshall/.pixi/bin
