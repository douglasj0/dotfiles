# dotfiles
Dotfiles managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Clone configuration repository

Clone this repo into `~/.local/share/chezmoi`:

```
chezmoi init git@github.com:douglasj0/dotfiles.git
```

Converted to gnu stow (wasn't that happy with chezmoi, the principle of least surprise bit me)

Clone this repo into ~/.dotfiles
cd .dotfiles
stow . -n # show what would change
stow .
stow -D . # delete symlinks stow created
