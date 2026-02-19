# -*- shell-script -*-
# ~/.bashrc - executed for interactive non-login shells
#
# ------------------------------------------------------------------------------

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#####################
#  Common Settings  #
#####################
# maybe move these to readline's .inputrc
bind 'set bell-style visible'		# No beeping
bind 'set show-all-if-ambiguous on'	# Tab once for complete
bind 'set visible-stats on'		# Adds /,*,@,etc to completions

NNTPSERVER=news.eternal-september.org
LESS="-XgmR"
umask 022
stty -ixon                      # disable ^Q and ^S flow control


#############################
#  Configure shell history  #
#############################
HISTCONTROL=ignoreboth	# Space and Dups
HISTSIZE=10000
HISTFILESIZE=20000

####################
#  Bash Variables  #
####################
set -o noclobber	# disable > >& <> from overwriting existing files
shopt -s cdspell	# corrects for slop in directory spelling
shopt -s histappend	# history list is appended to the history file
shopt -s histreedit	# user can to re-edit a failed history substitution
shopt -s histverify	# history substitution loaded into readline buffer
shopt -s checkwinsize   # check term row/column size after each command before prompt


# Load general aliases
if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

# Load general functions
if [ -f $HOME/.functions ]; then
    . $HOME/.functions
fi


################
#  Set Prompt  #
################

# Name the colors
BLACK="\[\033[0;30m\]"   #Regular colors
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"
#
BBLACK="\[\033[1;30m\]"   #Bold colors
BRED="\[\033[1;31m\]"
BGREEN="\[\033[1;32m\]"
BYELLOW="\[\033[1;33m\]"
BBLUE="\[\033[1;34m\]"
BPURPLE="\[\033[1;35m\]"
BCYAN="\[\033[1;36m\]"
BWHITE="\[\033[1;37m\]"
#
RESET="\[\033[0m\]" #Reset colors

# From Andrew Proksel
# get current branch in git repo
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "[${BRANCH}${STAT}]"
    else
        echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}

# Shell Prompt
# change unpleasnt name to thorn
if [[ $(echo $HOSTNAME | grep "b.local") ]]; then MYHOSTNAME="b.local"; fi
if [[ ${MYHOSTNAME} == "b.local" ]]; then
  PROMPT_COMMAND='if [ $? = 0 ]; then
    PS1="${YELLOW}\A \u${RESET}${YELLOW}@thorn[\!] ${RESET}${CYAN}[\w]${RESET}${WHITE} \`parse_git_branch\`\n${WHITE}\$${RESET} "
  else
    PS1="${YELLOW}\A \u${RESET}${YELLOW}@thorn[\!] ${RESET}${CYAN}[\w]${RESET}${WHITE} \`parse_git_branch\`\n${RED}\$${RESET} "
  fi'
elif [[ ${HOSTNAME} == "flowers" ]] || [[ ${HOSTNAME} == "lothlorien" ]]; then
  PROMPT_COMMAND='if [ $? = 0 ]; then
    PS1="${GREEN}\A \u${RESET}${GREEN}@\h[\!] ${RESET}${CYAN}[\w]${RESET}${WHITE} \`parse_git_branch\`\n${WHITE}\$${RESET} "
  else
    PS1="${GREEN}\A \u${RESET}${GREEN}@\h[\!] ${RESET}${CYAN}[\w]${RESET}${WHITE} \`parse_git_branch\`\n${RED}\$${RESET} "
  fi'
else
  PROMPT_COMMAND='if [ $? = 0 ]; then
    PS1="${WHITE}\A \u${RESET}${WHITE}@\h[\!] ${RESET}${CYAN}[\w]${RESET}${WHITE} \`parse_git_branch\`\n${WHITE}\$${RESET} "
  else
    PS1="${WHITE}\A \u${RESET}${WHITE}@\h[\!] ${RESET}${CYAN}[\w]${RESET}${WHITE} \`parse_git_branch\`\n${RED}\$${RESET} "
  fi'
fi
export PS1


# -- Editor --
#[[ "x$EDITOR" == "x" ]] && export EDITOR="mg"  # set EDITOR if blank
#EMACS_SOCKET=${TMPDIR:-/tmp}/emacs${UID}/server  # -s ${EMACS_SOCKET}
export ALTERNATE_EDITOR="zile -f end-of-line"
export EDITOR="emacsclient -t -a '$ALTERNATE_EDITOR'"
export VISUAL="$EDITOR"
# Emacs Functions
function  ec { emacsclient -c -n -a '' --eval "(progn (find-file \"$1\"))"; }
function ect { emacsclient -t -a '' -- "${@}"; }

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
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc


# Activate mise for bash if installed
# https://mise.jdx.dev/getting-started.html
# https://mise.jdx.dev/lang/python.html
# venv: python -m venv /path/to/venv
if command -v mise >/dev/null 2>&1; then
    echo ". activating mise"
    eval "$(mise activate bash)"
fi


# Load readable modules
# https://www.reddit.com/r/commandline/comments/1r1tqnc/i_made_my_bashrc_modular_now_any_dotfile_manager/
if [ -d "$HOME/.config/bash" ]; then
    for config in "$HOME/.config/bash"/*.sh; do
        [ -r "$config" ] && source "$config"
    done
fi


###################
#   OS Specific   #
###################
case "$(uname)" in
Darwin)	 # Darwin Environment
if [[ ! -z $PS1 ]]; then echo ". darwin bashrc loaded"; fi  # Interactive

    # Mac OS Catalina on, new shell is zsh
    # to disable notice
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export CLICOLOR=1

    export EDITOR="${HOME}/bin/edit"
    export ALTERNATE_EDITOR="mg"
    export GROOVY_HOME=/usr/local/opt/groovy/libexec

;; # end Darwin

Linux)	# Based off of Ubuntu
if [[ ! -z $PS1 ]]; then echo ". linux bashrc loaded"; fi	# interactive

    ## Open like command for Linux:  xdg-open or see
    function open { xdg-open "$1" &> /dev/null & }

    # Load Linux aliases
    if [[ -f $HOME/.aliases.linux ]]; then
	. $HOME/.aliases.linux
    fi

    # Load Linux functions
    if [[ -f $HOME/.functions.linux ]]; then
	. $HOME/.functions.linux
    fi

    ediff() {
      emacs --eval "(ediff-files \"$1\" \"$2\")"
    }

    # setup fzf (fuzzy finder)
    if command -v fzf >/dev/null 2>&1; then
      echo ".. initialize fzf"
      eval "$(fzf --bash)"
      export FZF_DEFAULT_COMMAND="fdfind --hidden --strip-cwd-prefix --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="fdfind --type=d --hidden --strip-cwd-prefix --exclude .git"
      fcd() {
	local dir
	dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
      }
    fi

;; # end Linux

*)
echo "uname not reporing Darwin or Linux.  Where are we?"
;;

esac  # End System Specific case statement
