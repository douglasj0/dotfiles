# my dotfiles
These are my dotfiles supporting macos/linux/*bsd.  Currently they are managed via
GNU Stow (previously chezmoi, but I wasn't happy with it, the principle of least
surprise bit me).

## GNU Stow
https://www.gnu.org/software/stow/

Initially setup with all dotfiles into the top level of the .dotfiles/ directory.
After running that way for some time, I did some investigation on optimizing the
configuration around packages and have converted to that.

## How to use
Clone this repo into ~/.dotfiles

```bash
cd .dotfiles
stow -v -n .  # show what would change
stow -v .     # stow all dotfiles in directory
stow -v -D .  # delete symlinks stow created
```

Update: Started using stow packages intead of the entire directory of hidden dotfiles.  Run ./config.sh to install packages and remaining dotfiles.
Now can install individual packages or use setup.sh to install them all

```bash
stow emacs     # install emacs pkg as either ~/.emacs.d, or, if the directory exists, symlinks inside the ~/.emacs.d directory
stow -D emacs  # remove emacs pkg directory or the symlinks inside ~/.emacs.d
```
