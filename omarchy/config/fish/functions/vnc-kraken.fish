function vnc-kraken --description 'Open the Kraken desktop over Tailscale'
    uwsm-app -- vncviewer "$HOME/.config/tigervnc/kraken.tigervnc" $argv
end
