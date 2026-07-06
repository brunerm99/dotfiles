function ls --wraps='exa --group-directories-first -l' --wraps='exa --group-directories-first -l --git' --description 'alias ls=exa --group-directories-first -l --git'
  exa --group-directories-first -l --git $argv
        
end
