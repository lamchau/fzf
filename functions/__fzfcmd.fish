function __fzf_defaults --description "Build fzf options with defaults, opts file, and user overrides"
    # Usage: __fzf_defaults "prepend opts" "append opts"
    # Result: --height 40% --min-height=20+ --bind=ctrl-z:ignore $prepend $FZF_DEFAULT_OPTS_FILE $FZF_DEFAULT_OPTS $append
    test -n "$FZF_TMUX_HEIGHT"; or set --local FZF_TMUX_HEIGHT 40%
    string join ' ' -- \
        "--height $FZF_TMUX_HEIGHT --min-height=20+ --bind=ctrl-z:ignore" $argv[1] \
        (test -r "$FZF_DEFAULT_OPTS_FILE"; and string join -- ' ' <$FZF_DEFAULT_OPTS_FILE) \
        $FZF_DEFAULT_OPTS $argv[2..-1]
end

function __fzfcmd --description "Return the fzf command, with tmux wrapper if configured"
    test -n "$FZF_TMUX_HEIGHT"; or set --local FZF_TMUX_HEIGHT 40%
    if test -n "$FZF_TMUX_OPTS"
        echo "fzf-tmux $FZF_TMUX_OPTS -- "
    else if test "$FZF_TMUX" = 1
        echo "fzf-tmux -d$FZF_TMUX_HEIGHT -- "
    else
        echo fzf
    end
end
