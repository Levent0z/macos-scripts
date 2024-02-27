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

if which fzf >/dev/null
then
    source "$MY_PATH/my_fzf.sh"
fi


if which npm >/dev/null
then
    source "$MY_PATH/npmcompletion.sh"
fi

source "$MY_PATH/my_git.sh"
source "$MY_PATH/my_gh.sh"
source "$MY_PATH/my_dev.sh"

if which corecli >/dev/null
then
    source "$MY_PATH/my_core.sh"
fi

if [[ -d "$HOME/git" ]]
then
    source "$MY_PATH/my_soma.sh"
fi

source "$MY_PATH/my_own.sh"
