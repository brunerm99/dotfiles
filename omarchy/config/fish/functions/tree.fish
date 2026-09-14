function tree --description 'List a directory tree, respecting gitignore'
    eza --tree --git-ignore $argv
end
