# -*- shell-script -*-
# ~/.profile - executed for graphical logins
#
# ------------------------------------------------------------------------------

###################
#   OS Specific   #
###################
case $(uname) in
Darwin)  # Darwin Environment
#echo ".. darwin profile loaded"

#For compilers to find ruby you may need to set:
#  export LDFLAGS="-L/usr/local/opt/ruby/lib"
#  export CPPFLAGS="-I/usr/local/opt/ruby/include"

#For pkg-config to find ruby you may need to set:
#  export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

PATH="${HOME}/bin:${HOME}/myscripts:${HOME}/.local/bin:\
/Applications/Emacs.app/Contents/MacOS:\
/Applications/Emacs.app/Contents/MacOS/bin:\
/bin:/sbin:/usr/bin:/usr/sbin:/opt/X11/bin:\
/usr/local/sbin:/usr/local/bin:"
export PATH

# Set architecture-specific paths, mainly for Homebrew
# NOTE might need to add to compile against brew openssl:
#  export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
#  export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
#
#  export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
#  export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
case $(uname -m) in  # switch to x86 shell: arch -x86_64 zsh
  arm64)
    #PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/opt/homebrew/opt/openssl@1.1/bin:${PATH}"
    #eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    ;;
  x86_64)
    #PATH="/usr/local/sbin:/usr/local/bin:/usr/local/opt/openssl@1.1/bin:${PATH}"
    eval "$(/usr/local/bin/brew shellenv)"
    ;;
  *)
    #PATH="/usr/local/sbin:/usr/local/bin"
    echo "no known Architecture found, Homebrew path not set."
    ;;
esac



;; # end Darwin

Linux)  # Based off of Ubuntu
#echo ".. linux profile loaded"

PATH="${HOME}/bin:${HOME}/myscripts:${HOME}/.local/bin:\
/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:\
/usr/local/sbin:/usr/sbin:/sbin"
export PATH

;; # end Linux

*)
echo "profile uname not reporing Darwin or Linux.  Where are we?"
;;

esac  # End System Specific case statement
