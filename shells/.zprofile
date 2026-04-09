
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# load .profile if it exists
if [ -f ~/.profile ]; then
    source ~/.profile
fi
