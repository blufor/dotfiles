export TERM="rxvt-256color"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="${LC_ALL}"
export DEVDIR="${HOME}/devel"


[[ "${OS}" = "Linux" ]] && export VAGRANT_DEFAULT_PROVIDER=libvirt
[[ -e ~/.gnupg/gpg-agent-info ]] && source ~/.gnupg/gpg-agent-info

trap bell ERR
