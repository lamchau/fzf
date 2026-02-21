function __fzf_find_file --description "List files and folders"
    set --local commandline (__fzf_parse_commandline)
    set --local --export dir $commandline[1]
    set --local fzf_query $commandline[2]
    set --local prefix $commandline[3]

    set --local --export FZF_DEFAULT_OPTS (__fzf_defaults \
        "--reverse --walker=file,dir,follow,hidden --scheme=path" \
        "--multi $FZF_CTRL_T_OPTS --print0")

    set --local --export FZF_DEFAULT_COMMAND "$FZF_CTRL_T_COMMAND"
    set --local --export FZF_DEFAULT_OPTS_FILE

    set --local result (eval (__fzfcmd) --walker-root=$dir --query=$fzf_query | string split0)
    and commandline --replace --current-token -- (string join -- ' ' $prefix(string escape --no-quoted -- $result))' '

    commandline --function repaint
end
