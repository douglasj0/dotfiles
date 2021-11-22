# -*- shell-script -*-
# ~/.profile - executed for graphical logins
#
# ------------------------------------------------------------------------------

###################
#   OS Specific   #
###################
case $(uname) in
Darwin)  # Darwin Environment
#echo ".darwin profile loaded"

#For compilers to find ruby you may need to set:
#  export LDFLAGS="-L/usr/local/opt/ruby/lib"
#  export CPPFLAGS="-I/usr/local/opt/ruby/include"

#For pkg-config to find ruby you may need to set:
#  export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

PATH="${HOME}/bin:${HOME}/scripts:\
/Applications/Emacs.app/Contents/MacOS:\
/Applications/Emacs.app/Contents/MacOS/bin:\
/Applications/Xcode.app/Contents/Developer/Tools:\
/usr/bin:/bin:/usr/sbin:/sbin:.emacs.d/bin:/opt/X11/bin"
MANPATH="/usr/local/share/man:/usr/local/man:/usr/share/man:/usr/X11/man"
TMPDIR="/tmp"
export PATH MANPATH TMPDIR

# Set Homebrew and usr local on Mac
if [[ "$(uname -a)" = Darwin*arm64 ]]; then
  # We're running on a M1 Mac, homebrew no in /opt
  PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:${PATH}"
else
  # Everything else, default /usr/local
  PATH="/usr/local/lib/ruby/gems/3.0.0/bin:/usr/local/opt/ruby/bin:/usr/local/bin:/usr/local/sbin:/usr/local/opt/openssl/bin:${PATH}"
fi

# pyenv path setup
if command -v ~/.pyenv/bin/pyenv 1>/dev/null 2>&1; then
  echo ".profile pyenv path setup"
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
;; # end Darwin

Linux)  # Based off of Ubuntu
echo ".linux profile loaded"

PATH="${HOME}/bin:${HOME}/scripts:${HOME}/.local/bin:\
/usr/local/sbin:/usr/local/bin:\
/usr/bin:/bin:/usr/sbin:/sbin:/usr/games:\
/opt/jdk:/opt/jdk/bin:/usr/java/bin:/usr/local/java/bin"
MANPATH="/usr/local/share/man:/usr/share/man:/usr/X11R6/man"
TMPDIR="/tmp"
export PATH MANPATH TMPDIR

# pyenv path setup
if command -v ~/.pyenv/bin/pyenv 1>/dev/null 2>&1; then
  #echo ".profile pyenv path setup"
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
;; # end Linux

*)
echo "profile uname not reporing Darwin or Linux.  Where are we?"
;;

esac  # End System Specific case statement
