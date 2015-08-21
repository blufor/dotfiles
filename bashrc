# ~/.bashrc

export OS="`uname -s`"

source ~/.bash/shopts.sh
source ~/.bash/variables.sh
source ~/.bash/colors.sh
source ~/.bash/functions.sh
source ~/.bash/completion.sh
source ~/.bash/aliases.sh
source ~/.bash/prompt.sh


if [ -n "${DISPLAY}" ]; then
  source ~/.bash/workstation.sh
fi

if [ -s "${HOME}/.rvm/scripts/rvm" ]; then
  source ~/.rvm/scripts/rvm
fi
