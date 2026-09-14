# Workbench shell on Omarchy.
set -gx OMARCHY_PATH /usr/share/omarchy
fish_add_path --append --path ~/.local/bin ~/.local/share/mise/shims ~/.cargo/bin

if status is-interactive
    set -g fish_greeting
    mise activate fish | source
    starship init fish | source
    workbench
    # Alt+S adds/removes sudo on the current command.
    bind alt-s 'fish_commandline_prepend sudo'
end
