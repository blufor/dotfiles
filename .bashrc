# ~/.bashrc

source ~/.config/bash/shopts.sh
source ~/.config/bash/variables.sh

case $- in
    *i*) ;;
      *) return;;
esac

export OS="`uname`"
source ~/.config/bash/colors.sh
source ~/.config/bash/functions.sh
source ~/.config/bash/completion.sh
source ~/.config/bash/aliases.sh
source ~/.config/bash/prompt.sh

[[ -n "${DISPLAY}" ]]               && source ~/.config/bash/workstation.sh
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source ~/.rvm/scripts/rvm


