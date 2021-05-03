# tenv

## Install

```bash
$ brew tap CODEYA/tap
$ brew install tenv
```

### zsh

```bash
# Shell: zsh
$ echo 'eval "$(tenv init)"' >> ~/.zshrc
```

### bash

```bash
$ echo 'eval "$(tenv init)"' >> ~/.profile
```

## Configure

Create a `.terminal-config` file in your directory.

| key              | value                  | example |
|------------------|------------------------|---------|
| ITERM2_PROFILE   | Profile name of iTerm2 | myprof  |
| ITERM2_TAB_COLOR | Hex triplet            | 0099CC  |
| ITERM2_TITLE     | Title of iTerm2        | myproj  |
| ITERM2_BADGE     | Badge of iTerm2        | myproj  |

## Supports

### OS

- macOS

### Shell

- zsh
- bash

### Terminal

- iTerm2

## License

MIT

## Reference

- [iTerm2](https://iterm2.com/index.html)
    - [iTerm2 Proprietary Escape Codes](https://iterm2.com/documentation-escape-codes.html)
    - [iTerm2 Badges](https://iterm2.com/documentation-badges.html)
