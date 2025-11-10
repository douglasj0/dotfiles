# dotfiles
Dotfiles for macos/linux/bsd

Managed with GNU Stow
https://www.gnu.org/software/stow/

## Clone configuration repository

NOTE: Converted to gnu stow after testing out chezmoi. (Wasn't that happy with chezmoi, the principle of least surprise bit me)

Clone this repo into ~/.dotfiles
cd .dotfiles
`stow -v -n . # show what would change`
`stow -v .`
`stow -v -D . # delete symlinks stow created`

Update: Started using stow packages intead of the entire directory of hidden dotfiles.  Run ./config.sh to install packages and remaining dotfiles.
Now can install individual packages or use setup.sh to install them all
ex.
`stow emacs`  # install emacs pkg as ~/.emacs.d
`stow -D emacs`  # remove emacs pkg
