set -gx FNM_HOME "$XDG_DATA_HOME/fnm"
set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"

if not test -f $FNM_HOME/fnm
    curl -fsSL https://fnm.vercel.app/install \
        | bash -s -- --skip-shell --install-dir $FNM_HOME &>/dev/null &
    wait "Installing FNM"
end

if not test -f $PNPM_HOME/pnpm
    curl -fsSL https://get.pnpm.io/install.sh | bash -s &>/dev/null &
    wait "Installing PNPM"
end

fish_add_path $FNM_HOME
fish_add_path $PNPM_HOME

fnm env --use-on-cd --shell fish | source
