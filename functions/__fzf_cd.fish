function __fzf_cd --description "Change directory"
    set --local commandline (__fzf_parse_commandline)
    set --local dir $commandline[1]
    set --local fzf_query $commandline[2]

    argparse h/hidden -- $argv

    set --local FZF_CD_COMMAND "
        command find -L \"$dir\" -mindepth 1 \\( -path \"$dir\"'*/.*' -o -fstype sysfs -o -fstype devfs -o -fstype devtmpfs \\) -prune \
        -o -type d -print 2> /dev/null | sed 's@^\./@@'"

    set --local FZF_CD_WITH_HIDDEN_COMMAND "
        command find -L \"$dir\" \
        \\( -path '*/.git*' -o -fstype dev -o -fstype proc \\) -prune \
        -o -type d -print 2> /dev/null | sed 1d | cut -b3-"

    set --local find_command
    if set --query _flag_hidden
        set find_command $FZF_CD_WITH_HIDDEN_COMMAND
    else
        set find_command $FZF_CD_COMMAND
    end

    eval "$find_command | "(__fzfcmd)" +m $FZF_DEFAULT_OPTS $FZF_CD_OPTS --query \"$fzf_query\"" | read --local select

    if test -n "$select"
        builtin cd "$select"
        commandline --replace ""
    end

    commandline --function repaint
end
