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

PATH="${HOME}/bin:${HOME}/myscripts:\
/Users/djackson/.local/bin:\
/Applications/Emacs.app/Contents/MacOS:\
/Applications/Emacs.app/Contents/MacOS/bin:\
/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:\
/usr/local/sbin:/usr/local/bin:/Library/TeX/texbin"
MANPATH="/usr/local/share/man:/usr/local/man:/usr/share/man:/usr/X11/man:\
/Applications/kitty.app/Contents/Resources/man"
TMPDIR="/tmp"

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
    eval "$(/opt/homebrew/bin/brew shellenv)"
    PATH="/opt/homebrew/opt/openssl@1.1/bin:${PATH}"
    ;;
  x86_64)
    #PATH="/usr/local/sbin:/usr/local/bin:/usr/local/opt/openssl@1.1/bin:${PATH}"
    eval "$(/usr/local/bin/brew shellenv)"
    PATH="/usr/local/opt/openssl@1.1/bin:${PATH}"
    ;;
  *)
    #PATH="/usr/local/sbin:/usr/local/bin"
    echo "no known Architecture found, no Homebrew path set."
    ;;
esac
export PATH MANPATH TMPDIR


;; # end Darwin

Linux)  # Based off of Ubuntu
#echo ".. linux profile loaded"

PATH="${HOME}/bin:${HOME}/scripts:${HOME}/.local/bin:\
/usr/local/sbin:/usr/local/bin:\
/usr/bin:/bin:/usr/sbin:/sbin:/usr/games:\
/opt/jdk:/opt/jdk/bin:/usr/java/bin:/usr/local/java/bin"
MANPATH="/usr/local/share/man:/usr/share/man:/usr/X11R6/man"
TMPDIR="/tmp"
export PATH MANPATH TMPDIR

;; # end Linux

*)
echo "profile uname not reporing Darwin or Linux.  Where are we?"
;;

esac  # End System Specific case statement
