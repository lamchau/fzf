function __fzf_cd --description "Change directory"
    set --local commandline (__fzf_parse_commandline)
    set --local --export dir $commandline[1]
    set --local fzf_query $commandline[2]
    set --local prefix $commandline[3]

    set --local --export FZF_DEFAULT_OPTS (__fzf_defaults \
        "--reverse --scheme=path" \
        "$FZF_ALT_C_OPTS --no-multi --print0")

    set --local --export FZF_DEFAULT_OPTS_FILE

    if set --query FZF_ALT_C_COMMAND
        set --local --export FZF_DEFAULT_COMMAND "$FZF_ALT_C_COMMAND"
    else if type --query fd
        set --local --export FZF_DEFAULT_COMMAND "fd --type directory --follow --hidden --exclude .git . $dir"
    end

    # use --walker when no external command is set
    set --local walker_opts
    if not set --query FZF_DEFAULT_COMMAND
        set walker_opts --walker=dir,follow,hidden --walker-root=$dir
    end

    if set --local result (eval (__fzfcmd) $walker_opts --query=$fzf_query | string split0)
        cd -- $result
        commandline --replace --current-token -- $prefix
    end

    commandline --function repaint
end
