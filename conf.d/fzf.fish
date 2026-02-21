# fzf plugin init — fish 4.x / fzf 0.60+

function _fzf_install --on-event fzf_install
    # Fisher install event — no-op, keybindings are set up below
end

function _fzf_uninstall --on-event fzf_uninstall
    # Erase all fzf keybindings
    bind --user \
        | string replace --filter --regex -- "bind (.+)( '?__fzf.*)" 'bind --erase $1' \
        | source

    # Erase all FZF_* variables (global and universal)
    for var in (set --names | string match --regex '^FZF')
        set --erase $var
        set --erase --universal $var
    end

    functions --erase fzf_key_bindings _fzf_install _fzf_uninstall
end

function fzf_key_bindings --description "Set up fzf keybindings for fish"
    type --query fzf; or return 1

    set --query FZF_DISABLE_KEYBINDINGS
    and test "$FZF_DISABLE_KEYBINDINGS" -eq 1
    and return

    # Default mode
    bind \co __fzf_find_file
    bind \cr __fzf_reverse_isearch
    bind \ec __fzf_cd
    bind \eC '__fzf_cd --hidden'
    bind \eo __fzf_open

    # Vi insert mode
    bind --mode insert \co __fzf_find_file
    bind --mode insert \cr __fzf_reverse_isearch
    bind --mode insert \ec __fzf_cd
    bind --mode insert \eC '__fzf_cd --hidden'
    bind --mode insert \eo __fzf_open

    # Tab completion (opt-in)
    if set --query FZF_COMPLETE
        if not bind --user \t >/dev/null 2>/dev/null
            bind \t __fzf_complete
            bind --mode insert \t __fzf_complete
        end
    end
end

# Run keybinding setup
fzf_key_bindings
