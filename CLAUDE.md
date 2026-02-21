# CLAUDE.md

Fish shell plugin that integrates fzf (command-line fuzzy finder). Fork of [jethrokuan/fzf](https://github.com/jethrokuan/fzf), modernized for Fish 4.x and fzf 0.60+.

## Project structure

```
conf.d/fzf.fish              # Plugin init: Fisher lifecycle events, keybinding setup
functions/
  __fzfcmd.fish               # __fzfcmd (fzf/fzf-tmux dispatch), __fzf_defaults (option builder)
  __fzf_parse_commandline.fish # Tokenize current commandline into dir, query, prefix
  __fzf_find_file.fish         # Ctrl-O: find files/dirs
  __fzf_cd.fish                # Alt-C: cd into directories (supports fd fallback)
  __fzf_reverse_isearch.fish   # Ctrl-R: search command history
  __fzf_open.fish              # Alt-O: open files in $EDITOR
  __fzf_complete_preview.fish  # Preview helper for completion widget
```

## Language and conventions

- All code is **Fish shell** (`*.fish`). No POSIX sh, no bash.
- Use `--long-options` over short flags (e.g., `set --local` not `set -l`).
- Use Fish 4.x builtins: `path normalize`, `path dirname`, `path is`, `commandline --tokens-expanded`, `string split0`, `string match --regex`.
- Functions are lazy-loaded by Fish's autoload (`functions/` directory).
- `conf.d/fzf.fish` runs at shell startup via Fisher's convention.

## Key patterns

- **`__fzf_defaults`**: Centralizes fzf option assembly. Prepends sensible defaults, reads `$FZF_DEFAULT_OPTS_FILE`, appends `$FZF_DEFAULT_OPTS` and per-function opts. All functions use this instead of building option strings manually.
- **`--walker`**: Functions use fzf's built-in `--walker=file,dir,follow,hidden` and `--walker-root=` instead of external find/fd commands. External commands are opt-in via `FZF_CTRL_T_COMMAND`, `FZF_ALT_C_COMMAND`, etc.
- **Null-delimited I/O**: All functions use `--print0` / `string split0` / `--read0` for safe handling of paths with spaces/special characters.
- **`FZF_DEFAULT_OPTS_FILE` override**: Functions set `set --local --export FZF_DEFAULT_OPTS_FILE` (empty) to prevent the user's opts file from conflicting with per-function options. The file's contents are already merged by `__fzf_defaults`.

## Testing

There are no unit tests. CI (`.github/workflows/ci.yml`) installs Fish 4.x + latest fzf on Ubuntu, then verifies:

- Fisher install succeeds
- All keybindings are registered (`bind --user | string match __fzf`)
- All expected functions exist
- Removed functions (`__fzf_get_dir`) do not exist

Run CI checks locally:

```fish
# Verify functions load
for fn in __fzf_find_file __fzf_reverse_isearch __fzf_cd __fzf_open __fzf_parse_commandline __fzfcmd __fzf_defaults
    type --query $fn; or echo "MISSING: $fn"
end

# Verify keybindings
bind --user | string match --entire __fzf
```

## Git conventions

- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/): `type(scope): description`
- Types: `feat`, `fix`, `refactor`, `style`, `chore`, `build`, `docs`
- Scopes match function names without `__fzf_` prefix: `cd`, `open`, `find-file`, `reverse-isearch`, `parse-commandline`, `fzfcmd`, `complete-preview`, `init`

## Upstream relationship

- **origin**: `lamchau/fzf` (this fork)
- **upstream**: `jethrokuan/fzf` (original, unmaintained)
- `main` is based on `upstream/master` with modernization commits stacked on top
