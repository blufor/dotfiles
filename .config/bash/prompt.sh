unset PS1

# letters or blocks (block order is: loadvg, background jobs, exit code of last command)
export PROMPT_STYLE="blocks"
# field to take loadavg (field order is from /proc/loadavg, cut format field selection)
export PROMPT_LOADAVGFIELD="2"
# invisible character in the colored line (useful to draw something for copypasting)
export PROMPT_SPACER="*"

# color config
HOSTCOLOR=${UNDWHT}
PATHCOLOR=${BLDGRN}
STATCOLOR=${TXTWHT}
DELIMCOLOR=${TXTWHT}
OKCOLOR=${TXTGRN}
WARNCOLOR=${TXTRED}
CRITCOLOR=${UNDRED}
ROOTCOLOR=${TXTYLW}
NONROOTCOLOR=${TXTBLU}
ROOTBGCOLOR=${BAKYLW}
NONROOTBGCOLOR=${BAKBLU}

# UID color
if [ "$UID" -eq "0" ]; then
  UIDCOLOR=${ROOTCOLOR}
  UIDBG=${ROOTBGCOLOR}
  UIDCHAR='#'
else
  UIDCOLOR=${NONROOTCOLOR}
  UIDBG=${NONROOTBGCOLOR}
  UIDCHAR='$'
fi

BASECOLOR=${UIDCOLOR}

prompt() {
  # last exitcode
  local CODE=${?}
  case ${CODE} in
    0)
      CODE=${OKCOLOR}${CODE}${TXTRST}
      ;;
    1)
      CODE=${CRITCOLOR}${CODE}${TXTRST}
      ;;
    *)
      CODE=${WARNCOLOR}${CODE}${TXTRST}
      ;;
  esac

  # save history
  history -a

  # loadavg info
  if [ "$(uname)" == "Linux" ]; then
    local LOAD=`cut -d\  -f${PROMPT_LOADAVGFIELD} /proc/loadavg`
    local threadcount=`egrep 'processor.+?\:' /proc/cpuinfo  | wc -l`
    local loadbase=`echo -n ${LOAD} | sed -u 's/\..*$//'`

  elif [ "$(uname)" == "Darwin" ]; then
    local LOAD=`sysctl -n vm.loadavg | sed 's/[\{\}]//' | cut -d\  -f${PROMPT_LOADAVGFIELD}`
    local threadcount=`sysctl -n machdep.cpu.thread_count`
    local loadbase=`echo -n ${LOAD} | sed 's/\..*$//'`
  fi

  if [ "$loadbase" -gt "$threadcount" ]; then
    LOAD=${CRITCOLOR}${LOAD}${TXTRST}
  elif [ "$loadbase" -gt "$(($threadcount/2))" ]; then
    LOAD=${WARNCOLOR}${LOAD}${TXTRST}
  else
    LOAD=${OKCOLOR}${LOAD}${TXTRST}
  fi


  PS1="${TERM_NAME}\n"
  PS1+="\n${UIDCOLOR}${UIDBG}${PROMPT_SPACER}${TXTRST}"
  case ${PROMPT_STYLE} in
    letters)
      PS1+="\n${UIDCOLOR}${UIDBG}${PROMPT_SPACER}${TXTRST} ${BASECOLOR}L:${LOAD}${BASECOLOR} E:${CODE}${TXTRST}"
      ;;
    blocks)
      PS1+="\n${UIDCOLOR}${UIDBG}${PROMPT_SPACER}${TXTRST} ${LOAD} ${CODE}${TXTRST}"
      ;;
    *)
      ;;
  esac
  PS1+="\n${UIDCOLOR}${UIDBG}${PROMPT_SPACER}${TXTRST} ${UIDCOLOR}\u${BASECOLOR} ${HOSTCOLOR}@\h${BASECOLOR} (${PATHCOLOR}\w${TXTRST}${BASECOLOR})"
  PS1+="\n${UIDCOLOR}${UIDBG}${UIDCHAR}${TXTRST} "
}

case "$TERM" in
  *term | rxvt* | xterm* | screen* )
    TERM_NAME="\\[\033]0;\$ \H:\w\007\\]"
    PROMPT_STYLE=blocks
    PROMPT_COMMAND=prompt
    ;;
  *)
    TERM_NAME=""
    PROMPT_STYLE=letters
    PROMPT_COMMAND=prompt
    ;;
esac