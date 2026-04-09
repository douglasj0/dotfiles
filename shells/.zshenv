# -*- mode: sh -*-
# '.zshenv' is sourced on all invocations of the shell, unless the -f option is
# set. It should contain commands to set the command search path, plus other
# important environment variables. `.zshenv' should not contain commands that
# produce output or assume the shell is attached to a tty.

###################
#   OS Specific   #
###################
case $(uname) in
    Darwin)  # Darwin Environment
        #[ ! -z "$PS1" ] && echo ". darwin zshenv loaded"

        # disable reading of /etc/zprofile (global profiles) on MacOSX it changes path order
        setopt NO_GLOBAL_RCS  # disable ANY global files, except for the global zshenv file
        # might need to add 'setopt global_rcs' to ~/.zprofile to re-enable for /etc/zshrc and /etc/zlogin

        # Source .profile if readable, shared between bourne shells
        [[ -r ~/.profile ]] && source ~/.profile # shared PATH setup
        ;; # end Darwin

    Linux)  # Based off of Ubuntu
        #[ ! -z "$PS1" ] && echo ". linux zshenv loaded"

        # Source .profile if readable, shared between bourne shells
        [[ -r ~/.profile ]] && source ~/.profile # shared PATH setup
        ;; # end Linux

    *)
      echo "profile uname not reporing Darwin or Linux.  Where are we?"
      ;;

esac  # End System Specific case statement
