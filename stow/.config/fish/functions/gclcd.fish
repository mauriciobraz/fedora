function gclcd --description 'Clone and cd into a Git repository'
    git clone $argv --recursive
    cd (basename $argv .git)
end
