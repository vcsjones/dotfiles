if command -v starship &> /dev/null
then
  eval "$(starship init zsh)"
fi

autoload -Uz compinit && compinit

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
