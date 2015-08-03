unset PS1

PROMPT_LOADAVGFIELD="2"
HORIZONTAL_DIVIDER="-"
CORNER_TOP=`env printf '\u250C'`
CORNER_BOTTOM=`env printf '\u2514'`
VERTICAL_LINE=`env printf '\u2502'`
HORIZONTAL_LINE=`env printf '\u2500'`
LAMBDA=`env printf '\u03BB'`
RADIOACTIVE=`env printf '\u2622'`


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
  UIDCHAR=${LAMBDA}
else
  UIDCOLOR=${NONROOTCOLOR}
  UIDBG=${NONROOTBGCOLOR}
  UIDCHAR=${LAMBDA}
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
  if [ "${OS}" == "Linux" ]; then
    local LOAD=`cut -d\  -f${PROMPT_LOADAVGFIELD} /proc/loadavg`
    local threadcount=`egrep 'processor.+?\:' /proc/cpuinfo  | wc -l`
    local loadbase=`echo -n ${LOAD} | sed -u 's/\..*$//'`

  elif [ "${OS}" == "Darwin" ]; then
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

  HR_BUF=`for i in $(seq 0 500); do echo -n ${HORIZONTAL_LINE}; done`
  HR_LEN=${COLUMNS}-1

  PS1="${TERM_NAME}"
  case ${PROMPT_STYLE} in
    letters)
      PS1+="\n${BASECOLOR}${UIDBG}>${TXTRST} ${UIDCOLOR}\u${BASECOLOR}${HOSTCOLOR}@\h${BASECOLOR}:${PATHCOLOR}\w${TXTRST}${BASECOLOR}"
      PS1+="\n${BASECOLOR}${UIDBG}>${TXTRST} "
      ;;
    blocks)
      PS1+="\n${BASECOLOR}${CORNER_TOP}${HR_BUF:0:${HR_LEN}}${TXTRST}"
      PS1+="\n${BASECOLOR}${VERTICAL_LINE}${TXTRST} ${HOSTCOLOR}@\h${BASECOLOR}:${PATHCOLOR}\w${TXTRST}"
      # PS1+="\n${BASECOLOR}${VERTICAL_LINE}${TXTRST} "
      PS1+="\n${BASECOLOR}${VERTICAL_LINE}${TXTRST} ${LOAD} ${CODE}${TXTRST}"
      PS1+="\n${BASECOLOR}${CORNER_BOTTOM} ${UIDCHAR}${TXTRST} "
      ;;
    *)
      ;;
  esac
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