function easy-effects
    set temp_path /tmp/easy-effect

    set easy_effects_home "$HOME/.var/app/com.github.wwmm.easyeffects"
    set easy_effects_config "$easy_effects_home/config/easyeffects"

    git clone https://gist.github.com/35b71d014c506edaaba86c0cc540f8b8.git $temp_path 2>/dev/null

    find $temp_path -maxdepth 1 -type f -name "*.json" ! -name "*Input*" \
        -exec mv {} "$easy_effects_config/output" \;

    find $temp_path -maxdepth 1 -type f -name "*.json" -name "*Input*" \
        -exec mv {} "$easy_effects_config/input" \;

    rm -rf $temp_path

    echo (set_color yellow) "Output Presets" (set_color normal)

    for preset in $easy_effects_config/output/*.json
        echo "  " (set_color green) (basename $preset) (set_color normal)
    end

    echo \r
    echo (set_color yellow) "Input Presets" (set_color normal)

    for preset in $easy_effects_config/input/*.json
        echo "  " (set_color green) (basename $preset) (set_color normal)
    end
end
