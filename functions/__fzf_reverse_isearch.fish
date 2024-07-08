function __fzf_reverse_isearch
    history merge
    history -z --show-time="%F %H:%M:%S │ " \
        | eval (__fzfcmd) --read0 --print0 --tiebreak=index --toggle-sort=ctrl-r $FZF_DEFAULT_OPTS $FZF_REVERSE_ISEARCH_OPTS -q '(commandline)' \
        | cut -d'│' -f2- \
        | read -lz result
    and commandline -- $result
    commandline -f repaint
end
