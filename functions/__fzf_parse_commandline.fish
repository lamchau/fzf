function __fzf_parse_commandline --description 'Parse the current command line token and return dir, fzf_query, prefix'
    set --local fzf_query ''
    set --local prefix ''
    set --local dir '.'

    # fish 4.x: --tokens-expanded handles ~ and $var expansion
    set --local commandline_token (commandline --current-token --tokens-expanded)

    if test -n "$commandline_token"
        # Extract -option= prefix if present (e.g., --file=path)
        if string match --quiet --regex -- '^-[^\s=]+=|^-(?!-)\S' "$commandline_token"
            set prefix (string match --regex -- '^-[^\s=]+=|^-(?!-)\S' "$commandline_token")
            set commandline_token (string replace -- "$prefix" '' "$commandline_token")
        end

        # Normalize the path and find the longest existing directory
        set fzf_query (path normalize -- $commandline_token)
        set dir $fzf_query
        while not path is -d -- $dir
            set dir (path dirname -- $dir)
        end

        # Split dir from query
        if not string match --quiet -- '.' $dir; or string match --quiet --regex -- '^\./|^\.$' $fzf_query
            string match --quiet --regex -- '^'(string escape --style=regex -- $dir)'/?(?<fzf_query>[\s\S]*)' $fzf_query
        end
    end

    string escape --no-quoted -- "$dir" "$fzf_query" "$prefix"
end
