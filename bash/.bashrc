# -*- shell-script -*-
# ~/.bashrc - executed for interactive non-login shells
#
# ------------------------------------------------------------------------------

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#####################
#  Common Settings  #
#####################
set bell-style visible
bind 'set bell-style visible'		# No beeping
#bind 'set horizontal-scroll-mode on'	# Don't wrap
bind 'set show-all-if-ambiguous on'	# Tab once for complete
bind 'set visible-stats on'		# Show file info in complete

# vagrant on Fedora 21 wants to use libvirt, force it to virtualbox
export VAGRANT_DEFAULT_PROVIDER=virtualbox

#NNTPSERVER=nntp.aioe.org
NNTPSERVER=news.eternal-september.org
MORE=p
LESS="-XgmR"

umask 022
test -t 0 && stty erase '^?'	# changed from ^h because of emacs help
stty -ixon                      # disable ^Q and ^S flow control
set -o emacs
GZIP="-9"


#############################
#  Configure shell history  #
#############################
#export PROMPT_COMMAND="history -a; history -n"  # Manually update .bash_history file
export HISTCONTROL=ignorespace
#export HISTIGNORE="&:ls:[bf]g:exit"
#export HISTTIMEFORMAT="%Y-%m-%d %T "
unset HISTFILESIZE
export HISTSIZE=10000


####################
#  Bash Variables  #
####################
set -o noclobber	# disable > >& <> from overwriting existing files
#set -o physical
shopt -s cdspell	# corrects for slop in directory spelling
shopt -s checkwinsize	# Keep COLUMNS and LINES updated
shopt -s extglob	# enable *(...), +(...), @(...), ?(...), !(...)
shopt -s dotglob	# include files beginning with a . in file expansion
shopt -s cmdhist	# save all lines of a multiple-line command
shopt -s histappend	# history list is appended to the history file
shopt -s cmdhist        # shell attempts to save each line of a multi-line command
shopt -s histreedit	# user can to re-edit a failed history substitution
shopt -s histverify	# history substitution loaded into readline buffer
shopt -s checkhash	# check hash table for command before executing it
shopt -s checkwinsize   # check term row/column size after each command before prompt


# Load general aliases
if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

# Load general functions
if [ -f $HOME/.functions ]; then
    . $HOME/.functions
fi

# magit, function to open magit buffer from current git repo
magit() {
  if git status > /dev/null 2>&1; then
      #emacsclient -nw --eval "(call-interactively #'magit-status)"
      emacsclient -s ${HOME}/.emacs.d/tmp/server -n -a emacs --eval "(call-interactively #'magit-status)"
  else
      echo "Not in a git repo"
      return 1
  fi
}


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


###################
#  Source workrc  #
###################
#if [ -e ${HOME}/.workrc ]; then
#  source ~/.workrc
#fi


###
# pyenv functions
###
rt-activate() {
  pyenv activate research-tools
  cd ~/projects/CBT/research_tools
}

# pyenv keep prompt - from Jody:
# Fuck you, I *LIKE* my prompt that way
#export VIRTUAL_ENV_DISABLE_PROMPT=1
#export PYENV_VIRTUALENV_DISABLE_PROMPT=0


# -- Emacs shell setup --
# https://github.com/akermu/emacs-libvterm
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
  fi
else
  export TERM=xterm-256color
fi


# Set ripgrep config file
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc


# pyenv init
if [[ -f $HOME/.config/NO_BASH_PYENV ]]; then
  echo "Skipping .bashrc init pyenv"
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
if [[ ! -z $PS1 ]]; then echo ".darwin bashrc loaded"; fi  # Interactive

    # Mac OS Catalina on, new shell is zsh
    # to disable notice
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export CLICOLOR=1

    export EDITOR="${HOME}/bin/edit"
    export ALTERNATE_EDITOR="mg"
    export GROOVY_HOME=/usr/local/opt/groovy/libexec

    #function ediff {
    #    emacs --eval "(ediff \"$1\" \"$2\")"
    #}
    #
    #if [[ -f ~/Library/LaunchAgents/gnu.emacs.daemon.plist ]]; then
    #    alias emacs_load="launchctl load -w ~/Library/LaunchAgents/gnu.emacs.daemon.plist"
    #    alias emacs_unload="launchctl unload -w ~/Library/LaunchAgents/gnu.emacs.daemon.plist"
    #    alias emacs_status="launchctl list | grep emacs"
    #fi
    #
    #if [[ -f ~/Library/mysql/com.mysql.mysqld.plist ]]; then
    #    alias start_mysql="sudo launchctl load ~/Library/mysql/com.mysql.mysqld.plist"
    #    alias stop_mysql="sudo launchctl unload ~/Library/mysql/com.mysql.mysqld.plist"
    #fi

    # Enable Homebrew for M1 Mac if installed
    if command -v /opt/homebrew/bin/brew 1>/dev/null 2>&1; then
      eval $(/opt/homebrew/bin/brew shellenv)
    fi

    # pyenv local git install
    if [ ! -z "${PYENV_ROOT}" ]; then
      echo "..pyenv initalize"
      eval "$(pyenv init -)"
    fi

    if command -v ~/.pyenv/plugins/pyenv-virtualenv/bin/pyenv-virtualenv-init 1>/dev/null 2>&1; then
      echo "..pyenv-virtualenv initalize"
      eval "$(pyenv virtualenv-init -)"
    fi

    # jenv darwin
    #if which jenv > /dev/null; then export PATH="$HOME/.jenv/bin:$PATH"; eval "$(jenv init -)"; fi
;; # end Darwin

Linux)  # Based off of Ubuntu
if [[ ! -z $PS1 ]]; then echo ".linux bashrc loaded"; fi	# interactive

    ## Open like command for Linux:  xdg-open or see
    function open { xdg-open "$1" &> /dev/null & }

    TERM=xterm-color

    # Load Linux aliases
    if [[ -f $HOME/.aliases.linux ]]; then
        . $HOME/.aliases.linux
    fi

    # Load Linux functions
    if [[ -f $HOME/.functions.linux ]]; then
        . $HOME/.functions.linux
    fi


    ###
    # Configure Emacs and Emacsclient
    # adapted from http://philipweaver.blogspot.com/2009/08/emacs-23.html
    ###
    [[ "x$EDITOR" == "x" ]] && export EDITOR="mg"  # set EDITOR if blank
    export ALTERNATE_EDITOR="mg"

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
    alias ecw="emacsclient -s $EMACS_SOCKET -n -c -a emacs"  # start a windowed frame
    alias ect="emacsclient -s $EMACS_SOCKET -t -a emacs -nw" # start a terminal frame
    alias  ec="emacsclient -s $EMACS_SOCKET -n -a emacs"     # do not start a new frame
    # Specialized emacs buffers
    alias ecb="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(ibuffer)'"
    alias ecd="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(dired nil)'"
    alias ecm="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(mu4e)'"
    alias ecn="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(elfeed)'"
    alias ece="emacsclient -s $EMACS_SOCKET -c -a '' --eval '(eshell)'"

;; # end Linux

*)
echo "uname not reporing Darwin or Linux.  Where are we?"
;;

esac  # End System Specific case statement
