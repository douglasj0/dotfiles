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


### --- Prompt Config ---
# https://salferrarello.com/zsh-git-status-prompt/
# prompt colors
autoload -U colors && colors

# zsh add git branch if available
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(%b)'
precmd() {
  vcs_info
  psvar[1]="${vcs_info_msg_0_}"
}

# Enable substition in the prompt
# red, blue, green, cyan, yellow, magenta, black, & white
setopt prompt_subst

# Prompt colors based on hostname
case ${HOST%%.*} in
  QYCMJGH2QG)      PROMPT_COLOR="yellow"; PROMPT_HOST="thorn" ;;
  lothlorien)      PROMPT_COLOR="green";  PROMPT_HOST="%m" ;;
  lothlorien-wifi) PROMPT_COLOR="green";  PROMPT_HOST="%m" ;;
  flowers)         PROMPT_COLOR="green";  PROMPT_HOST="%m" ;;
  *)               PROMPT_COLOR="white";  PROMPT_HOST="%m" ;;
esac

#function _zsh_prompt {
NEWLINE=$'\n'
PS1='%F{blue}%T%f %F{$PROMPT_COLOR}%n@${PROMPT_HOST}[%h]%f %F{cyan}[%~]%f %F{green}${vcs_info_msg_0_}%f$NEWLINE%F{white}%# %f'
#}

#precmd() { eval "$PROMPT_COMMAND" }
#PROMPT_COMMAND=_zsh_prompt

# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
# Set the format of the Git information for vcs_info
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
### --- Prompt Config or Startship End ---


# Prevent text pasted into the terminal from being highlighted, introduced in zsh 5.1
zle_highlight+=(paste:none)

# Functions to autoload
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
#setopt hist_verify
#setopt share_history
setopt no_share_history
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
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
#setopt shwordsplit # behave like Bash for word splitting

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
fpath+=~/.zfunc
autoload -Uz compinit && compinit -i

# some nice bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

# stty erase ^H
##stty -echoprt

NNTPSERVER=news.eternal-september.org
MORE=p
LESS="-XgmR"

# Homebrew lessopen
#export LESSOPEN="|/opt/homebrew/bin/lesspipe.sh %s"

# Set ripgrep config file
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# Load general aliases
if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

# Load general functions
if [ -f $HOME/.functions ]; then
    . $HOME/.functions
fi

# -- Emacs shell setup --
if [[ ${INSIDE_EMACS:-no} != 'no' ]]; then
  echo ".. inside Emacs"
  export TERM=vt100

  #export EDITOR=emacsclient
  export VISUAL=emacsclient
  export PAGER=cat

  alias amagit="emacsclient -ne '(magit-status)'"
  function man() { emacsclient -ne "(man \"$1\")"; }

  # Emacs vterm clear
  if [[ "${INSIDE_EMACS}" =~ 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
    # Emacs vterm name buffer - doesn't work?
    autoload -U add-zsh-hook
    add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }
  fi
else
  export TERM=xterm-256color
fi


################
#  pyenv init  #
################
if [[ -f $HOME/.config/NO_ZSH_PYENV ]]; then
  echo "Skipping .zshrc init pyenv"
else
  if [[ -d $HOME/.pyenv ]]; then
    if [[ -z ${PYENV_SHELL} ]]; then
      echo ". initializing pyenv"
      export PYENV_ROOT="${HOME}/.pyenv"
      export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"
      eval "$(pyenv virtualenv-init -)"
    else
      echo ".. pyenv already initialized, skipping"
    fi
  else
    echo ".. pyenv directory not found, exiting"
  fi
fi


###################
#   OS Specific   #
###################
case "$(uname)" in
Darwin)  # Darwin Environment
    if [[ ! -z $PS1 ]]; then echo ".. darwin zshrc settings loaded"; fi  # Interactive

    # Load Darwin aliases
    if [[ -f $HOME/.aliases.darwin ]]; then
        . $HOME/.aliases.darwin
    fi

    # Load Darwin functions
    if [[ -f $HOME/.functions.darwin ]]; then
        . $HOME/.functions.darwin
    fi

    # Fix date/gdate issues, if we have gdate use it
    #if [[ -e /opt/homebrew/bin/gdate ]]; then alias date=gdate; fi

    export EDITOR="${HOME}/bin/edit"
    export ALTERNATE_EDITOR="mg"

    # Tell homebrew to not autoupdate every single time I run it (just once a week).
    export HOMEBREW_AUTO_UPDATE_SECS=604800

    # Source infra functions
    if [ -d ${HOME}/.infra ]; then
      echo "... load infra functions"
      source ${HOME}/.infra/includes.sh
      for f in `\ls ${HOME}/.infra/ | egrep -v 'includes.sh|~$'`; do source ${HOME}/.infra/$f; done
    fi

    # setup fzf (fuzzy finder)
    if command -v fzf >/dev/null 2>&1; then
      echo "... initialize fzf"
      eval "$(fzf --zsh)"
      export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
      fcd() {
        local dir
        dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
      }
    fi

    # Homebrew completions
    #if type brew &>/dev/null; then
    #   FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    #   autoload -Uz compinit
    #   compinit
    #fi

    ;; # end Darwin

Linux)  # Based off of Ubuntu
    if [[ ! -z $PS1 ]]; then echo ".. linux zshrc settings loaded"; fi # interactive

    # Load Linux aliases
    if [[ -f $HOME/.aliases.linux ]]; then
        . $HOME/.aliases.linux
    fi

    # Load Linux functions
    if [[ -f $HOME/.functions.linux ]]; then
        . $HOME/.functions.linux
    fi

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
