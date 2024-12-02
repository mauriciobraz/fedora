if status --is-interactive
    if not functions -q fisher
        set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
        curl -fsSL https://git.io/fisher | source; and fisher update

        tide configure --auto --style=Lean --transient=Yes \
            --show_time=No --lean_prompt_height='Two lines' \
            --prompt_connection=Disconnected \
            --prompt_colors='True color' \
            --prompt_spacing=Compact \
            --icons='Few icons'


        exit
    end
end

alias . 'cd .'

alias .1 '..'
alias .. 'cd ..'

alias .2 '../..'
alias ... 'cd ../..'

alias .3 '../../..'
alias .... 'cd ../../..'

alias .4 '../../../..'
alias ..... 'cd ../../../..'

if type -q micro
    set -x EDITOR micro
    set -x VISUAL micro
end

set -U FZF_COMPLETE 1
set -U fish_greeting

for FILE in $fish_aliases_path/*
    test -f $FILE; and source $FILE
end

type -q pnpm; and autocomplete --name pnpm --exec "pnpm completion fish"
type -q fnm; and autocomplete --name fnm --exec "fnm completions --shell fish"
