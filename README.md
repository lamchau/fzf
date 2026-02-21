# fzf

Integrate [fzf](https://github.com/junegunn/fzf) (command-line fuzzy finder) functionality into [Fish](https://github.com/fish-shell/fish-shell). Includes handy functions to:

- complete commands via <kbd>Tab</kbd>
- search command history
- find and `cd` into sub-directories
- find and open files

All functions:

- are lazily-loaded to keep shell startup time down
- use fzf's `--walker` for fast file/directory traversal
- support `FZF_DEFAULT_OPTS_FILE` for persistent configuration

## Installation

### System Requirements

- [fzf](https://github.com/junegunn/fzf) >= `0.60`
- [Fish](https://github.com/fish-shell/fish-shell) >= `4.0`

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install lamchau/fzf
```

Keybindings are set up automatically via Fisher's event lifecycle. To re-apply them manually:

```fish
fzf_key_bindings
```

## Keybindings

| Key           | Function                          | Description                                      |
| ------------- | --------------------------------- | ------------------------------------------------ |
| Ctrl-O        | `__fzf_find_file`                 | Find a file or directory                         |
| Ctrl-R        | `__fzf_reverse_isearch`           | Search through command history                   |
| Alt-C         | `__fzf_cd`                        | cd into sub-directories (recursively searched)   |
| Alt-Shift-C   | `__fzf_cd --hidden`               | cd into sub-directories, including hidden ones   |
| Alt-O         | `__fzf_open`                      | Open a file in `$EDITOR`                         |

All bindings are set in both default and vi insert modes.

You can disable keybindings altogether:

```fish
set --global FZF_DISABLE_KEYBINDINGS 1
```

> **Note:** On macOS, <kbd>Alt</kbd>+<kbd>C</kbd> (Option-C) types c by default. In iTerm2, you can send the right escape sequence with <kbd>Esc</kbd>+<kbd>C</kbd>. If you configure the option key to act as +Esc (iTerm2 Preferences > Profiles > Default > Keys > Left option key acts as: > Esc+), then <kbd>Alt</kbd>+<kbd>C</kbd> will work for `fzf` as documented.

## Variables

### Source commands

Override the file listing command for each function. The variable `$dir` is available as the search root.

| Variable              | Function        | Example                                       |
| --------------------- | --------------- | --------------------------------------------- |
| `FZF_CTRL_T_COMMAND`  | Ctrl-O (find)   | `set --global FZF_CTRL_T_COMMAND "fd --type f . \$dir"` |
| `FZF_ALT_C_COMMAND`   | Alt-C (cd)      | `set --global FZF_ALT_C_COMMAND "fd --type d . \$dir"`  |
| `FZF_OPEN_COMMAND`    | Alt-O (open)    | `set --global FZF_OPEN_COMMAND "fd --type f . \$dir"`    |

### Extra fzf options

Pass additional options to fzf for each function.

| Variable                   | Function        | Example                                               |
| -------------------------- | --------------- | ----------------------------------------------------- |
| `FZF_DEFAULT_OPTS`         | All commands    | `set --global FZF_DEFAULT_OPTS "--height 40%"`        |
| `FZF_DEFAULT_OPTS_FILE`    | All commands    | Path to a file containing default fzf options          |
| `FZF_CTRL_T_OPTS`          | Ctrl-O (find)   | `set --global FZF_CTRL_T_OPTS "--reverse --inline-info"` |
| `FZF_ALT_C_OPTS`           | Alt-C (cd)      | Similar to above                                       |
| `FZF_REVERSE_ISEARCH_OPTS` | Ctrl-R (history)| Similar to above                                       |
| `FZF_OPEN_OPTS`            | Alt-O (open)    | Similar to above                                       |

### Other settings

| Variable                  | Description                                          | Example                                     |
| ------------------------- | ---------------------------------------------------- | ------------------------------------------- |
| `FZF_TMUX`                | Use fzf-tmux instead of fzf                          | `set --global FZF_TMUX 1`                   |
| `FZF_TMUX_OPTS`           | Options passed to fzf-tmux                           | `set --global FZF_TMUX_OPTS "-p 80%"`       |
| `FZF_ENABLE_OPEN_PREVIEW` | Enable file preview in the open command               | `set --global FZF_ENABLE_OPEN_PREVIEW 1`    |
| `FZF_PREVIEW_FILE_CMD`    | Command for file preview                              | `set --global FZF_PREVIEW_FILE_CMD "head -n 10"` |
| `FZF_PREVIEW_DIR_CMD`     | Command for directory preview                         | `set --global FZF_PREVIEW_DIR_CMD "ls"`     |
| `FZF_COMPLETE`            | Enable fzf tab completion (opt-in)                    | `set --global FZF_COMPLETE 1`               |

## Tab Completions

This package ships with a `fzf` widget for tab completions. To enable, set `FZF_COMPLETE`:

```fish
set --global FZF_COMPLETE 1
```

## Uninstall

```console
fisher remove lamchau/fzf
```

Fisher's event lifecycle will automatically clean up bindings, variables, and functions.

## Alternatives

- [fzf.fish](https://github.com/patrickf3139/fzf.fish) is a newer fzf plugin with similar features. It includes functions for searching git log, git status, and browsing shell variables.
- The `fzf` utility ships with its [own out-of-the-box Fish integration](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish). What sets this package apart is that it has tab completions. They are not compatible so use one or the other.

## License

[MIT](LICENSE.md)
