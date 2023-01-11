# -*- mode: sh; -*-
#
# my rc file for zsh
# all this runs in interactive shells only

# '.zshrc' is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.

# where to look for function definitions
# fpath=(~/func)

# Setup zprofiling (leave disabled when not using
#zmodload zsh/zprof

## If not running interactively, don't do anything and return early
#[[ $- == *i* ]] || return
#[[ -o interactive ]] || exit 0  # zsh

# use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0

umask 077


# prompt colors
autoload -U colors && colors

# zsh add git branch if available
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '(%b)'

# Set prompt, was PROMPT='%T %m[%h]%# ', reset color %{$reset_color%}%
if [[ $(echo $HOST | grep "b.local") ]]; then MYHOST="b.local"; fi
if [[ ${MYHOST} == "b.local" ]]; then
PROMPT='%F{yellow}%T %n@thorn[%h]%f %F{cyan}[%~]%f %F{green}${vcs_info_msg_0_}%f
%F{white}%# %f'
elif [[ ${HOST} == "flowers" ]]; then
PROMPT='%F{green}%T %n@flowers[%h]%f %F{cyan}[%~]%f %F{yellow}${vcs_info_msg_0_}%f
%F{white}%# %f'
elif [[ ${HOST} == "lothlorien.local" ]]; then
PROMPT='%F{yellow}%T %n@lothlorien[%h]%f %F{cyan}[%~]%f %F{greeb}${vcs_info_msg_0_}%f
%F{white}%# %f'
else
PROMPT='%T %m[%h] [%~] ${vcs_info_msg_0_}
%# '
fi

# Prevent text pasted into the terminal from being highlighted
# Introduced in zsh 5.1
zle_highlight+=(paste:none)

# functions to autoload
# autoload cx acx mere yu yp randline proto namedir ilogin
#autoload -Uz compinit && compinit -i #autocompletion on hosts and usernames
# small letters will match small and capital letters. (i.e. capital letters match only capital letters.)
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# capital letters also match small letters use instead:
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# If you want case-insensitive matching only if there are no case-sensitive matches add '', e.g.
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'


# https://www.viget.com/articles/zsh-config-productivity-plugins-for-mac-oss-default-shell/
# History
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
#setopt share_history
setopt no_share_history
# Changing directories
setopt auto_cd
setopt auto_pushd
unsetopt pushd_ignore_dups
setopt pushdminus
# Completion
setopt auto_menu
setopt always_to_end
setopt complete_in_word
unsetopt flow_control
unsetopt menu_complete
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# Other
setopt prompt_subst

# test command line editing module
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
# also: You can use fc to edit the last command in history.

#MAILCHECK=30
#HISTSIZE=600
#DIRSTACKSIZE=50

setopt notify cdablevars autolist \
        sun_keyboard_hack auto_cd recexact long_list_jobs \
        hist_ignore_dups no_clobber \
        extended_glob rc_quotes nobeep
unsetopt bgnice

# Turn on auto completetion (ssh, ssh with user, etc)
autoload -Uz compinit && compinit -i

# some nice bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

# jsamuels stuff

# PROMPT="%m:%3c[$SHLVL]>"
# RPROMPT="%B%*%b"
#HISTFILE=~/.zhistory
#SAVEHIST='1000'
#HISTSIZE='1000'
# DIRSTACKSIZE=50
# WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# stty intr '^C'
# chpwd () { print -Pn '' }

# cd

# stty erase ^H
##stty -echoprt

NNTPSERVER=news.eternal-september.org
MORE=p
LESS="-XgmR"

# Load general aliases
if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

# Load general functions
if [ -f $HOME/.functions ]; then
    . $HOME/.functions
fi

# Emacs vterm clear
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

# Emacs vterm name buffer - doesn't work?
#autoload -U add-zsh-hook
#add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }


###################
#  Source workrc  #
###################
if [ -e ${HOME}/.workrc ]; then
  source ~/.workrc
fi


################
#  pyenv init  #
################
if [[ -f ${HOME}/NO_PYENV ]]
then
    echo ". skipping pyenv"
else
    if [[ -d "${HOME}/.pyenv" ]]
    then
         export PYENV_ROOT="$HOME/.pyenv"
         #command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
         export PATH="$PYENV_ROOT/bin:$PATH"
         eval "$(pyenv init -)"
         eval "$(pyenv virtualenv-init -)"
         echo ". pyenv initialized"
    fi
fi


###################
#   OS Specific   #
###################
case "$(uname)" in
Darwin)  # Darwin Environment
    if [[ ! -z $PS1 ]]; then echo ".. darwin zshrc loaded"; fi  # Interactive

    # Load Darwin aliases
    if [[ -f $HOME/.aliases.darwin ]]; then
        . $HOME/.aliases.darwin
    fi

    # Load Darwin functions
    if [[ -f $HOME/.functions.darwin ]]; then
        . $HOME/.functions.darwin
    fi

    if [[ $INSIDE_EMACS ]]; then
        echo ".. Inside Emacs"
        export TERM=vt100
    else
        export TERM=xterm-256color
    fi

    export EDITOR="${HOME}/bin/edit"
    export ALTERNATE_EDITOR="mg"

    # Tell homebrew to not autoupdate every single time I run it (just once a week).
    export HOMEBREW_AUTO_UPDATE_SECS=604800

    ;; # end Darwin

Linux)  # Based off of Ubuntu
    if [[ ! -z $PS1 ]]; then echo ".. linux zshrc loaded"; fi # interactive

    # Load Linux aliases
    if [[ -f $HOME/.aliases.linux ]]; then
        . $HOME/.aliases.linux
    fi

    # Load Linux functions
    if [[ -f $HOME/.functions.linux ]]; then
        . $HOME/.functions.linux
    fi

    export TERM=xterm-color

    # export EDITOR="emacsclient -t"
    [[ "x$EDITOR" == "x" ]] && export EDITOR="mg"  # set EDITOR if blank
    export ALTERNATE_EDITOR="mg"

    ;; # end Linux

*)
    echo "Error: uname not reporing Darwin or Linux.  Where are we?"
    ;;

esac  # End System Specific case statement

# check status of zprofiling (leave disabled when not using)
#zprof
