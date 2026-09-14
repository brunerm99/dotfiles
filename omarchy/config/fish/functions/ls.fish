function ls --wraps='eza -l --git --group-directories-first' --wraps='eza -l --group-directories-first' --wraps='eza -l --group-directories-first --git' --description 'alias ls=eza -l --group-directories-first --git'
  eza -l --group-directories-first --git $argv

end
