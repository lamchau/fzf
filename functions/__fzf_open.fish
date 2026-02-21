function __fzf_open --description "Find and open files in \$EDITOR"
    set --local commandline (__fzf_parse_commandline)
    set --local --export dir $commandline[1]
    set --local fzf_query $commandline[2]

    set --local preview_cmd
    if set --query FZF_ENABLE_OPEN_PREVIEW
        set preview_cmd "--preview-window=right:wrap --preview='fish -c \"__fzf_complete_preview {}\"'"
    end

    set --local --export FZF_DEFAULT_OPTS (__fzf_defaults \
        "--reverse --walker=file,dir,follow,hidden --scheme=path" \
        "--multi $preview_cmd $FZF_OPEN_OPTS --print0")

    set --local --export FZF_DEFAULT_COMMAND "$FZF_OPEN_COMMAND"
    set --local --export FZF_DEFAULT_OPTS_FILE

    set --local result (eval (__fzfcmd) --walker-root=$dir --query=$fzf_query | string split0)

    if test -n "$result"
        set --local open_cmd "$EDITOR"
        if test -z "$open_cmd"
            echo "fzf: \$EDITOR is not set" >&2
            commandline --function repaint
            return 1
        end
        commandline "$open_cmd "(string escape --no-quoted -- $result)
        commandline --function execute
    end

    commandline --function repaint
end
