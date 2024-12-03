function spicetify
    if not test -d $HOME/.spicetify
        expect -c '
            spawn sh -c "curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh"
            expect "Do you want to install spicetify Marketplace? (Y/n)\r"
            send "Y\r"
            interact
        '
    end

    set -l CONFIG (spicetify -c)

    set -l FLATPAK_ID com.spotify.Client
    set -l FLATPAK_PATH /var/lib/flatpak/app/$FLATPAK_ID
    set -l SPOTIFY_EXTRA /x86_64/stable/active/files/extra/share/spotify

    set -l SPOTIFY_PATH (awk -F' *= *' '/^spotify_path/ {print $2}' $CONFIG)
    set -l PREFS_PATH (awk -F' *= *' '/^prefs_path/ {print $2}' $CONFIG)

    if test -z $SPOTIFY_PATH
        set -l NEW_PATH $FLATPAK_PATH$SPOTIFY_EXTRA
        sed -i "s|^spotify_path\s*=.*|spotify_path = $NEW_PATH|" $CONFIG
    end

    if test -z $PREFS_PATH
        set -l NEW_PREFS_PATH "$HOME/.var/app/$FLATPAK_ID/config/spotify/prefs"
        sed -i "s|^prefs_path\s*=.*|prefs_path = $NEW_PREFS_PATH|" $CONFIG
    end

    echo (set_color yellow) "Spicetify CLI installed and configured!" (set_color normal)
    echo \r
    echo (set_color blue) "Config       " (set_color green) "=" (set_color brwhite) "$CONFIG" (set_color normal)
    echo (set_color blue) "Prefs Path   " (set_color green) "=" (set_color brwhite) "$PREFS_PATH" (set_color normal)
    echo (set_color blue) "Spotify Path " (set_color green) "=" (set_color brwhite) "$SPOTIFY_PATH" (set_color normal)
end
