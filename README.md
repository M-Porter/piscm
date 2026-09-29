# piscm

A fish shell implementation of https://github.com/scmbreeze/scm_breeze.

## Install

Install with fisher:

```fish
fisher install M-Porter/piscm
```

## Aliases

The plugin defines these aliases automatically:

- `gs` -> `piscm_git_status_shortcuts`
- `gb` -> `piscm_git_branch_shortcuts`
- `ga` -> `piscm_git_add_shortcuts`
- `gco` -> `piscm_git_checkout_shortcuts`
- `gc` -> `piscm_git_commit_shortcuts`
- `gd` -> `piscm_git_diff_shortcuts`
- `ge` -> `piscm_exec_expand_args`

## Disable the automatic aliases

To use your own aliases, disable the automatic aliases first. Set `PISCM_AUTO_ALIAS` to `off` in your `config.fish`:

```fish
set -gx PISCM_AUTO_ALIAS off
```

## Available functions

**Git functions**
- `piscm_git_status_shortcuts`
- `piscm_git_branch_shortcuts`
- `piscm_git_add_shortcuts`
- `piscm_git_checkout_shortcuts`
- `piscm_git_commit_shortcuts`
- `piscm_git_diff_shortcuts`

**Piscm functions**
- `piscm_exec_expand_args`
- `piscm_expand_args`

## Extending piscm

Both helpers turn numbers and ranges like `1`, `2-4` into the files or branches listed by the last `gs` or `gb` run. Any other argument passes through unchanged. A number that matches an existing file name is also left as is.

`piscm_exec_expand_args` expands the arguments and runs them as a command. It is aliased to `ge` by default. Use it for quick one-off shortcuts:

```fish
ge code 1 3-5   # opens the files for shortcuts 1, 3, 4 and 5
```

`piscm_expand_args` prints the expanded arguments one per line. Use it to write your own shortcut functions:

```fish
function grs
    git restore --staged (piscm_expand_args $argv)
end
```

`piscm_exec_expand_args` uses `command`, so it only runs external programs. To wrap a fish function or alias, call `piscm_expand_args` directly as shown above.

## Whats with the name?

A crappy play on words of the latin word for fish, piscis. Piscis. Piscm. Piscis. Piscm. Idk. 🧿👄🧿
