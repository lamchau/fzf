function __fzf_complete_preview --description 'Generate preview for completion widget.
    argv[1] is the currently selected candidate in fzf
    argv[2] is a string containing the rest of the output produced by `complete -Ccmd`
    '

    if test "$argv[2]" = "Redefine variable"
        # show environment variables current value
        set --local evar (string split --fields=1 = -- $argv[1])
        echo $argv[1]$$evar
    else
        echo $argv[1]
    end

    set --local path (string replace "~" $HOME -- $argv[1])

    # list directories on preview
    if test -d "$path"
        eval $FZF_PREVIEW_DIR_CMD (string escape -- $path)
    end

    # show ten lines of non-binary files preview
    if test -f "$path"; and grep -qI . "$path"
        eval $FZF_PREVIEW_FILE_CMD (string escape -- $path)
    end

    # if fish knows about it, let it show info
    type --query "$path" 2>/dev/null; and type --all "$path"

    # show additional data
    echo $argv[2]
end
