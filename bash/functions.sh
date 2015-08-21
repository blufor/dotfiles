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

rp() {
  echo $* | sed -r s/\ /\\n/g | xargs -L1 -I{} ssh {} sudo PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin puppet agent -tv
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
    echo -e "cmd\t$*"
    echo -e "${color}code\t${code}\e[0m"
  fi
  tput bel
}
