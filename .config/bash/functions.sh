[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

xtitle() {
    case "$TERM" in
        *term | rxvt* | xterm*)
            echo -n -e "\033]0;$*\007" ;;
        *)
            ;;
    esac
}

psg() {
    ps axu | grep $* | grep -v grep
}

bell() {
  if [ "$#" -gt "0" ]; then
    eval time $*
    code=$?
    if [ "$code" -gt "0" ]; then
      color='\e[0;31m'
    else
      color='\e[0;32m'
    fi
    echo -e  "$color"
    echo -e  "CMD:\t$*"
    echo -en "CODE:\t$code"
    echo -en '\e[0m'
  fi
  tput bel
}
