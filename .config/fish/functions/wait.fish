function wait -a title -d "Loading last background job with a spinner"
    count (jobs) >/dev/null
    or return 1

    function __on_exit --on-job-exit %self
        __loading_cleanup
        __loading_kill_children
        functions -e __on_exit
    end

    set -l index 1

    test (count $argv) -gt 1
    and set -l theme $argv[2..-1]
    or set -l theme "⋊>  " \
        " ⋊> " \
        "  ⋊>" \
        " <⋉ " \
        "<⋉  "

    tput civis
    stty -echo
    jobs -l | read -l job tail

    status --is-interactive
    and trap __loading_cleanup INT

    while contains $job (jobs | cut -d\t -f1)
        printf "\r\033[32m%s\033[0m %s" \
            $theme[$index] $title

        tput el

        test $index -eq (count $theme)
        and set index 1
        or set index (math $index + 1)

        sleep 0.1
    end

    functions -e __on_exit
    __loading_cleanup
end


function __loading_cleanup
    tput el
    tput cnorm
    stty echo
    trap INT
end

function __loading_kill_children
    for x in (jobs -p | grep -v 'Process')
        kill $x
    end
end
