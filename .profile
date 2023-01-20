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

PATH="${HOME}/bin:${HOME}/scripts:\
/Applications/Emacs.app/Contents/MacOS:\
/Applications/Emacs.app/Contents/MacOS/bin:\
/Applications/Xcode.app/Contents/Developer/Tools:\
/Library/TeX/texbin:\
/usr/bin:/bin:/usr/sbin:/sbin:${HOME}/.emacs.d/bin:/opt/X11/bin:\
/usr/local/sbin:/usr/local/bin"
MANPATH="/usr/local/share/man:/usr/local/man:/usr/share/man:/usr/X11/man"
TMPDIR="/tmp"

# Set architecture-specific paths, mainly for Homebrew
# NOTE might need to add to compile against brew openssl:
#   export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
#   export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
  #  # X86, default /usr/local
  #  removed: /usr/local/lib/ruby/gems/3.0.0/bin:/usr/local/opt/ruby/bin
  PATH="/usr/local/sbin:/usr/local/bin:/usr/local/opt/openssl@1.1/bin:${PATH}"
  #export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
  #export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
elif [ "${arch_name}" = "arm64" ]; then
  # We're running on a M1 Mac, homebrew now in /opt
  PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/opt/homebrew/opt/openssl@1.1/bin:${PATH}"
  #export LDFLAGS="-L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/bzip2/lib"
  #export CPPFLAGS="-I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/bzip2/include"
else
    echo "Error unknown architecture: ${arch_name}"
fi
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
