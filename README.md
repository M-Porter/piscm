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

## Disable the automatic aliases

To use your own aliases, disable the automatic aliases first. Set `PISCM_AUTO_ALIAS` to `off` in your `config.fish`:

```fish
set -gx PISCM_AUTO_ALIAS off
```

## Available commands

- `piscm_git_status_shortcuts`
- `piscm_git_branch_shortcuts`
- `piscm_git_add_shortcuts`
- `piscm_git_checkout_shortcuts`
- `piscm_git_commit_shortcuts`

## Whats with the name?

A crappy play on words of the latin word for fish, piscis. Piscis. Piscm. Piscis. Piscm. Idk. 🧿👄🧿
