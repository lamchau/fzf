function __fzf_find_file --description "List files and folders"
    set --local commandline (__fzf_parse_commandline)
    set --local dir $commandline[1]
    set --local fzf_query $commandline[2]

    set --query FZF_FIND_FILE_COMMAND
    or set --local FZF_FIND_FILE_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 's@^\./@@'"

    set --local fzf_command (__fzfcmd)
    set --local query_opts
    if test -n "$fzf_query"
        set query_opts "--query=$fzf_query"
    end

    begin
        eval "$FZF_FIND_FILE_COMMAND | $fzf_command --multi $FZF_DEFAULT_OPTS $FZF_FIND_FILE_OPTS $query_opts" | while read --local s
            set results $results $s
        end
    end

    if test -z "$results"
        commandline --function repaint
        return
    else
        commandline --tokenize ""
    end

    for result in $results
        commandline --insert -- (string escape $result)
        commandline --insert -- " "
    end
    commandline --function repaint
end
