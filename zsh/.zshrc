# -*- mode: sh; -*-
#
# my rc file for zsh

# '.zshrc' is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.

#zmodload zsh/zprof
# where to look for function definitions
# fpath=(~/func)
# all this runs in interactive shells only
# Setup zprofiling (leave disabled when not using

## If not running interactively, don't do anything and return early
#[[ $- == *i* ]] || return
#[[ -o interactive ]] || exit 0  # zsh


# Bail out of rest of setup if we're coming in from TRAMP
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
umask 077
#MAILCHECK=30
#HISTSIZE=600
#DIRSTACKSIZE=50
#stty erase ^H
#stty -echoprt
NNTPSERVER=news.eternal-september.org
MORE=p
LESS="-XgmR" # no termcap, hilite last search match, long prompt, raw ctrl chars


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
  lothlorien*)  PROMPT_COLOR="green";  PROMPT_HOST="%m" ;;
  Mac)          PROMPT_COLOR="red";    PROMPT_HOST="%m" ;;
  flowers)      PROMPT_COLOR="yellow"; PROMPT_HOST="%m" ;;
  *)            PROMPT_COLOR="white";  PROMPT_HOST="%m" ;;
esac

#function _zsh_prompt {
NEWLINE=$'\n'
PS1='%F{blue}%T%f %F{$PROMPT_COLOR}%n@${PROMPT_HOST}[%h]%f %F{cyan}[%~]%f %F{green}${vcs_info_msg_0_}%f$NEWLINE%F{white}%# %f'
#}

#precmd() { eval "$PROMPT_COMMAND" }
PROMPT_COMMAND=_zsh_prompt

# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
# Set the format of the Git information for vcs_info
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
### --- Prompt Config or Startship End ---


# Functions to autoload
# autoload cx acx mere yu yp randline proto namedir ilogin
#autoload -Uz compinit && compinit -i #autocompletion on hosts and usernames
# small letters will match small and capital letters. (i.e. capital letters match only capital letters.)
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# capital letters also match small letters use instead:
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# If you want case-insensitive matching only if there are no case-sensitive matches add '', e.g.
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'


### --- History ---
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
SAVEHIST=10000
HISTSIZE=50000                 # set HISTSIZE > SAVEHIST
setopt EXTENDED_HISTORY        # include timestamp
setopt HIST_EXPIRE_DUPS_FIRST  # trim dupes first if history is full
setopt HIST_FIND_NO_DUPS       # do not display previously found command
setopt HIST_IGNORE_DUPS        # do not save duplicate of prior command
setopt HIST_IGNORE_SPACE       # do not save if line starts with space
setopt HIST_NO_STORE           # do not save history commands
setopt HIST_REDUCE_BLANKS      # strip superfluous blanks
setopt INC_APPEND_HISTORY      # don’t wait for shell to exit to save history lines
unsetopt SHARE_HISTORY
#bindkey "^[[A" history-search-backward
#bindkey "^[[B" history-search-forward


# Changing directories
setopt AUTO_CD      # interactive cd command to directory
setopt AUTO_PUSHD   # Make cd push old directory onto the directory stack
unsetopt PUSHD_IGNORE_DUPS # Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_MINUS

# Completion
setopt AUTO_MENU        # use menu completion after the second consecutive request for completion
setopt ALWAYS_TO_END    # Cursor moved to  end of the word if a single match/menu completion performed
setopt COMPLETE_IN_WORD # completion is done from both ends.
unsetopt FLOW_CONTROL
unsetopt MENU_COMPLETE
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# Other
unsetopt SHWORDSPLIT # behave like Bash for word splitting

# Command line editing modules / widgets
autoload -z zmv  # ex. zmv -n -W '*.txt' '*.log'

# Load the widget
autoload -U edit-command-line
zle -N edit-command-line

# Create a wrapper to "fix" the screen after editing
edit-command-line-fixed() {
  zle edit-command-line
  zle reset-prompt         # This clears the "jumbled" look
}

zle -N edit-command-line-fixed
bindkey '^x^e' edit-command-line-fixed
bindkey " " magic-space
# also: You can use fc to edit the last command in history.

# suffix aliases
alias -s md="bat"
alias -s yaml="bat -l yaml"
alias -s json="jless"
alias -s org="$EDITOR"

# command buffer hotkeys
bindkey -s '^Xgc' 'git commit -m ""\C-b'

setopt NOTIFY      # Report the status of background jobs immediately
setopt CDABLE_VARS # try to expand the expression as if it were preceded by a ‘~’
setopt AUTO_LIST   # list choices on an ambiguous completion
setopt AUTO_CD     # if can't execute command, perform a cd instead
setopt REC_EXACT   # if string cli exactly matches possible completion, it is accepted
setopt LONG_LIST_JOBS # Print job notifications in the long format by default.
setopt NO_CLOBBER  # no error is reported for '>>' redirect to nonexistant file
setopt EXTENDED_GLOB
setopt RC_QUOTES   # Character sequence ‘’’’ signify single quote in singly quoted strings
setopt NO_BEEP     # turn off beep/bell
unsetopt BG_NICE   # Run all background jobs at a lower priority.

# Prevent text pasted into the terminal from being highlighted, introduced in zsh 5.1
zle_highlight+=(paste:none)

