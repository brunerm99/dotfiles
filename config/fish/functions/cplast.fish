function cplast --wraps='history | head -2 | tail -1 | wl-copy' --description 'alias cplast=history | head -2 | tail -1 | wl-copy'
  history | head -2 | tail -1 | wl-copy $argv
        
end
