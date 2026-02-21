function __fzf_reverse_isearch
    test -z "$fish_private_mode"; and history merge

    set --local --export FZF_DEFAULT_OPTS (__fzf_defaults "" \
        "--scheme=history --read0 --print0 --tiebreak=index --toggle-sort=ctrl-r --highlight-line $FZF_REVERSE_ISEARCH_OPTS")
    set --local --export FZF_DEFAULT_OPTS_FILE

    history --null --show-time="%F %H:%M:%S │ " \
        | eval (__fzfcmd) --query '(commandline)' \
        | string split0 \
        | string replace --regex '^.*? │ ' '' \
        | read --local --null result
    and commandline -- $result
    commandline --function repaint
end