# Turn on auto completetion (ssh, ssh with user, etc)
fpath+=~/.zfunc
autoload -Uz compinit && compinit -i

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
  #export TERM=vt100
  export TERM=xterm-256color  # for eat, etc.

  export EDITOR=emacsclient
  export VISUAL="$EDITOR"
  export PAGER=cat
  export PS1="$ "
  export GIT_EDITOR=emacs

  alias amagit="emacsclient -ne '(magit-status)'"
  function man() { emacsclient -ne "(man \"$1\")"; }

  # emacs eat: https://codeberg.org/akib/emacs-eat
  if [ -n "$EAT_SHELL_INTEGRATION_DIR" ]; then
      if [ -r "$EAT_SHELL_INTEGRATION_DIR/bash" ]; then
          # shellcheck source=/dev/null
          source "$EAT_SHELL_INTEGRATION_DIR/bash"
      fi

      # eat alias to open a file inside emacs
      alias eopen='_eat_msg open'
  fi

  # Emacs vterm clear
  #if [[ "${INSIDE_EMACS}" =~ 'vterm' ]]; then
  #  alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
  #  # Emacs vterm name buffer - doesn't work?
  #  autoload -U add-zsh-hook
  #  add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }
  #fi
else
  export TERM=xterm-256color
fi

# Set ripgrep config file
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config

# pyenv init
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
    if [[ -e /opt/homebrew/bin/gdate ]]; then alias date=gdate; fi

    # Tell homebrew to not autoupdate every single time I run it (just once a week).
    export HOMEBREW_AUTO_UPDATE_SECS=604800


    # Configure EDITOR, VISUAL, Emacs and Emacsclient
    # -s socket, -c create frame, -a alt-editor, -n no-wait, -t/-nw/-tty use terminal
    alias emacs="/Applications/Emacs.app/Contents/MacOS/bin/emacs"
    alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
    #EMACS_SOCKET=${TMPDIR:-/tmp}/emacs${UID}/server  # -s ${EMACS_SOCKET}
    export ALTERNATE_EDITOR="mg"
    export EDITOR="emacsclient -t -a '$ALTERNATE_EDITOR'"
    export VISUAL="$EDITOR"
    # Functions
    function  ec { emacsclient -c -a '' --eval "(progn (find-file \"$1\"))"; }
    function ect { emacsclient -t -a '' -- "${@}"; }


    ediff() { emacs --eval "(ediff \"$1\" \"$2\")" }

    # Emacs magit, function to open magit buffer from current git repo
    magit() {
      if git status > /dev/null 2>&1; then
          #emacsclient -nw --eval "(call-interactively #'magit-status)"
          emacsclient -n -a emacs --eval "(call-interactivel    y #'magit-status)"
      else
          echo "Not in a git repo"
          return 1
      fi
    }

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

    # Enable awscli command completion (requires bashcompinit for 'complete')
    # Must run after python is enabled (pyenv init or .infra)
    if type aws_completer &>/dev/null; then
      echo "... aws completer enabled"
      autoload bashcompinit && bashcompinit
      autoload -Uz compinit && compinit
      complete -C '~/.pyenv/shims/aws_completer' aws
    fi

    # Emacs eat integration (9.4)
    [ -f "$HOME/.emacs.d/var/integration/zsh" ] && EAT_SHELL_INTEGRATION_DIR="$HOME/.emacs.d/var/integration/zsh"
    [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR"

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

    #[[ "x$EDITOR" == "x" ]] && export EDITOR="mg"  # set EDITOR if blank
    export ALTERNATE_EDITOR="mg"
    export EDITOR="emacsclient -t -a ''"
    export VISUAL="$EDITOR"

    # On laptop, emacsclient cannot find emacs socket
    # emacs <= 26
    export EMACS_SOCKET=${TMPDIR:-/tmp}/emacs${UID}/server
    # emacs 27+ (but didn't work for me with emacs 30.1)
    # export EMACS_SOCKET=$XDG_RUNTIME_DIR/emacs/server

    # Pull emacs info back from .aliases and .functions
    # Configure Emacs and Emacsclient
    # adapted from http://philipweaver.blogspot.com/2009/08/emacs-23.html
    #alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"  # lowercase bin/emacs is broken
    #alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" # fix magit?
    #EMACS_SOCKET="${HOME}/.emacs.d/var/tmp/server"  # -s $EMACS_SOCKET
    # -c create frame, -a alt-editor, -n no-wait, -t/-nw/-tty use terminal
    #alias ecw="emacsclient -s $EMACS_SOCKET -n -c -a emacs"  # start a windowed frame
    #alias ect="emacsclient -s $EMACS_SOCKET -t -a emacs -nw" # start a terminal frame
    #alias  ec="emacsclient -s $EMACS_SOCKET -n -a emacs"     # do not start a new frame
    ## Specialized emacs buffers
    #alias ecb="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(ibuffer)'"
    #alias ecd="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(dired nil)'"
    #alias ecm="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(mu4e)'"
    #alias ecn="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(elfeed)'"
    #alias ece="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(eshell)'"

    ;; # end Linux

*)
    echo "Error: uname not reporing Darwin or Linux.  Where are we?"
    ;;

esac  # End System Specific case statement

# check status of zprofiling (leave disabled when not using)
#zprof
