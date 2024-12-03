function __fish_setup_complete
    for script in $fish_setup_path/*.fish
        echo (basename $script .fish)
    end
end

complete -f -c setup -a '(__fish_setup_complete)'
complete -f -c setup -s A -l all -d 'Show all setup scripts'
