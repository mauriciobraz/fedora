function setup
    set -l name $argv[1]
    set -l path $fish_setup_path/$name.fish

    if contains -- $argv[1] -A --all
        for script in $fish_setup_path/*.fish
            source $script; and eval (echo (basename $script .fish))
        end

        return
    end

    if test -f $path
        source $path; and eval $name
    else
        echo (set_color red) "Error: Script '$name' not found." (set_color normal)
    end
end
