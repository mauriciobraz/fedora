function obs-studio
    set temp_path "/tmp/_obs-studio-droid.zip"
    set obs_config_dir "$HOME/.config/obs-studio"

    sudo dnf install android-tools blas dlib lapack libavcodec-free-devel \
        libimobiledevice-devel libusbmuxd-devel libusbmuxd-devel obs-studio \
        obs-studio-devel obs-studio-plugin-face-tracker turbojpeg turbojpeg v4l2loopback

    if not test -d $obs_config_dir/plugins/droidcam-obs
        set latest_release_url (curl -s https://api.github.com/repos/dev47apps/droidcam-obs-plugin/releases/latest \
            | jq -r '.assets[] | select(.name | contains("flatpak")) | .browser_download_url')

        wget $latest_release_url -O $temp_path

        mkdir -p $obs_config_dir/plugins
        unzip $temp_path -d /tmp/droidcam-obs

        mv /tmp/droidcam-obs/droidcam-obs/{bin,data} $obs_config_dir/plugins/droidcam-obs
        rm -rf /tmp/droidcam-obs $temp_path
    end

    set plugins_list ("droidcam-obs" "plugin-face-tracker")

    echo (set_color yellow) "DroidCam OBS Plugin installed!" (set_color normal)
    echo \r
    echo (set_color blue) "Config " (set_color green) "=" (set_color brwhite) "$obs_config_dir" (set_color normal)
    echo (set_color blue) "Plugins " (set_color green) "=" (set_color brwhite) "$plugins_list" (set_color normal)
end
