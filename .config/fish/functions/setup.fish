function setup
    set -l name $argv[1]
    set -l path $fish_setup_path/$name.fish

    if test -f $path
        source $path
        eval $name
    else
        echo (set_color red) "Error: Script '$name' not found." (set_color normal)
    end
end
