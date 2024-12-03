# GoLang
# GoLang

if type -q go
    set -x GOPATH (go env GOPATH)
    set -x GOROOT (go env GOROOT)

    fish_add_path $GOPATH/bin
    fish_add_path $GOROOT/bin
end

# ASDF/VM
# ASDF/VM

set -x ASDF_HOME $HOME/.asdf

for file in $ASDF_HOME/completions/*.fish
    source $file
end

if not type -q asdf
    git clone https://github.com/asdf-vm/asdf.git $ASDF_HOME 2>/dev/null &
    wait "Installing ASDF/VM"
end


fish_add_path $ASDF_HOME/bin

# Node.js
# Node.js

set -x FNM_HOME $XDG_DATA_HOME/fnm
set -x PNPM_HOME $XDG_DATA_HOME/pnpm

if not test -f $FNM_HOME/fnm
    curl -fsSL https://fnm.vercel.app/install \
        | sh -s -- --skip-shell --install-dir $FNM_HOME 2>/dev/null &
    wait "Installing FNM"
end

if not type -q pnpm
    curl -fsSL https://get.pnpm.io/install.sh \
        | sh -s 2>/dev/null &
    wait "Installing PNPM"
end

fish_add_path $FNM_HOME $PNPM_HOME

# Rust
# Rust

set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x RUSTUP_HOME $XDG_DATA_HOME/rustup

if not type -q rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y 2>/dev/null &
    wait "Installing Rustup"
end

fish_add_path $CARGO_HOME/bin $RUSTUP_HOME/bin
