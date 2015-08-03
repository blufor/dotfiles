# ~/.bashrc

export OS="`uname -s`"

source ~/.config/bash/shopts.sh
source ~/.config/bash/variables.sh
source ~/.config/bash/colors.sh
source ~/.config/bash/functions.sh
source ~/.config/bash/completion.sh
source ~/.config/bash/aliases.sh
source ~/.config/bash/prompt.sh


if [ -n "${DISPLAY}" ]; then
  source ~/.config/bash/workstation.sh
fi

if [ -s "${HOME}/.rvm/scripts/rvm" ]; then
  source ~/.rvm/scripts/rvm
fi
