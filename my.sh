declare NVM_UNAME="$(command uname -a)"
declare NVM_OS
case "$NVM_UNAME" in
Linux\ *)
    NVM_OS=linux
    ;;
Darwin\ *)
    NVM_OS=darwin
    ;;
SunOS\ *)
    NVM_OS=sunos
    ;;
FreeBSD\ *)
    NVM_OS=freebsd
    ;;
AIX\ *)
    NVM_OS=aix
    ;;
esac

declare MY_PATH
if [[ "$NVM_OS" == "darwin" ]]; then
    MY_PATH="$(cd "$(dirname "$0")" && pwd)"
else
    MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

source "$MY_PATH/my_sh.sh"
source "$MY_PATH/my_net.sh"
which fzf >/dev/null && source "$MY_PATH/my_fzf.sh"
which npm >/dev/null && source "$MY_PATH/npmcompletion.sh"
source "$MY_PATH/my_git.sh"
source "$MY_PATH/my_dev.sh"
which corecli >/dev/null && source "$MY_PATH/my_core.sh"
[ -d "$HOME/git" ] && source "$MY_PATH/my_soma.sh"
source "$MY_PATH/my_own.sh"

setcog
