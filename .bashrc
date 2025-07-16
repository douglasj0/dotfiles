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


###############
#  Functions  #
###############
function p3 { source ~/.virtualenvs/p3/bin/activate; }
function my_ps { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command; }
function psg { ps -aef | grep $* | grep -v grep; }  # sysv ps
function psb { ps aux | grep $* | grep -v grep; }  # bsd ps
function lhd { last $* | head; }
function calc { awk "BEGIN{ print $* }"; }
function rmd { pandoc $1 | lynx -stdin ; }

# remove entry from ~/.ssh/known_hosts
function delhost { ssh-keygen -R $@; }
#function delprevhost { ssh-keygen -R !$; }

# get mac addr
function mac { ping -c 2 $1 > /dev/null 2>&1; arp $1 | awk '{print $3}' | tail -1; }

rot13 () {	# For some reason, rot13 pops up everywhere
    if [ $# -eq 0 ]; then
	tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    else
	echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    fi
}

# Top 10 most used commands in history (TODO update for MacOS)
top10 () { history | awk '{print $2}' | awk 'BEGIN {FS="|"} {print $1}' | sort | uniq -c | sort -nr | head -10; }

# History unique grep search / to re-use a line found !123:p / !123
hugs () { history | grep -i -- "$1" | sort -k2 -u | grep -v 'hugs' | sort -n; }

## Extract common archive formats
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Repeat last command with sudo
yolo() {
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# ssh key functions
ssh-add-all() { LIST=$(ls $HOME/.ssh/id_* | grep -v '.pub'); ssh-add $LIST; } # add all ssh keys
ssh-del-all() { ssh-add -D; }                              # delete all ssh keys
ssh-add-work () { ssh-add ${HOME}/.ssh/id_rsa_work; }      # add work key
ssh-del-work () { ssh-add -d ${HOME}/.ssh/id_rsa_work; }   # delete work key
ssh-add-home () { ssh-add ${HOME}/.ssh/id_rsa_home; }      # add home github key
ssh-del-home () { ssh-add -d ${HOME}/.ssh/id_rsa_home; }   # delete home github key

#grepp: grep by paragraph, http://www.commandlinefu.com/commands/view/4547/
grepp() {
    [ $# -eq 1 ] && perl -00ne "print if /$1/i" || perl -00ne "print if /$1/i" < "$2"
}

# Push ssh authorized_keys to remote host
pushkey() {
  if [ -z $1 ]; then
     echo "no host specified"
  else
    KEYCODE=`cat $HOME/.ssh/authorized_keys`
    ssh -q $1 "mkdir -p ~/.ssh && chmod 0700 ~/.ssh && touch ~/.ssh/authorized_keys && echo "$KEYCODE" >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
  fi
}

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


#############
#  Aliases  #
#############
alias j='jobs'
alias h='history'
alias la='ls -a'
alias lf='ls -F'
alias ll='ls -l'
alias l.='ls -d .*'             # List only file beginning with "."
alias ll.='ls -ld .*'           # Long list only file beginning with "."
alias l='ls -laF'
alias lm='ls -laF | more'
alias lk='ls -lSr'              # sort by size in K, smallest to largest
alias lh='ls -lhSr'             # sort by size in human readable, smallest to largest
alias lr='ls -lR'               # recursice ls
alias lt='ls -ltr'              # sort by date
alias lla='ls -la'
alias lll='ls -actl | more'     # pipe through 'more'
alias ldir="ls -l | egrep '^d'" # show only directories
alias lfile="ls -l | egrep -v '^d'" # show files only"
alias digs="dig +short"
alias killmercer='sudo $(history -p !!)'
alias just='sudo'
alias gtfo='exit'
#alias ssh-add-home="ssh-add ~/.ssh/home/id_rsa"
#
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias splitpath='echo -e ${PATH//:/\\n}'
alias histg='history | grep '
alias +='pushd .'
alias _='popd'
alias dirf='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/'
# Deletes the last thing typed from history so it doesn't get written to .bash_history on exit
alias scratch='history -d $((HISTCMD-2)) && history -d $((HISTCMD-1))'
alias keepalive='while true; do date; sleep 120; done'
if [ `which watch` ]; then alias nap="watch -n 120 echo ${HOSTNAME}"; fi
# Re-attach to a screen session with updated ssh authentication
alias screenssh='ln -sf $SSH_AUTH_SOCK $HOME/.ssh-auth-sock; env SSH_AUTH_SOCK=$HOME/.ssh-auth-sock screen'
alias git_repo_name='git remote show -n origin | grep Fetch | cut -d: -f2-'
alias ping4='ping -c4'
alias weather='curl wttr.in/chicago'
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# Proksel's aliases
alias aspen='tree -h -f -C'
alias atomize='open . -a Atom'
alias killmercer='sudo $(history -p !!)'
alias public_ip='curl ipecho.net/plain; echo'
alias terraform_graph='terraform graph | dot -Tpng > graph.png'

# git aliases
alias gg="git grep"
alias git-unfuck="git reset --hard HEAD"
alias gitGraph='git log --graph --oneline --all --decorate --color'


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
