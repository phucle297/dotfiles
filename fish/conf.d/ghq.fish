set -x PATH $PATH /usr/local/go/bin $HOME/go/bin

set -x GHQ_ROOT $HOME/Projects/

alias g='cd (ghq root)/(ghq list | peco)'
